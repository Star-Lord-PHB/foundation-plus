import Testing
import Foundation

@testable import ConcurrencyPlus


struct TaskExecutorTest {

    @Test(
        "Test Task Submission",
        .timeLimit(.minutes(1)),
        arguments: [
            .main, .global, .background, .shared,
        ] as [DispatchQueueTaskExecutor]
    )
    func testTaskSubmission(_ executor: DispatchQueueTaskExecutor) async throws {
        let finished = MutexValue(false)
        executor.submit {
            dispatchPrecondition(condition: .onQueue(executor.queue))
            finished.withLock { $0 = true }
        }
        try await waitUntil(timeLimit: 10) { finished.withLock { $0 } }
    }


    @Test(
        "Test Async Running Tasks",
        .timeLimit(.minutes(1)),
        arguments: [
            .main, .global, .background, .shared,
        ] as [DispatchQueueTaskExecutor]
    )
    func testRunningTasks(_ executor: DispatchQueueTaskExecutor) async throws {

        let taskCount = 100
        let expectedSum = (0 ..< taskCount).reduce(0, +)

        let sum = await withTaskGroup(of: Int.self) { group in
            for i in 0 ..< taskCount {
                group.addTask {
                    await executor.run { 
                        dispatchPrecondition(condition: .onQueue(executor.queue))
                        return i 
                    }
                }
            }
            return await group.reduce(0, +)
        }

        try #require(sum == expectedSum)

    }


    @Test(
        "Test Async Running Tasks with errors", 
        .timeLimit(.minutes(1)),
        arguments: [
            .main, .global, .background, .shared,
        ] as [DispatchQueueTaskExecutor]
    )
    func testAsyncRunningTasksWithErrors(_ executor: DispatchQueueTaskExecutor) async throws {
        await #expect(throws: NSError.self, "Should throw error") {
            try await executor.run {
                throw NSError(domain: "foundation_plus.test", code: 1)
            }
        }
    }

}



extension TaskExecutorTest {

    @Test(
        "Test Working as Task Executor Preference",
        .timeLimit(.minutes(1)),
        arguments: [
            .main, .global, .background, .shared,
        ] as [DispatchQueueTaskExecutor]
    )
    @available(macOS 15, iOS 18, watchOS 11, tvOS 18, visionOS 2, *)
    func testWorkingAsTaskExecutorPreference(_ executor: DispatchQueueTaskExecutor) async throws {
        await withTaskExecutorPreference(executor) {
            dispatchPrecondition(condition: .onQueue(executor.queue))
        }
    }
    
    
    @Test(
        "Test Working with Task.offload",
        .timeLimit(.minutes(1)),
        arguments: [
            .main, .global, .background, .shared,
        ] as [DispatchQueueTaskExecutor]
    )
    func testWorkingWithTaskOffload(_ executor: DispatchQueueTaskExecutor) async throws {
        await Task.offload(on: executor) {
            dispatchPrecondition(condition: .onQueue(executor.queue))
        }
    }

}