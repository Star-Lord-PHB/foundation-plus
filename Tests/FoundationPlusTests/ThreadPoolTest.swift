import Testing

import Foundation
@testable import ConcurrencyPlus


struct ThreadPoolTest {

    @Test("Test Sync Lifetime")
    func testSyncLifetime() async throws {

        try await wait(for: 20) {
            
            let pool = ThreadPool(threadCount: 4)
            try #require(pool.state == .ready)

            do {
                pool.start()
                #expect(pool.state == .running)
            }

            do {
                pool.shutdown()
                #expect(pool.state == .stopping || pool.state == .stopped)

                // The pool must eventually be stopped
                try await waitUntil(timeLimit: 10) { pool.state == .stopped }
            }
            
        }

    }


    @Test("Test Sync Abnormal Lifetime")
    func testSyncAbnormalLifetime() async throws {

        try await wait(for: 20) {
            
            let pool = ThreadPool(threadCount: 4)
            try #require(pool.state == .ready)

            do {
                // Shutdown before start
                pool.shutdown()
                #expect(pool.state == .ready)
            }

            do {
                pool.start()
                #expect(pool.state == .running)
            }

            do {
                pool.shutdown()
                #expect(pool.state == .stopping || pool.state == .stopped)

                // The pool must eventually be stopped
                try await waitUntil(timeLimit: 10) { pool.state == .stopped }
            }

            do {
                // Start after stopped
                pool.start()
                #expect(pool.state == .stopped)
            }
            
        }

    }


    @Test("Test Task Submission")
    func testTaskSubmission() async throws {

        try await wait(for: 20) {
            
            let pool = ThreadPool(threadCount: 4)
            pool.start()
            try #require(pool.state == .running)

            do {
                let taskCount = 32
                let threads = MutexValue(Set<Thread>())
                let finishedTasks = MutexValue(0)

                for _ in 0 ..< taskCount {
                    pool.submit {
                        pool.assertOnThreadPool()
                        Thread.sleep(forTimeInterval: 0.01)
                        // print("On thread: \(Thread.current)")
                        threads.withLock {
                            _ = $0.insert(Thread.current)
                        }
                        finishedTasks.withLock { $0 += 1 }
                    }
                }

                try await waitUntil(timeLimit: 10) { finishedTasks.withLock { $0 == taskCount } }

                #expect(threads.withLock { $0.count } == 4)
            }
            
            do {
                pool.shutdown()
                // The pool must eventually be stopped
                try await waitUntil(timeLimit: 10) { pool.state == .stopped }
            }
            
        }

    }


    @Test("Test Task Completion Callback")
    func testTaskCompletionCallback() async throws {

        try await wait(for: 20) {
            
            let pool = ThreadPool(threadCount: 4)
            pool.start()
            try #require(pool.state == .running)

            do {

                let taskCount = 8
                let sum = MutexValue(0)
                let expectedSum = (0 ..< taskCount).reduce(0, +)
                let finishedTask = MutexValue(0)

                for i in 0 ..< taskCount {
                    pool.run {
                        i
                    } onComplete: { result in
                        finishedTask.withLock { $0 += 1 }
                        #expect(throws: Never.self, "Should never fail") {
                            try sum.withLock { $0 += try result.get() }
                        }
                    }
                }

                try await waitUntil(timeLimit: 10) { finishedTask.withLock { $0 == taskCount } }

                #expect(sum.withLock { $0 } == expectedSum)

            }

            do {
                pool.shutdown()
                // The pool must eventually be stopped
                try await waitUntil(timeLimit: 10) { pool.state == .stopped }
            }
            
        }

    }


    @Test("Test Task Completion Callback With Error")
    func testTaskCompletionCallbackWithError() async throws {

        try await wait(for: 20) {
            
            let pool = ThreadPool(threadCount: 4)
            pool.start()
            try #require(pool.state == .running)

            do {

                let completed = MutexValue(false)

                pool.run { () throws(NSError) -> Void in
                    throw NSError(domain: "Test", code: 1)
                } onComplete: { result in
                    switch result {
                        case .success:
                            #expect(Bool(false), "Should not succeed")
                        case .failure(let error):
                            #expect(error.domain == "Test")
                            #expect(error.code == 1)
                    }
                    completed.withLock { $0 = true }
                }

                try await waitUntil(timeLimit: 10) { completed.withLock { $0 } }

            }

            do {
                pool.shutdown()
                // The pool must eventually be stopped
                try await waitUntil(timeLimit: 10) { pool.state == .stopped }
            }
            
        }

    }


    @Test("Test Shutdown Completion Callback")
    func testShutdownCompletionCallback() async throws {

        try await wait(for: 20) {
            
            let pool = ThreadPool(threadCount: 4)
            pool.start()
            try #require(pool.state == .running)

            do {

                let shutdownCompleted = MutexValue(false)

                pool.shutdown {
                    print("shutdown completed")
                    shutdownCompleted.withLock { $0 = true }
                }

                #expect(pool.state == .stopping || pool.state == .stopped)

                try await waitUntil(timeLimit: 10) { shutdownCompleted.withLock { $0 } }

                #expect(pool.state == .stopped)
            }
            
        }

    }

}



