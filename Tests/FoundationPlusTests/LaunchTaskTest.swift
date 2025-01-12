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
            try await Task.launch(on: .main) {
                print("Task launched")
                if Int.random(in: 0 ... 1) == 0 {
                    throw CancellationError()
                } else {
                    throw NSError(domain: "", code: 1)
                }
            }
        }

    }

}