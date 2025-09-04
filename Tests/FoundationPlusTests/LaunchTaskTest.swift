import Testing
import Foundation

@testable import FoundationPlus
@testable import ConcurrencyPlus


@Suite("Test LaunchTask")
struct LaunchTaskTest {

    @Test 
    func launchTaskSuccess() async throws {
        
        await Task.launch(on: .global) {
            print("Task launched")
        }

    }


    @Test
    func launchTaskError() async throws {
        
        await #expect(throws: CancellationError.self) {
            try await Task.launch(on: .main) {
                print("Task launched")
                throw CancellationError()
            }
        }

        await #expect(throws: Error.self) {
            try await Task.launch(on: .io) {
                print("Task launched")
                if Int.random(in: 0 ... 1) == 0 {
                    throw CancellationError()
                } else {
                    throw NSError(domain: "", code: 1)
                }
            }
        }

    }


    @Test(.timeLimit(TimeLimitTrait.Duration.minutes(1)))
    func launchTaskCancel() async throws {
        
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


    // Run this test multiple times 
    @Test
    func launchTaskCompatStability() async throws {

        let r = try? await Task.launchCompat(on: .io) {
            dispatchPrecondition(condition: .onQueue(FoundationPlusTaskExecutor.io.queue))
            return if Bool.random() {
                Double.random(in: 0 ... 1)
            } else {
                throw NSError(domain: "", code: 1)
            }
        } onCancel: { }

        print(r ?? "error")

    }

}