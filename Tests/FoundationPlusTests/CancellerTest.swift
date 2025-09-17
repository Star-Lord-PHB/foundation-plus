import Testing

@testable import FoundationPlusEssential



@Suite("Test Canceller")
struct CancellerTest {

    @Test("Test Cancellation", .timeLimit(.minutes(1)))
    func testCancellingTask() async throws {
        
        let canceller = Canceller()

        let task = Task {
            while !canceller.isCancelled {
                try? await Task.sleep(nanoseconds: 100_000_000)
            }
            return 42
        }

        canceller.cancel()

        await #expect(
            task.value == 42, 
            "Task should be able to stopped due to cancellation and return specific value"
        )

    }

}