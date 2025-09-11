import Foundation



@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
extension ThreadPool: TaskExecutor {

    public func enqueue(_ job: consuming ExecutorJob) {
        let job = UnownedJob(job)
        self.submit {
            job.runSynchronously(on: self.asUnownedTaskExecutor())
        }
    }

}



@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
extension TaskExecutor where Self == ThreadPool {
    /// Access group of predefined ``ThreadPool`` instances as [`TaskExecutor`]
    /// 
    /// [`TaskExecutor`]: https://developer.apple.com/documentation/swift/taskexecutor
    public static var foundationPlusThreadPoolExecutor: ThreadPool.Type { Self.self }
}



extension TaskExecutionContext where Self == ThreadPool {
    /// Access group of predefined ``ThreadPool`` instances as ``TaskExecutionContext``
    public static var foundationPlusThreadPoolExecutor: ThreadPool.Type { Self.self }
}