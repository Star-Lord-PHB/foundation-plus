import Testing

@testable import FoundationPlusEssential


@Suite("Test Task Canceller")
struct TaskCancellerTest {

    final class TestTaskHandler: Sendable {

        enum State {
            case ready
            case running
            case cancelled
            case completed
        }

        let id: UUID = .init()

        private let _state: MutexValue<State> = .init(.ready)
        var state: State { _state.withLock(\.self) }
        var isCancelled: Bool { _state.withLock { $0 == .cancelled } }

        let _cancellationInvokationCount: MutexValue<Int> = .init(0)
        var cancellationInvokationCount: Int { _cancellationInvokationCount.withLock(\.self) }

        func resume() {
            _state.withLock {
                guard $0 == .ready else { return }
                $0 = .running
            }
        }

        func cancel() {
            _cancellationInvokationCount.withLock { $0 += 1 }
            _state.withLock { 
                guard $0 == .running else { return }
                $0 = .cancelled
            }
        }

        func complete() {
            _state.withLock {
                guard $0 == .running else { return }
                $0 = .completed
            }
        }

        // static let executionQueue = DispatchQueue(label: "foundation_plus.test.canceller", attributes: .concurrent)

    }


    @Test("Test No Cancellation (Testing the mock Task Handler)")
    func testNoCancellation() async throws {

        try await wait(for: 20) {
            
            let canceller = TaskCanceller(for: TestTaskHandler.self, onCancel: { $0.cancel() })

            let taskHandler = TestTaskHandler()
            try #require(taskHandler.state == .ready, "Task handler should be in ready state")

            taskHandler.resume()
            try #require(taskHandler.state == .running, "Task handler should be in running state")

            canceller.prepare(with: taskHandler)

            taskHandler.complete()
            #expect(taskHandler.state == .completed, "Task handler should be in completed state")
            #expect(taskHandler.cancellationInvokationCount == 0, "Cancellation should not be invoked")
            
            try canceller.unsafeWithTaskHandler { handler in
                let handler = try #require(handler, "Task handler should be available")
                #expect(handler.id == taskHandler.id, "The task handler should be the one managed by the canceller")
            }
            
        }

    }


    @Test("Test Cancellation")
    func testCancellation() async throws {     // make sure that the task will never be completed normally

        try await wait(for: 20) {
            
            let canceller = TaskCanceller(for: TestTaskHandler.self, onCancel: { $0.cancel() })
            
            let taskHandler = TestTaskHandler()
            try #require(taskHandler.state == .ready, "Task handler should be in ready state")

            taskHandler.resume()
            try #require(taskHandler.state == .running, "Task handler should be in running state")

            canceller.prepare(with: taskHandler)

            canceller.cancel()
            #expect(taskHandler.state == .cancelled, "Task handler should be in cancelled state")
            #expect(taskHandler.cancellationInvokationCount == 1, "Cancellation should be invoked only once")

            try canceller.unsafeWithTaskHandler { handler in
                let handler = try #require(handler, "Task handler should be available")
                #expect(handler.id == taskHandler.id, "The task handler should be the one managed by the canceller")
            }
            
        }

    }


    @Test("Test Cancellation Before Prepare")
    func testCancellationBeforePrepare() async throws {

        try await wait(for: 20) {
            
            let canceller = TaskCanceller(for: TestTaskHandler.self, onCancel: { $0.cancel() })

            let taskHandler = TestTaskHandler()
            try #require(taskHandler.state == .ready, "Task handler should be in ready state")

            taskHandler.resume()
            try #require(taskHandler.state == .running, "Task handler should be in running state")

            canceller.cancel()                          // first cancel
            #expect(taskHandler.state == .running, "Task handler should still be in running state")

            canceller.prepare(with: taskHandler)        // then prepare
            #expect(taskHandler.state == .cancelled, "Task handler should be in cancelled state")
            #expect(taskHandler.cancellationInvokationCount == 1, "Cancellation should be invoked only once")

            try canceller.unsafeWithTaskHandler { handler in
                let handler = try #require(handler, "Task handler should be available")
                #expect(handler.id == taskHandler.id, "The task handler should be the one managed by the canceller")
            }
            
        }

    }


    @Test("Test Multiple Cancellation")
    func testMultipleCancellation() async throws {

        try await wait(for: 20) {
            
            let cancellationCount = 10

            let canceller = TaskCanceller(for: TestTaskHandler.self, onCancel: { $0.cancel() })

            let taskHandler = TestTaskHandler()
            try #require(taskHandler.state == .ready, "Task handler should be in ready state")

            taskHandler.resume()
            try #require(taskHandler.state == .running, "Task handler should be in running state")

            canceller.prepare(with: taskHandler)

            await withTaskGroup(of: Void.self) { group in
                for _ in 0 ..< cancellationCount {
                    group.addTask {
                        await Task.yield()
                        canceller.cancel()
                    }
                }
            }

            #expect(taskHandler.state == .cancelled, "Task handler should be in cancelled state")
            #expect(taskHandler.cancellationInvokationCount == 1, "Cancellation should be invoked only once")

            try canceller.unsafeWithTaskHandler { handler in
                let handler = try #require(handler, "Task handler should be available")
                #expect(handler.id == taskHandler.id, "The task handler should be the one managed by the canceller")
            }
            
        }
        
    }


