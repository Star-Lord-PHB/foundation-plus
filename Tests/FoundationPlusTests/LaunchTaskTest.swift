import Testing
import Foundation
@testable import ConcurrencyPlus


@Suite("Test LaunchTask")
struct LaunchTaskTest {

    @Test 
    func launchTask1() async throws {
        
        await Task.launch(on: .global) {
            print("Task launched")
        }

    }


    @Test
    func launchTask2() async throws {
        
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


    // Run this test multiple times 
    @Test
    func launchTask3() async throws {

        let r = try? await Task.launchCompat(on: .io) {
            dispatchPrecondition(condition: .onQueue(FoundationPlusTaskExecutor.io.queue))
            return if Bool.random() {
                Double.random(in: 0 ... 1)
            } else {
                throw NSError(domain: "", code: 1)
            }
        }

        print(r ?? "error")

    }

}