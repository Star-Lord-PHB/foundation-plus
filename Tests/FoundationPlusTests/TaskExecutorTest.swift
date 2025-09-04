import Testing
import Foundation

@testable import ConcurrencyPlus


struct TaskExecutorTest {

    @Test(
        .serialized,
        arguments: [
            .background, .default, .global, .immediate, .main, .io
        ] as [FoundationPlusTaskExecutor]
    )
    @available(macOS 15, iOS 18, watchOS 11, tvOS 18, visionOS 2, *)
    func executeOnExecutors(_ executor: FoundationPlusTaskExecutor) async throws {
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
    func executeOnExecutorsOld(_ executor: FoundationPlusTaskExecutor) async throws {
        await Task.launch(on: executor) {
            dispatchPrecondition(condition: .onQueue(executor.queue))
        }
    }

}
