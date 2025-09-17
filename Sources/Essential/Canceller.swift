//
//  CancellationWrapper.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/7/27.
//

import Foundation


/// A sendable class (Thread Safe) for cancelling tasks.
/// 
/// It indicates whether the current task should be cancelled with its ``isCancelled`` property.
///
/// ```swift
/// let canceller = Canceller()
/// let sum = await withTaskCancellationHandler {
///     var sum = 0
///     for i in 0 ..< 1000 {
///         if canceller.isCancelled { break }
///         sum += i
///     }
///     return sum
/// } onCancel: {
///     canceller.cancel()
/// }
/// ```
///
/// [`withTaskCancellationHandler(operation:onCancel:)`]: https://developer.apple.com/documentation/swift/withtaskcancellationhandler(operation:oncancel:)
public final class Canceller: @unchecked Sendable {
    
    /// Indicates whether the current task should be cancelled.
    public private(set) var isCancelled: Bool = false
    private var cancelOperation: (() -> Void)?
    private let lock: NSLock = .init()
    
    public init(onCancel cancelOperation: sending (() -> Void)? = nil) {
        self.cancelOperation = cancelOperation
    }

    /// Sets the operation to be performed when the task is cancelled.
    ///
    /// - Attention: Can only be invoked ONCE before the task is cancelled.
    /// Subsequent invocations or invocations after cancellation will have no effect.
    public func setOnCancel(_ cancelOperation: sending @escaping () -> Void) {
        guard self.cancelOperation == nil && !isCancelled else { return }
        self.lock.withLock {
            guard self.cancelOperation == nil && !isCancelled else { return }
            self.cancelOperation = cancelOperation
        }
    }
    
    /// Cancels the task and performs the cancellation operation if provided.
    /// 
    /// - Attention: If the task is already cancelled, this method has no effect.
    public func cancel() {
        guard !isCancelled else { return }
        let doCleanUp = lock.withLock {
            guard !isCancelled else { return false }
            isCancelled = true
            return true
        }
        guard doCleanUp else { return }
        cancelOperation?()
    }

    /// Throws a [`CancellationError`] if the task has been cancelled.
    /// 
    /// [`CancellationError`]: https://developer.apple.com/documentation/swift/cancellationerror
    public func checkCancellation() throws(CancellationError) {
        if isCancelled {
            throw CancellationError()
        }
    }
    
}



/// A sendable class (Thread Safe) for cancelling tasks with handlers.
/// 
/// It is designed for tasks that provide certain non-sendable handler objects for cancellation by taking the
/// ownership of the handler object and help invoke the cancellation operation on it when needed in a 
/// thread-safe manner.
/// 
/// To create a ``TaskCanceller``, first invoke the initializer with the type of the handler object and a closure 
/// specifying how to cancel the task with the handler object.
/// 
/// ```swift
/// let canceller = TaskCanceller(for: MyTask.self, onCancel: { $0.cancel() })
/// ```
/// 
/// Then, provide the handler object with the ``prepare(with:)`` method.
/// 
/// ```swift
/// let myTask = makeTask()
/// myTask.resume()
/// canceller.prepare(with: consume myTask)
/// ```
/// 
/// Or, you can also provide the handler object using a closure passed to the ``prepare(_:)`` method that returns 
/// the handler object.
/// 
/// ```swift
/// canceller.prepare {
///     let myTask = makeTask()
///     myTask.resume()
///     return myTask
/// }
/// ```
/// 
/// Finally, use the ``cancel()`` method to cancel the task when needed, which will invoke the cancellation operation 
/// provided in the initializer.
///
/// ```swift
/// canceller.cancel()
/// ```
/// 
/// > Attention: 
/// > ``prepare(with:)``, ``prepare(_:)`` and ``cancel()`` methods are all designed to be call-once operations, where
/// > ``prepare(with:)`` and ``prepare(_:)`` together can only be invoked once. Subsequent invocations will have no effect.
/// 
/// > Note:
/// > ``prepare(with:)`` and ``prepare(_:)`` can be invoked after calling ``cancel()`` method, in which case the provided 
/// > handler object will be immediately cancelled.
/// 
/// ## Example
/// 
/// Consider an example of adopting [`URLSessionDataTask`] with Swift concurrency, we may want to write 
/// implementation like this:
/// 
/// ```swift
/// var task: URLSessionDataTask? = nil
///
/// let result = try await withTaskCancellationHandler {
///     try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Data, Error>) in
///         task = URLSession.shared.dataTask(with: .init(string: "https://www.swift.org")!) { data, response, error in
///             if let error {
///                 continuation.resume(throwing: error)
///             } else {
///                 continuation.resume(returning: data ?? .init())
///             }
///         }
///         task!.resume()
///     }
/// } onCancel: {
///     task?.cancel()  // error: Reference to captured var 'task' in concurrently-executing code
/// }
/// ```
/// 
/// This code has two problems, first, it does not compile since a mutable variable `task` is captured by a
/// @Sendable closure passed to the `onCancel` parameter. Second, if the `cancel` method is called before the 
/// `task` variable is assigned, it will not have any effect.
/// 
/// This ``TaskCanceller`` class can help solve these problems by rewriting the above code as follows:
/// 
/// ```swift
/// let canceller = TaskCanceller<URLSessionDataTask>(onCancel: { $0.cancel() })
///
/// let result = try await withTaskCancellationHandler {
///     try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Data, Error>) in
///         let task = URLSession.shared.dataTask(with: .init(string: "https://www.swift.org")!) { data, response, error in
///             if let error {
///                 continuation.resume(throwing: error)
///             } else {
///                 continuation.resume(returning: data ?? .init())
///             }
///         }
///         task.resume()
///         // URLSessionDataTask is copyable, so it's recommended to use the `consume` keyword here to avoid any future
///         // access after this call.
///         canceller.prepare(with: consume task)
///     }
/// } onCancel: {
///     canceller.cancel()  // no error!
/// }
/// ```
/// 
/// This version not just compiles under strict concurrency check, it also guarantees that the `cancel` method
/// will always have the intended effect even if it is called before the ``TaskCanceller/prepare`` method.
/// 
/// [`URLSessionDataTask`]: https://developer.apple.com/documentation/foundation/urlsessiondatatask
public final class TaskCanceller<TaskHandler: ~Copyable>: @unchecked Sendable {

