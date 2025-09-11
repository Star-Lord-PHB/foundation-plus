import Foundation
import DequeModule


/// A simple thread pool for offloading work to a fixed number of threads
/// 
/// ## Creating and Starting a Thread Pool
/// 
/// A thread pool can be created with the ``init(threadCount:canStop:)`` initializer. 
/// After that, call the ``ThreadPool/start()`` method to start the pool. Tasks can 
/// only be submitted after the pool is started.
/// 
/// ```swift
/// // Create a thread pool with 4 threads
/// let pool = ThreadPool(threadCount: 4)
/// // Start the thread pool
/// pool.start()
/// ```
/// 
/// - Note: When creating a thread pool for being used globally, it is usually a good idea to set
///        `canStop` to `false` when creating the thread pool to avoid accidental shutdown.
/// 
/// ## Submitting Tasks to the Thread Pool
/// 
/// To submit a task without caring about the results, use the ``ThreadPool/submit(_:)`` method.
/// 
/// ```swift
/// // Submit a task to the thread pool
/// pool.submit {
///     print("Hello from thread: \(Thread.current)")
/// }
/// ```
/// 
/// To get the execution result of a task, use either the ``ThreadPool/run(task:onComplete:)`` method
/// and handle results in the completion callback, or the async version ``ThreadPool/run(task:)``
/// 
/// ```swift
/// // Submit a task with completion callback
/// pool.run {
///     print("Hello from thread: \(Thread.current)")
///    return 42
/// } onComplete: { result in 
///     // handle result
/// }
/// 
/// // Submit a task and await its result
/// let result: Int = try await pool.run {
///     print("Hello from thread: \(Thread.current)")
///     return 42
/// }
/// ```
/// 
/// On macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0 and later, ``ThreadPool`` conforms to
/// the [`TaskExecutor`] protocol, allowing it to be used as a task executor preference in Swift concurrency.
/// 
/// ```swift
/// await withTaskExecutorPreference(pool) {
///     // codes in this closure will be executed on the thread pool
/// }
/// ```
/// 
/// ## Shutting Down a Thread Pool
/// 
/// When a thread pool is no longer needed, call the ``ThreadPool/shutdown(onComplete:)``
/// method or the async version ``ThreadPool/shutdownAsync()`` to release resources. 
/// 
/// The thread pool cannot be restarted after being shutdown. Calling ``ThreadPool/start()``
/// again will have no effect.
/// 
/// ```swift
/// // Shutdown the thread pool with a completion callback
/// pool.shutdown {
///     print("Thread pool has been shutdown")
/// }
/// 
/// // Shutdown the thread pool and await its completion
/// await pool.shutdownAsync()
/// ```
/// 
/// ## Predefined Thread Pools
///
/// This module provides one predefined thread pool ``ThreadPool/shared`` with 4 threads that 
/// cannot be stopped.
///
/// [`TaskExecutor`]: https://developer.apple.com/documentation/swift/taskexecutor
public final class ThreadPool: TaskExecutionContext {

    private var threads: [JoinableThread] = []
    private var works: Deque<() -> Void> = .init()

    private let conditionLock: SyncedConditionalLock = .init()

    /// The number of threads in the pool
    public let threadCount: Int
    /// The current state of the thread pool
    /// 
    /// - Seealso: ``ThreadPool/State``
    public private(set) var state: State = .ready
    /// Whether the thread pool can be stopped / shutdown.
    /// 
    /// If set to `false`, calling the ``ThreadPool/shutdown(onComplete:)`` or 
    /// ``ThreadPool/shutdownAsync()`` methods will have no effect.
    public let canStop: Bool


    /// Create a new thread pool with the specified number of threads
    /// - Parameter threadCount: The number of threads in the pool, must be greater than 0. Default to 1.
    /// - Parameter canStop: Whether the thread pool can be stopped / shutdown. Default to `true`.
    /// 
    /// - Note: When creating a thread pool for being used globally, it is usually a good idea to set
    ///        `canStop` to `false` to avoid accidental shutdown.
    public init(threadCount: Int = 1, canStop: Bool = true) {
        self.threadCount = threadCount
        self.canStop = canStop
        for _ in 0 ..< threadCount {
            threads.append(.init { [weak self] in self?.threadTask() })
        }
    }


    deinit {
        assert(canStop, "ThreadPool that cannot be stopped is being deinitialized, which should not happen.")
        shutdown()
    }