extension ThreadPoolTest {

    @Test("Test Async Shutdown")
    func testAsyncShutdown() async throws {

        try await wait(for: 20) {
            
            let pool = ThreadPool(threadCount: 4)
            pool.start()
            try #require(pool.state == .running)

            do {
                await pool.shutdownAsync()
                #expect(pool.state == .stopped)
            }
            
        }

    }


    @Test("Test Async Task Running")
    func testAsync2() async throws {
        
        try await wait(for: 20) {
            
            let pool = ThreadPool(threadCount: 4)
            pool.start()
            try #require(pool.state == .running)

            do {

                let taskCount = 500
                let expectedSum = (0 ..< taskCount).reduce(0, +)

                let sum = await withTaskGroup(of: Int.self) { group in
                    for i in 0 ..< taskCount {
                        group.addTask {
                            await pool.run {
                                // print("On thread: \(Thread.current)")
                                return i
                            }
                        }
                    }
                    return await group.reduce(0, +)
                }

                #expect(sum == expectedSum)

            }

            do {
                await pool.shutdownAsync()
                #expect(pool.state == .stopped)
            }
            
        }

    }


    @Test("Test Async Task Running with Error")
    func testAsyncTaskRunningWithError() async throws {

        try await wait(for: 20) {
            
            let pool = ThreadPool(threadCount: 4)
            pool.start()
            try #require(pool.state == .running)
            
            do {
                
                do {
                    try await pool.run {
                        print("On thread: \(Thread.current), throwing error")
                        throw NSError(domain: "Test", code: 1)
                    }
                } catch let error as NSError {
                    #expect(error.domain == "Test")
                    #expect(error.code == 1)
                } catch {
                    #expect(Bool(false), "Expect only NSError, got \(error)")
                }
                
            }
            
            do {
                await pool.shutdownAsync()
                #expect(pool.state == .stopped)
            }
            
        }

    }

}



extension ThreadPoolTest {

    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test("Test Working as Task Executor Preference", .timeLimit(.minutes(1)))
    func testWorkingAsTaskExecutorPreference() async throws {

        let pool = ThreadPool(threadCount: 4)
        pool.start()
        try #require(pool.state == .running)

        do {
            await withTaskExecutorPreference(pool) {
                pool.assertOnThreadPool()
            }
        }

        do {
            await pool.shutdownAsync()
            #expect(pool.state == .stopped)
        }

    }


    @Test("Test Working with Task.offload")
    func testWorkingWithTaskOffload() async throws {

        try await wait(for: 20) {
            
            let pool = ThreadPool(threadCount: 4)
            pool.start()
            try #require(pool.state == .running)

            do {
                await Task.offload(on: pool) {
                    pool.assertOnThreadPool()
                }
            }

            do {
                await pool.shutdownAsync()
                #expect(pool.state == .stopped)
            }
            
        }

    }

}