    @Test("Test Multiple Prepares")
    func testMultiplePrepares() async throws {

        try await wait(for: 20) {
            
            let canceller = TaskCanceller(for: TestTaskHandler.self, onCancel: { $0.cancel() })

            let taskHandlers = (0 ..< 10).map { _ in TestTaskHandler() }
            for taskHandler in taskHandlers {
                try #require(taskHandler.state == .ready, "Task handler should be in ready state")
                taskHandler.resume()
                try #require(taskHandler.state == .running, "Task handler should be in running state")
            }

            await withTaskGroup(of: Void.self) { group in
                for handler in taskHandlers {
                    group.addTask {
                        await Task.yield()
                        canceller.prepare(with: consume handler)
                    }
                }
            }

            canceller.cancel()

            #expect(taskHandlers.filter { $0.state == .cancelled }.count == 1, "Only one task handler should be cancelled")
            #expect(taskHandlers.filter { $0.state == .running }.count == 9, "The other task handlers should still be in running state")

            let cancelledHandler = try #require(taskHandlers.first(where: { $0.state == .cancelled }), "There must be a cancelled handler")

            #expect(cancelledHandler.cancellationInvokationCount == 1, "Cancellation should be invoked only once")

            try canceller.unsafeWithTaskHandler { handler in
                let handler = try #require(handler, "Task handler should be available")
                #expect(handler.id == cancelledHandler.id, "Cancelled handler should be the one managed by the canceller")
            }
            
        }
        
    }


    @Test("Stress Test (multiple cancellations + multiple prepares)")
    func pressureTest() async throws {

        try await wait(for: 20) {
            
            let count = 100

            let canceller = TaskCanceller(for: TestTaskHandler.self, onCancel: { $0.cancel() })

            let taskHandlers = (0 ..< count).map { _ in TestTaskHandler() }
            for taskHandler in taskHandlers {
                try #require(taskHandler.state == .ready, "Task handler should be in ready state")
                taskHandler.resume()
                try #require(taskHandler.state == .running, "Task handler should be in running state")
            }

            await withTaskGroup(of: Void.self) { group in
                for handler in taskHandlers {
                    group.addTask {
                        await Task.yield()
                        canceller.prepare(with: consume handler)
                    }
                    group.addTask {
                        await Task.yield()
                        canceller.cancel()
                    }
                }
            }

            #expect(taskHandlers.filter { $0.state == .cancelled }.count == 1, "Only one task handler should be cancelled")
            #expect(taskHandlers.filter { $0.state == .running }.count == count - 1, "The other task handlers should still be in running state")

            let cancelledHandler = try #require(taskHandlers.first(where: { $0.state == .cancelled }), "There must be a cancelled handler")

            #expect(cancelledHandler.cancellationInvokationCount == 1, "Cancellation should be invoked only once")

            try canceller.unsafeWithTaskHandler { handler in
                let handler = try #require(handler, "Task handler should be available")
                #expect(handler.id == cancelledHandler.id, "Cancelled handler should be the one managed by the canceller")
            }
            
        }

    }

}



extension TaskCancellerTest {

    final class MockTaskHandler: Sendable {

        let completionHandler: @Sendable (Result<Void, Error>) -> Void
        let cancelled: MutexValue<Bool> = .init(false)

        init(completionHandler: @escaping @Sendable (Result<Void, Error>) -> Void) {
            self.completionHandler = completionHandler
        }

        func cancel() {
            cancelled.withLock { $0 = true }
            completionHandler(.failure(CancellationError()))
        }

    }


    @Test("Test Cancelling Actual Task After Prepare")
    func testCancellingActualTaskAfterPrepare() async throws {

        try await wait(for: 20) {
            
            let barrier = SingleConsumerBarrier()

            let task = Task {

                let canceller = TaskCanceller(for: MockTaskHandler.self, onCancel: { $0.cancel() })
                
                try await withTaskCancellationHandler {
                    try await withCheckedThrowingContinuation { continuation in
                        let handler = MockTaskHandler { result in
                            continuation.resume(with: result)
                        }
                        canceller.prepare(with: consume handler)
                        print("Task handler created and prepare method called")
                        barrier.signal()
                    }
                } onCancel: {
                    canceller.cancel()
                }

            }

            await barrier.wait()   // make sure that the task is created and the prepare method is called

            print("Cancelling the task")
            task.cancel()

            await #expect(throws: CancellationError.self, "Task should be cancelled") {
                try await task.value
            }
            
        }

    }


    @Test("Test Cancelling Actual Task Before Prepare")
    func testCancellingActualTaskBeforePrepare() async throws {

        try await wait(for: 20) {
            
            let barrier = SingleConsumerBarrier()

            let task = Task {

                let canceller = TaskCanceller(for: MockTaskHandler.self, onCancel: { $0.cancel() })
                
                try await withTaskCancellationHandler {
                    await barrier.wait()    // make sure that the cancel method is called before calling prepare
                    try await withCheckedThrowingContinuation { continuation in
                        print("Creating task handler")
                        let handler = MockTaskHandler { result in
                            continuation.resume(with: result)
                        }
                        canceller.prepare(with: consume handler)
                    }
                } onCancel: {
                    canceller.cancel()
                }

            }

            task.cancel()
            print("Cancelled")

            barrier.signal()

            await #expect(throws: CancellationError.self, "Task should be cancelled") {
                try await task.value
            }
            
        }

    }

}