    /// Start the thread pool, making it ready to accept and execute tasks.
    /// 
    /// - Attention: Should only be called once after the pool is created. Calling multiple times 
    /// or calling it after the pool has been shutdown will have no effect.
    public func start() {
        let shouldStart = conditionLock.withLock {
            guard state == .ready else { return false }
            state = .running
            return true
        }
        guard shouldStart else { return }
        threads.forEach { $0.start() }
    }


    /// Shutdown the thread pool, releasing all resources.
    /// 
    /// - Parameter onComplete: A closure that will be called when the shutdown is complete.
    /// 
    /// The shutdown process will stop and wait for all the threads in the pool to terminate 
    /// in a background queue. Once all threads have terminated, the `onComplete` closure will 
    /// be called.
    /// 
    /// - Attention: The thread pool cannot be restarted after being shutdown.
    /// - Attention: If ``ThreadPool/canStop`` is set to `false`, calling this method will have no effect.
    public func shutdown(onComplete: @Sendable @escaping () -> Void = {}) {
        guard canStop else { return }
        let doShutdown = conditionLock.withLock {
            guard state == .running else { return false }
            state = .stopping
            conditionLock.broadcast()
            return true
        }
        guard doShutdown && state == .stopping else { return }
        DispatchQueue(label: "foundation_plus.thread_pool.shutdown").async {
            self.works.removeAll()
            for thread in self.threads {
                thread.join()
            }
            self.conditionLock.withLock {
                self.state = .stopped
                self.conditionLock.broadcast()
            }
            onComplete()
        }
    }


    /// Submit a task to the thread pool for execution.
    /// - Parameter task: A closure of the task to be executed in the thread pool.
    /// 
    /// This method does not provide any way to get the result of the task. For that, 
    /// consider using the ``ThreadPool/run(task:onComplete:)`` or ``ThreadPool/run(task:)``.
    public func submit(_ task: sending @escaping () -> Void) {
        conditionLock.withLock {
            guard state.running else { return }
            works.append(task)
            conditionLock.signal()   
        }
    }


    private func threadTask() {
        while state.running {
            let work = conditionLock.wait(until: { state == .stopped || state == .stopping || !works.isEmpty }) { 
                (state == .stopped || state == .stopping) ? nil : works.popFirst()
            }
            guard let work else { break }
            work()
        }
    }

}


extension ThreadPool: @unchecked Sendable {}


extension ThreadPool: CustomStringConvertible {

    public var description: String {
        return "ThreadPool(threadCount: \(threadCount), state: \(state))"
    }

}


extension ThreadPool {

    /// The state of the thread pool
    /// 
    /// - ``State/ready``: The pool is created but not started yet, cannot accept tasks
    /// - ``State/running``: The pool is running and can accept and execute tasks
    /// - ``State/stopping``: The pool is shutting down and waiting for all threads to terminate, 
    ///                       no new tasks will be accepted
    /// - ``State/stopped``: The pool has been shutdown, cannot accept tasks or be restarted
    public enum State {
        /// The pool is created but not started yet, cannot accept tasks
        case ready 
        /// The pool is running and can accept and execute tasks
        case running
        /// The pool is shutting down and waiting for all threads to terminate,
        case stopping
        /// The pool has been shutdown, cannot accept tasks or be restarted
        case stopped

        /// Whether the pool is in the ``State/running`` state
        public var running: Bool {
            switch self {
            case .running: return true
            default: return false
            }
        }
        /// Whether the pool is in the ``State/stopped`` state
        public var stopped: Bool {
            switch self {
            case .stopped: return true
            default: return false
            }
        }
    }

}


extension ThreadPool {

    /// Shutdown the thread pool, releasing all resources and await until the process is completed.
    public func shutdownAsync() async {
        await withCheckedContinuation { continuation in
            self.shutdown {
                continuation.resume()
            }
        }
    }

}



extension ThreadPool {

    /// Check whether the current code is running on one of the threads in the thread pool before proceeding.
    /// 
    /// - Parameter file: The file in which this method is called 
    /// - Parameter line: The line number at which this method is called
    /// 
    /// In both `-Onone` and `-O` build, the program will be stopped if the current code is not running on 
    /// any thread in the thread pool. However, in `-Ounchecked` build, the condition will not be checked. 
    public func assertOnThreadPool(file: StaticString = #file, line: UInt = #line) {
        precondition(
            threads.contains(where: { $0 == Thread.current }), 
            "Not running on desired thread pool: \(self)", 
            file: file, line: line
        )
    }

}



extension ThreadPool {

    /// A predefined thread pool with 4 threads that cannot be stopped.
    public static let shared4Thread: ThreadPool = {
        let pool = ThreadPool(threadCount: 4, canStop: false)
        pool.start()
        return pool
    }()

}