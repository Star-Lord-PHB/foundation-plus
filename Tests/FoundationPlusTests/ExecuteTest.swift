//
//  ExecuteTest.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/7/28.
//

import Testing
@testable import FoundationPlus


@Suite("Test Execute")
struct ExecuteTest {
    
    @globalActor
    actor TestActor {
        static let shared = TestActor()
    }

    class NonSendable {}
    
    @Test("Test Isolated Execute Async")
    func testIsolatedExecuteAsync() async throws {
        
        let actor = TestActor()
        
        await execute(isolatedOn: actor) { a in
            actor.assertIsolated()
            await execute(isolatedOn: a) { _ in
                actor.assertIsolated()
            }
        }
        
    }


    @Test("Test Isolated Execute Inheritance Async")
    @TestActor
    func testIsolatedExecuteInheritanceAsync() async throws {
        
        TestActor.assertIsolated()

        await execute { _ in
            TestActor.assertIsolated()
        }
        
    }


    @Test("Test Non-Isolated Execute Async")
    func testNonIsolatedExecuteAsync() async throws {

        #if compiler(>=6.2)

        await #expect(processExitsWith: .success, "Isolation Assertion should succeed") { @TestActor in
            // This is to make sure that such closure does provide isolated context
            TestActor.assertIsolated()
        }

        await #expect(processExitsWith: .failure, "Isolation Assertion should fail") { @TestActor in
            await execute(isolatedOn: nil) { _ in
                // Non-isolated execution
                TestActor.assertIsolated() // This should fail
            }
        }

        #else 

        try await { @TestActor in

            // This is to make sure that such closure does provide isolated context
            let actor = #isolation
            try #require(actor === TestActor.shared)

            await execute(isolatedOn: nil) { _ in
                // Non-isolated execution
                let actor = #isolation
                #expect(actor == nil)
            }
            
        }()

        #endif

    }
    
    
    @Test("Test Isolated Execute")
    func testIsolatedExecute() async throws {
        
        let actor = TestActor()
        
        await execute(isolatedOn: actor) { 
            actor.assertIsolated()
        }
        
    }


    @Test("Test Isolated Execute Inheritance")
    @TestActor
    func testIsolatedExecuteInheritance() async throws {
        
        TestActor.assertIsolated()

        execute { 
            TestActor.assertIsolated()
        }

    }
    
}
