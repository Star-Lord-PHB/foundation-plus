//
//  Executor.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/8/14.
//

import Foundation


/// An TaskExecutor for executing tasks in swift concurrency
///
/// It holds a GCD queue for actually running the tasks
///
/// ```swift
/// // after swift 6
/// await withTaskExecutorPreference(.defaultExecutor.io) {
///     // task that will be executed on the executor
/// }
///
/// // before swift 6
/// await launchTask(on: .io) {
///     // task that will be executed on the executor
/// }
/// ```
///
/// Recomended to use the serveral provided executors as static properties:
/// * ``DefaultTaskExecutor/main``
/// * ``DefaultTaskExecutor/global``
/// * ``DefaultTaskExecutor/default``
/// * ``DefaultTaskExecutor/io``
/// * ``DefaultTaskExecutor/background``
/// * ``DefaultTaskExecutor/immediate``
///
/// You can also create a new custom task executor using using the ``init(label:qos:attributes:)``
/// initializer
public final class DefaultTaskExecutor: Sendable {
    
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
    
}


@available(macOS 15, iOS 18, watchOS 11, tvOS 18, visionOS 2, *)
extension DefaultTaskExecutor: TaskExecutor {
    
    public func enqueue(_ job: consuming ExecutorJob) {
        let job = UnownedJob(job)
        queue.async {
            job.runSynchronously(on: self.asUnownedTaskExecutor())
        }
    }
    
}


extension DefaultTaskExecutor {
    
    /// Task executor that runs on main thread
    /// - Warning: DO NOT use this task executor for blocking / long-running operations
    public static let main: DefaultTaskExecutor = .init(queue: .main)
    /// Task executor that runs on the system global GCD queue
    public static let global: DefaultTaskExecutor = .init(queue: .global())
    /// Task executor that runs on a GCD queue with background qos
    public static let background: DefaultTaskExecutor =
        .init(label: "foundation_plus.default_queues.background", qos: .background, attributes: .concurrent)
    /// Task executor specifically for io operations, runs on a GCD queue with default qos
    public static let io: DefaultTaskExecutor =
        .init(label: "foundation_plus.default_queues.io", attributes: .concurrent)
    /// Task executor with highest priority, runs on a GCD queue with userInteractive qos
    /// - Warning: DO NOT use this task executor for blocking / long-running operations
    public static let immediate: DefaultTaskExecutor =
        .init(label: "foundation_plus.default_queues.immediate", qos: .userInteractive, attributes: .concurrent)
    /// Task executor that runs on a GCD queue with default qos
    public static let `default`: DefaultTaskExecutor =
        .init(label: "foundation_plus.default_queues.default", attributes: .concurrent)
    
}



@available(macOS 15, iOS 18, watchOS 11, tvOS 18, visionOS 2, *)
extension TaskExecutor where Self == DefaultTaskExecutor {
    
    public static var defaultExecutor: DefaultTaskExecutor.Type { DefaultTaskExecutor.self }
    
}