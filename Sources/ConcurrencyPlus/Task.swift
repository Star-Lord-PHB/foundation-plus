import Foundation



extension Task<Never, Never> {

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
    @available(macOS, deprecated: 15, message: "use withTaskExecutorPreference(_:isolation:operation:) instead")
    @available(iOS, deprecated: 18, message: "use withTaskExecutorPreference(_:isolation:operation:) instead")
    @available(watchOS, deprecated: 11, message: "use withTaskExecutorPreference(_:isolation:operation:) instead")
    @available(tvOS, deprecated: 18, message: "use withTaskExecutorPreference(_:isolation:operation:) instead")
    @available(visionOS, deprecated: 2, message: "use withTaskExecutorPreference(_:isolation:operation:) instead")
#if swift(>=6.2)
    @concurrent
#endif
    public static func offload<R, E: Error>(
        on executor: any TaskExecutionContext = .foundationPlusDispatchExecutor.shared, 
        operation: () throws(E) -> R,
        onCancel cancelOperation: sending () -> Void = {}
    ) async throws(E) -> R {
        
        do {

            nonisolated(unsafe) let cancelOperation = cancelOperation

            return try await withTaskCancellationHandler { 
                try await executor.run(task: operation)
            } onCancel: {
                cancelOperation()
            }

        } catch let error as E {
            throw error
        } catch {
            fatalError("Expect error to be of type \(E.self), but got \(error)")
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
        checkInterval: Duration = .milliseconds(100),
        isolation: isolated (any Actor)? = #isolation
    ) async throws {
        while !condition() {
            try await Task.sleep(for: checkInterval)
        }
    }

}
