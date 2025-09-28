//
//  Executor.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/8/14.
//

import Foundation


/// A Task Execution Context for offloading work to a GCD queue
///
/// ```swift
/// let executor = DispatchQueueTaskExecutor(
///     label: "foundation_plus.example",
///     qos: .background,
///     attributes: .concurrent
/// )
/// 
/// executor.submit {
///    // codes in this closure will be executed on the GCD queue
/// }
/// 
/// await executor.run {
///    // codes in this closure will be executed on the GCD queue
/// }
/// ```
///
/// Recomended to use the serveral provided executors as static properties:
/// * ``DispatchQueueTaskExecutor/main``: Use the [`DispatchQueue.main`] queue
/// * ``DispatchQueueTaskExecutor/global``: Use the [`DispatchQueue.global(qos:)`] queue with default qos
/// * ``DispatchQueueTaskExecutor/shared``: Use a predefined concurrent queue with default qos
/// * ``DispatchQueueTaskExecutor/background``: Use a predefined concurrent queue with background qos
///
/// You can also create a new custom task executor using using the ``init(label:qos:attributes:)``
/// initializer
/// 
/// [`DispatchQueue.main`]: https://developer.apple.com/documentation/dispatch/dispatchqueue/main
/// [`DispatchQueue.global(qos:)`]: https://developer.apple.com/documentation/dispatch/dispatchqueue/global(qos:)
public final class DispatchQueueTaskExecutor: TaskExecutionContext {
    
    /// The underlying GCD queue used for executing tasks
    public let queue: DispatchQueue
    
    init(queue: DispatchQueue) {
        self.queue = queue
    }
    
    /// Create a new custom task executor
    /// - Parameters:
    ///   - label: The label of the GCD queue used in this task executor
    ///   - qos: Quality of Service of the GCD queue used in this task executor, default is [`DispatchQoS/default`]
    ///   - attributes: Attributes of the GCD queue used in this task executor, default is [`DispatchQueue/Attributes/concurrent`]
    ///
    /// - Seealso: [`DispatchQoS`], [`DispatchQueue/Attributes`]
    ///
    /// [`DispatchQoS`]: https://developer.apple.com/documentation/dispatch/dispatchqos
    /// [`DispatchQoS/default`]: https://developer.apple.com/documentation/dispatch/dispatchqos/2016062-default
    /// [`DispatchQueue/Attributes`]: https://developer.apple.com/documentation/dispatch/dispatchqueue/attributes
    /// [`DispatchQueue/Attributes/concurrent`]: https://developer.apple.com/documentation/dispatch/dispatchqueue/attributes/2300052-concurrent
    public convenience init(
        label: String,
        qos: DispatchQoS = .default,
        attributes: DispatchQueue.Attributes = .concurrent
    ) {
        self.init(queue: .init(label: label, qos: qos, attributes: attributes))
    }


    public func submit(_ task: sending @escaping () -> Void) {
        nonisolated(unsafe) let task = task
        queue.async { task() }
    }
    
}


@available(macOS 15, iOS 18, watchOS 11, tvOS 18, visionOS 2, *)
extension DispatchQueueTaskExecutor: TaskExecutor {
    
    public func enqueue(_ job: consuming ExecutorJob) {
        let job = UnownedJob(job)
        queue.async {
            job.runSynchronously(on: self.asUnownedTaskExecutor())
        }
    }
    
}


extension DispatchQueueTaskExecutor {
    
    /// Task executor that runs on main thread
    /// - Warning: DO NOT use this task executor for blocking / long-running operations
    public static let main: DispatchQueueTaskExecutor = .init(queue: .main)
    /// Task executor that runs on the system global GCD queue
    public static let global: DispatchQueueTaskExecutor = .init(queue: .global())
    /// Task executor that runs on a GCD queue with background qos
    public static let background: DispatchQueueTaskExecutor =
        .init(label: "foundation_plus.default_queues.background", qos: .background, attributes: .concurrent)
    /// Task executor that runs on a GCD queue with default qos
    public static let shared: DispatchQueueTaskExecutor =
        .init(label: "foundation_plus.default_queues.default", attributes: .concurrent)
    
}



@available(macOS 15, iOS 18, watchOS 11, tvOS 18, visionOS 2, *)
extension TaskExecutor where Self == DispatchQueueTaskExecutor {
    /// Access group of predefined ``DispatchQueueTaskExecutor`` instances
    public static var foundationPlusDispatchExecutor: DispatchQueueTaskExecutor.Type { Self.self }
}



extension TaskExecutionContext where Self == DispatchQueueTaskExecutor {
    /// Access group of predefined ``DispatchQueueTaskExecutor`` instances
    public static var foundationPlusDispatchExecutor: DispatchQueueTaskExecutor.Type { Self.self }   
}
