import Foundation



extension Task<Never, Never> {

    /// Execute long running / blocking tasks on an ``DefaultTaskExecutor``
    /// - Parameters:
    ///   - executor: The executor for running the task, default is ``DefaultTaskExecutor/default``
    ///   - block: The operation of the task
    /// - Returns: The result of the operation
    ///
    /// This is basically a replacement for [`withTaskExecutorPreference(_:isolation:operation:)`].
    /// The ``DefaultTaskExecutor`` holds a GCD queue for running tasks so that the long running /
    /// blocking operations will not block threads in the global concurrent executor.
    ///
    /// - Warning: Unlike [`withTaskExecutorPreference(_:isolation:operation:)`], the task
    /// CANNOT contains `async` operations
    ///
    /// - Seealso: ``DefaultTaskExecutor``
    ///
    /// [`withTaskExecutorPreference(_:isolation:operation:)`]: https://developer.apple.com/documentation/swift/withtaskexecutorpreference(_:isolation:operation:)
    @available(macOS, introduced: 10.15, deprecated: 15, message: "use `withTaskExecutorPreference` instead")
    @available(iOS, introduced: 13.0, deprecated: 18, message: "use `withTaskExecutorPreference` instead")
    @available(watchOS, introduced: 6.0, deprecated: 11, message: "use `withTaskExecutorPreference` instead")
    @available(tvOS, introduced: 13.0, deprecated: 18, message: "use `withTaskExecutorPreference` instead")
    @available(visionOS, introduced: 1.0, deprecated: 2.0, message: "use `withTaskExecutorPreference` instead")
    public static func launch<R, E: Error>(
        on executor: FoundationPlusTaskExecutor = .default, 
        isolation: isolated (any Actor)? = #isolation,
        operation: @escaping () throws(E) -> R,
        onCancel cancelOperation: @Sendable () -> Void = {}
    ) async throws(E) -> R {

        do {

            return try await withTaskCancellationHandler {
           
                try await withCheckedThrowingContinuation { continuation in

                    let work = DispatchWorkItem {
                        do {
                            let result = try operation()
                            continuation.resume(returning: result)
                        } catch {
                            continuation.resume(throwing: error)
                        }
                    }

                    executor.queue.async(execute: work)

                }

            } onCancel: {
                cancelOperation()
            }

        } catch let error as E {
            throw error
        } catch {
            fatalError("Unexpected error: \(error)")
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
