import Foundation



@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public func launchTask<Result>(
    on executor: DefaultTaskExecutor = .default,
    operation block: @escaping () throws -> Result,
    onCancel cancelOperation: @Sendable () -> Void = {}
) async throws -> Result {

    return try await withTaskCancellationHandler {

        try await withCheckedThrowingContinuation { continuation in

            let workItem = DispatchWorkItem {
                do {
                    let result = try block();
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }

            executor.queue.async(execute: workItem)

        }

    } onCancel: {
        cancelOperation()
    }

}


@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public func launchTask<Result>(
    on executor: DefaultTaskExecutor = .default,
    operation block: @escaping () -> Result,
    onCancel cancelOperation: @Sendable () -> Void = {}
) async -> Result {

    return await withTaskCancellationHandler {

        await withCheckedContinuation { continuation in

            let workItem = DispatchWorkItem {
                continuation.resume(returning: block())
            }

            executor.queue.async(execute: workItem)

        }

    } onCancel: {
        cancelOperation()
    }

}


@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension Task where Failure == Error {

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
    public static func launch(
        on executor: DefaultTaskExecutor = .default,
        operation block: @escaping () throws -> Success,
        onCancel cancelOperation: @Sendable () -> Void = {}
    ) async rethrows -> Success {

        return try await withTaskCancellationHandler {

            try await withCheckedThrowingContinuation { continuation in

                let workItem = DispatchWorkItem {
                    do {
                        let result = try block();
                        continuation.resume(returning: result)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }

                executor.queue.async(execute: workItem)

            }

        } onCancel: {
            cancelOperation()
        }

    }

}


@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension Task where Failure == Never {

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
    public static func launch(
        on executor: DefaultTaskExecutor = .default,
        _ block: @Sendable @escaping () -> Success,
        onCancel cancelOperation: @Sendable () -> Void = {}
    ) async -> Success {

        return await withTaskCancellationHandler {

            await withCheckedContinuation { continuation in
                executor.queue.async {
                    continuation.resume(returning: block())
                }
            }

        } onCancel: {
            cancelOperation()
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
