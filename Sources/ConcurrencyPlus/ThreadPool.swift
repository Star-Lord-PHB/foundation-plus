import Foundation
import DequeModule


/// A simple thread pool for offloading work to a fixed number of threads
/// 
/// After a thread pool is created, call the ``ThreadPool/start()`` method to start the pool.
/// Tasks can only be submitted after the pool is started.
/// 
/// ```swift
/// // Create a thread pool with 4 threads
/// let pool = ThreadPool(threadCount: 4)
/// // Start the thread pool
/// pool.start()
/// ```
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
public final class ThreadPool {

    private var threads: [JoinableThread] = []
    private var works: Deque<() -> Void> = .init()

    private let conditionLock: SyncedConditionalLock = .init()

    /// The number of threads in the pool
    public let threadCount: Int
    /// The current state of the thread pool
    /// 
    /// - Seealso: ``ThreadPool/State``
    public private(set) var state: State = .ready


    /// Create a new thread pool with the specified number of threads
    /// - Parameter threadCount: The number of threads in the pool, must be greater than 0. Default to 1.
    public init(threadCount: Int = 1) {
        self.threadCount = threadCount
        for _ in 0 ..< threadCount {
            threads.append(.init { [weak self] in self?.threadTask() })
        }
    }


    deinit {
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
    public func shutdown(onComplete: @Sendable @escaping () -> Void = {}) {
        let doShutdown = conditionLock.withLock {
            guard state == .running else { return false }
            state = .stopping
            works.removeAll()
            conditionLock.broadcast()
            return true
        }
        guard doShutdown && state == .stopping else { return }
        DispatchQueue(label: "foundation_plus.thread_pool.shutdown").async {
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
        var running: Bool {
            switch self {
            case .running: return true
            default: return false
            }
        }
        /// Whether the pool is in the ``State/stopped`` state
        var stopped: Bool {
            switch self {
            case .stopped: return true
            default: return false
            }
        }
    }

}


extension ThreadPool {

    /// Submit a task to the thread pool for execution and receive the result in the completion callback.
    /// 
    /// - Parameter task: A closure of the task to be executed in the thread pool.
    /// - Parameter onComplete: A closure that will be called when the task is completed with the execution result.
    public func run<R, E: Error>(
        task: sending @escaping () throws(E) -> R, 
        onComplete callback: sending @escaping (sending Result<R, E>) -> Void
    ) {

        self.submit {
            do throws(E) {
                try callback(.success(task()))
            } catch {
                callback(.failure(error))
            }
        }
        
    }


    /// Submit a task to the thread pool for execution and await its result.
    /// 
    /// - Parameter task: A closure of the task to be executed in the thread pool.
    /// - Returns: The result of the task execution.
    /// - Throws: Error thrown by the task being executed.
    public func run<R, E: Error>(task: sending () throws(E) -> R) async throws(E) -> R {

        do {

            return try await withoutActuallyEscaping(task) { localClosure in 
                
                nonisolated(unsafe) var localClosure = Optional(consume localClosure as (() throws -> R))

                return try await withCheckedThrowingContinuation { continuation in 

                    self.submit { @Sendable in
                        do {
                            let closure = localClosure.take()!
                            let value = try closure()
                            _ = consume closure
                            continuation.resume(returning: value)
                        } catch {
                            continuation.resume(throwing: error)
                        }
                    }

                }

            }

        } catch let error as E {
            throw error
        } catch {
            fatalError("Expect error of type \(E.self), got \(type(of: error))")
        }

    }


    /// Shutdown the thread pool, releasing all resources and await until the process is completed.
    public func shutdownAsync() async {
        await withCheckedContinuation { continuation in
            self.shutdown {
                continuation.resume()
            }
        }
    }

}