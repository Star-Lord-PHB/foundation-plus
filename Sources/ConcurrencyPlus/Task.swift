import Foundation



extension Task<Never, Never> {

    private final class ClosureHolder<R, E> {
        @usableFromInline var closure: (() throws(E) -> R)?
        init(closure: (() throws(E) -> R)?) {
            self.closure = closure
        }
    }

    private struct SendableWrapper<T>: @unchecked Sendable {
        @usableFromInline var value: T
        init(value: T) {
            self.value = value
        }
    }


    /// Execute long running / blocking tasks on an ``DefaultTaskExecutor``
    /// - Parameters:
    ///   - executor: The executor for running the task, default is ``DefaultTaskExecutor/default``
    ///   - operation: The operation of the task
    ///   - cancelOperation: The operation to be executed when the task is cancelled
    /// - Returns: The result of the operation
    ///
    /// This is basically a replacement for [`withTaskExecutorPreference(_:isolation:operation:)`].
    /// The ``DefaultTaskExecutor`` holds a GCD queue for running tasks so that the long running /
    /// blocking operations will not block threads in the global concurrent executor.
    /// 
    /// The main usecase is to quickly adopt a long running / blocking operation to async context. 
    /// Otherwise, consider using [`withTaskExecutorPreference(_:isolation:operation:)`]
    ///
    /// - Warning: Unlike [`withTaskExecutorPreference(_:isolation:operation:)`], the task
    /// CANNOT contains `async` operations
    ///
    /// - Seealso: ``FoundationPlusTaskExecutor``
    ///
    /// [`withTaskExecutorPreference(_:isolation:operation:)`]: https://developer.apple.com/documentation/swift/withtaskexecutorpreference(_:isolation:operation:)
    public static func launch<R, E: Error>(
        on executor: FoundationPlusTaskExecutor = .default, 
        isolation: isolated (any Actor)? = #isolation,
        operation: () throws(E) -> R,
        onCancel cancelOperation: @Sendable () -> Void = {}
    ) async throws(E) -> R {

        if #available(macOS 15, iOS 18, watchOS 11, tvOS 18, visionOS 2, *) {
            try await launchNew(on: executor, operation: operation, onCancel: cancelOperation)
        } else {
            try await launchCompat(on: executor, operation: operation, onCancel: cancelOperation)
        }

    } 


    @available(macOS 15, iOS 18, watchOS 11, tvOS 18, visionOS 2, *)
    static func launchNew<R, E: Error>(
        on executor: FoundationPlusTaskExecutor = .default, 
        isolation: isolated (any Actor)? = #isolation,
        operation: () throws(E) -> R,
        onCancel cancelOperation: @Sendable () -> Void = {}
    ) async throws(E) -> R {

        do {
            return try await withTaskExecutorPreference(executor) {
                try await withTaskCancellationHandler {
                    try operation()
                } onCancel: {
                    cancelOperation()
                }
            }
        } catch let error as E {
            throw error
        } catch {
            fatalError("""
                Unexpected error: \(error)
                Expect error to be of type \(E.self)
                """
            )
        }

    }


    static func launchCompat<R, E: Error>(
        on executor: FoundationPlusTaskExecutor = .default, 
        isolation: isolated (any Actor)? = #isolation,
        operation: () throws(E) -> R,
        onCancel cancelOperation: @Sendable () -> Void = {}
    ) async throws(E) -> R {

        do {

            return try await withTaskCancellationHandler {

                try await withoutActuallyEscaping(operation) { escapingClosure in

                    let holderPtr = UnsafeMutablePointer<ClosureHolder<R, E>>.allocate(capacity: 1)
                    holderPtr.initialize(to: .init(closure: nil))
                    holderPtr.pointee.closure = escapingClosure

                    let wrapped = SendableWrapper(value: holderPtr)
                
                    return try await withCheckedThrowingContinuation { continuation in

                        executor.queue.async {
                            do {
                                let result = try wrapped.value.pointee.closure!()
                                wrapped.value.deinitialize(count: 1)
                                wrapped.value.deallocate()
                                continuation.resume(returning: result)
                            } catch {
                                wrapped.value.deinitialize(count: 1)
                                wrapped.value.deallocate()
                                continuation.resume(throwing: error)
                            }
                        }

                    }

                }

            } onCancel: {
                cancelOperation()
            }

        } catch let error as E {
            throw error
        } catch {
            fatalError("""
                Unexpected error: \(error)
                Expect error to be of type \(E.self)
                """
            )
        }

    }

}


@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension Task {

    /// Cancel the task and wait until it is truely stopped
    public func cancelAndWait() async {
        cancel()
        await wait()
    }


    /// Wait for the task to stop
    public func wait() async {
        _ = await result
    }


    /// Wait for the task to stop and throw the error if there is any
    public func waitThrowing() async throws {
        _ = try await value
    }

}


@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension Task<Never, Never> {

    /// Wait until certain condition to be true
    /// - Parameters:
    ///   - condition: The condition to wait on, will wait until it returns true
    ///   - checkInterval: The time interval for checking whether the condition is true
    public static func waitUntil(
        _ condition: () -> Bool,
        checkInterval: Duration = .milliseconds(100)
    ) async throws {
        while !condition() {
            try await Task.sleep(for: checkInterval)
        }
    }

}
