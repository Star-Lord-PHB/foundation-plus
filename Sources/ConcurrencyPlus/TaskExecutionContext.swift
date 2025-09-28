import Foundation



/// A protocol of execution context that can accept tasks and execute them asynchronously
/// 
/// This aims as offloading long running / blocking tasks in async contexts to a more predictable and controllable
/// environment than the global concurrent executor.
/// 
/// To implement a custom execution context, conform to this protocol and provide an implementation for the
/// ``TaskExecutionContext/submit(_:)`` method to accept the task to be executed. Then inside an async context,
/// use ``TaskExecutionContext/run(task:)`` to offload the task to the execution context.
/// 
/// - Attention: After Swift 6 with iOS 18, macOS 15, watchOS 11, tvOS 18 and visionOS 2, it is more recommended
///              to use [`TaskExecutor`] instead of this protocol.
/// 
/// [`TaskExecutor`]: https://developer.apple.com/documentation/swift/taskexecutor
/// [`withTaskExecutorPreference(_:isolation:operation:)`]: https://developer.apple.com/documentation/swift/withtaskexecutorpreference(_:isolation:operation:)
public protocol TaskExecutionContext: Sendable, AnyObject {

    /// Submit a task to be executed asynchronously in the execution context.
    /// 
    /// - Parameter task: A closure representing the task to be executed.
    func submit(_ task: sending @escaping () -> Void)

}



extension TaskExecutionContext {

    /// Run a task asynchronously in the execution context, and call the callback closure with the execution 
    /// results when the task is completed.
    /// 
    /// - Parameter task: A closure representing the task to be executed.
    /// - Parameter callback: A closure to be called when the task is completed, with a [`Result`] containing either the
    ///                       return value of the task or an error if the task throws.
    /// 
    /// [`Result`]: https://developer.apple.com/documentation/swift/result
    public func run<R, E: Error>(
        task: sending @escaping () throws(E) -> R, 
        onComplete callback: sending @escaping (sending Result<R, E>) -> Void
    ) {
        self.submit {
            do throws(E) {
                try callback(.success(task()))
            } catch {
                callback(.failure(error))
            }
        }
    }


    /// Run a task asynchronously in the execution context, and await for the result.
    /// 
    /// - Parameter task: A closure representing the task to be executed.
#if swift(>=6.2)
    @concurrent
#endif
    public func run<R, E: Error>(task: () throws(E) -> R) async throws(E) -> R {

        do {

            return try await withoutActuallyEscaping(task) { localClosure in 
                
                nonisolated(unsafe) var localClosure = Optional(consume localClosure as (() throws -> R))

                return try await withCheckedThrowingContinuation { continuation in 

                    self.submit { @Sendable in
                        do {
                            let closure = localClosure.take()!
                            let value = try closure()
                            _ = consume closure
                            continuation.resume(returning: value)
                        } catch {
                            continuation.resume(throwing: error)
                        }
                    }

                }

            }

        } catch let error as E {
            throw error
        } catch {
            fatalError("Expect error of type \(E.self), got \(type(of: error))")
        }

    }

}
