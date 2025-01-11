//
//  ExecuteTest.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/7/28.
//

import Testing
@testable import FoundationPlus


struct ExecuteTest {
    
    actor TestActor {}
    
    @Test
    func testIsolationAsync() async throws {
        
        let actor = TestActor()
        
        await executeAsync(isolatedOn: actor) { a in
            
            actor.assertIsolated()
            
            execute(isolatedOn: a) {
                actor.assertIsolated()
            }
            
            await executeAsync(isolatedOn: a) { _ in
                actor.assertIsolated()
            }
            
        }
        
    }
    
    
    @Test
    func testIsolation() async throws {
        
        let actor = TestActor()
        
        await execute(isolatedOn: actor) { 
            
            actor.assertIsolated()
            
            execute {
                actor.assertIsolated()
            }
            
        }
        
    }
    
}
