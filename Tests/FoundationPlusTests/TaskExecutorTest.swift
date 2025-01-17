import Testing
import Foundation
@testable import FoundationPlus


struct TaskExecutorTest {

    @Test(
        .serialized,
        arguments: [
            .background, .default, .global, .immediate, .main, .io
        ] as [FoundationPlusTaskExecutor]
    )
    @available(macOS 15, iOS 18, watchOS 11, tvOS 18, visionOS 2, *)
    func executeOnDefaultExecutors(_ executor: FoundationPlusTaskExecutor) async throws {
        await withTaskExecutorPreference(executor) {
            dispatchPrecondition(condition: .onQueue(executor.queue))
        }
    }
    
    
    @Test(
        .serialized,
        arguments: [
            .background, .default, .global, .immediate, .main, .io
        ] as [FoundationPlusTaskExecutor]
    )
    func executeOnDefaultExecutorsOld(_ executor: FoundationPlusTaskExecutor) async throws {
        await Task.launch(on: executor) {
            dispatchPrecondition(condition: .onQueue(executor.queue))
        }
    }
    
    
    @Test(.timeLimit(TimeLimitTrait.Duration.minutes(1)))
    func cancellingTasks() async throws {
        
        let canceller = Canceller()
        
        let task = Task {
            
            try await Task.launch {
                var sum = 0
                while true {
                    sum += 1
                    guard !canceller.isCancelled else { throw CancellationError() }
                }
            } onCancel: {
                canceller.cancel()
            }
            
        }
        
        task.cancel()
        
        await #expect(throws: CancellationError.self) {
            try await task.waitThrowing()
        }
        
    }

}
