//
//  CancellationWrapper.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/7/27.
//

import Foundation
import Synchronization


/// A sendable class for cancelling tasks
///
/// It acts as a sendable wrapper for some cancellable task objects by using a lock to
/// guarantee thread safety.
/// A typical example is the [`withTaskCancellationHandler(operation:onCancel:)`], the following
/// code will have an error since the `NotSendableTask` is not Sendable
///
/// ```swift
/// var task: NotSendableTask?
/// await withTaskCancellationHandler {
///     await withCheckedContinuation { continuation in
///         task = .init {
///             // some operations
///             continuation.resume(returning: result)
///         }
///         task?.resume()
///     }
/// } onCancel: {
///     task?.cancel()    // error! task is not Sendable!
/// }
/// ```
///
/// With ``Canceller``, it can be rewritten as:
///
/// ```swift
/// var task: NotSendableTask?
/// let canceller = Canceller { task?.cancel() }
/// await withTaskCancellationHandler {
///     await withCheckedContinuation { continuation in
///         task = .init {
///             // some operations
///             continuation.resume(returning: result)
///         }
///         task?.resume()
///     }
/// } onCancel: {
///     canceller.cancel()
/// }
/// ```
///
/// It can also be used directly as an cancellation indicator
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
    
    public private(set) var isCancelled: Bool = false
    private let cancelOperation: () -> Void
    private let lock: NSLock = .init()
    
    public init(onCancel cancelOperation: @escaping () -> Void = {}) {
        self.cancelOperation = cancelOperation
    }
    
    public func cancel() {
        guard !isCancelled else { return }
        let doCleanUp = lock.withLock {
            guard !isCancelled else { return false }
            isCancelled = true
            return true
        }
        guard doCleanUp else { return }
        cancelOperation()
    }
    
}