    private var task: TaskHandler?
    private let lock: NSLock = .init()
    private let cancelOperation: (inout TaskHandler) -> Void
    /// Whether the task is cancelled.
    public private(set) var isCancelled: Bool = false

    public init(
        for taskHandlerType: TaskHandler.Type = TaskHandler.self, 
        onCancel cancelOperation: sending @escaping (inout TaskHandler) -> Void
    ) {
        self.cancelOperation = cancelOperation
    }

    /// Sets the task handler object using a closure that returns the handler object.
    /// 
    /// - Parameter prepareOperation: A closure that returns the handler object. 
    ///                               Should transfer the ownership of the handler object
    /// 
    /// If the task has already been cancelled when this method is invoked, it will immediately perform the
    /// cancellation operation.
    ///
    /// - Attention: This method together with ``prepare(with:)`` can only be invoked ONCE. Subsequent invocations
    /// will have no effect.
    public func prepare(_ prepareOperation: () -> sending TaskHandler) {

        guard task == nil else { return }

        let doCancel = lock.withLock {
            guard task == nil else { return false }
            // guarantee: task == nil
            task = prepareOperation()
            return isCancelled
        }

        // guarantee: task != nil

        if doCancel {
            // guarantee: isCancelled == true && task != nil
            cancelOperation(&task!)
        }

    }


    /// Sets the task handler object.
    /// 
    /// - Parameter task: The handler object. Will take away the ownership of the handler object.
    /// 
    /// If the task has already been cancelled when this method is invoked, it will immediately perform the
    /// cancellation operation.
    ///
    /// - Attention: This method together with ``prepare(_:)`` can only be invoked ONCE. Subsequent invocations will
    /// have no effect.
    public func prepare(with task: consuming sending TaskHandler) {

        guard self.task == nil else { return }

        var doCancel = false

        do {
            lock.lock()
            defer { lock.unlock() }
            guard self.task == nil else { return }
            // guarantee: self.task == nil
            self.task = consume task
            doCancel = self.isCancelled
        }

        // guarantee: self.task != nil

        if doCancel {
            // guarantee: self.isCancelled == true && self.task != nil
            cancelOperation(&self.task!)
        }

    }


    /// Cancels the task and performs the cancellation operation on the handler object.
    /// 
    /// There are two situations when this method is invoked:
    /// * If the task handler object has been provided with either ``prepare(with:)`` or ``prepare(_:)``, it will 
    ///   perform the cancellation operation on the handler object and set ``isCancelled`` to `true`.
    /// * If the task handler object has NOT been provided yet, it will only set ``isCancelled`` to `true` without
    ///   performing any cancellation operation. In this case, the cancellation operation will be performed
    ///   immediately when calling either ``prepare(with:)`` or ``prepare(_:)``.
    ///
    /// - Attention: Should only be invoked ONCE. Subsequent invocations will have no effect.
    public func cancel() {

        guard !isCancelled else { return }

        let doCancel = lock.withLock {
            guard !isCancelled else { return false }
            isCancelled = true
            return task != nil
            // guarantee: isCancelled == true 
        }

        // guarantee: isCancelled == true 

        guard doCancel else { return }

        // guarantee: task != nil && isCancelled == true 

        cancelOperation(&task!)

    }


    /// Access the underlying task handler object held by this canceller in a thread-safe manner within the closure.
    /// 
    /// Designed mainly for testing and debugging purposes.
    /// 
    /// - Parameter body: A closure that provides a limited and thread-safe scope to access the task handler object.
    /// 
    /// - Warning: DO NOT escape the task handler object from the closure or using it to bypass any safety guarantees, 
    /// which can lead to undefined behavior.
    public func unsafeWithTaskHandler<T, E: Error>(_ body: (inout TaskHandler?) throws(E) -> T) throws(E) -> T {
        lock.lock()
        defer { lock.unlock() }
        return try body(&task)
    }

}