import Testing
import Foundation

@testable import ConcurrencyPlus


@Suite("Test LaunchTask")
struct LaunchTaskTest {

    @Test("Test Offloading Task")
    func testOffloadingTask() async throws {

        #if compiler(>=6.2)

        await #expect(processExitsWith: .failure, observing: [\.exitStatus], "Should fail the isolation check") { @MainActor in 
            await Task.offload { @Sendable in 
                print("Task offloaded to thread: \(Thread.current)")
                MainActor.preconditionIsolated()
            }
        }

        #else 

        await { @MainActor in 
            await Task.offload { @Sendable in 
                print("Task offloaded to thread: \(Thread.current)")
                let actor = #isolation
                #expect(actor == nil, "Isolation context should be nil")
            }
        }()

        #endif

    }


    @Test("Test Offloading Task with errors")
    func testOffloadingTaskWithErrors() async throws {

        await #expect(throws: CancellationError.self) {
            try await Task.offload {
                throw CancellationError()
            }
        }

        await #expect(throws: Error.self) {
            try await Task.offload {
                if Bool.random() { 
                    throw CancellationError()
                } else {
                    throw NSError(domain: "foundation_plus.test", code: 1)
                }
            }
        }

    }


    @Test("Test Cancelling Task", .timeLimit(TimeLimitTrait.Duration.minutes(1)))
    func testCancellingTask() async throws {

        let isCancelled = MutexValue(false)
        
        let task = Task {
            
            try await Task.offload {
                var sum = 0
                while true {
                    sum += 1
                    guard isCancelled.withLock({ !$0 }) else { throw CancellationError() }
                }
            } onCancel: {
                isCancelled.withLock { $0 = true }
            }
            
        }
        
        task.cancel()
        
        await #expect(throws: CancellationError.self) {
            _ = try await task.value
        }
        
    }


    // There was a bug where the Task.offload method may crash due to error
    // "closure argument was escaped in withoutActuallyEscaping block".
    // This test is specifically created to check that.
    @Test("Test Stability")
    func testStability() async throws {

        #if compiler(>=6.2)

        await #expect(
            processExitsWith: .success, 
            #"The process must not crash due to "closure argument was escaped in withoutActuallyEscaping block""#
        ) {
            await withTaskGroup(of: Void.self) { group in 
                for _ in 0 ..< 100 {
                    group.addTask {
                        await Task.offload { _ = pow(2, 10000) }
                    }
                }
            }
        }

        #else

        await withTaskGroup(of: Void.self) { group in 
            for _ in 0 ..< 100 {
                group.addTask {
                    await Task.offload { _ = pow(2, 10000) }
                }
            }
        }

        #endif
        
    }

}