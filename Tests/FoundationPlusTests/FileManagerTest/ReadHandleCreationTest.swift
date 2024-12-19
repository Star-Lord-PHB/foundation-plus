//
//  ReadHandleCreationTest.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/8/2.
//

import Testing
@testable import FoundationPlus


extension FileManagerTest {
    
    @Suite("Test Creating FileHandle for Reading")
    final class ReadHandleCreationTest: FileManagerTestCases {
        
        init() throws {
            try super.init(relativePath: "foundation_plus/file_manager/read_handle_creation")
        }
        
    }
    
}



extension FileManagerTest.ReadHandleCreationTest {
    
    @Test("Open: file exist")
    func openForRead1() async throws {
        
        try await withFileAtPath(content: "test") { path, content in
            
            let actualContent = try await manager.openFile(forReadingFrom: path).readToEnd()
            #expect(actualContent == content)
            
        }
        
    }
    
    
    @Test("WithHandle: file exist")
    func withReadHandle1() async throws {
        
        try await withFileAtPath(content: "test") { path, content in
            
            let actualContent = try await manager.withFileHandle(forReadingFrom: path) { handle in
                dispatchPrecondition(condition: .onQueue(DefaultTaskExecutor.io.queue))
                return try handle.readToEnd()
            }
            
            #expect(actualContent == content)
            
        }
        

        if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
            
            try await withFileAtPath(content: "test") { path, content in
                
                let actualContent = try await manager.withFileHandle(
                    forReadingFrom: path
                ) { handle in
                    dispatchPrecondition(condition: .onQueue(DefaultTaskExecutor.io.queue))
                    return try await handle.readToEnd()
                }
                
                #expect(actualContent == content)
                
            }
            
        }
        
    }
    
    
    @Test("Open: file not exist")
    func openForRead2() async throws {
        
        let path = makeTestingFilePath()
        
        await #expect(throws: Error.self) {
            let handle = try await manager.openFile(forReadingFrom: path)
            try await handle.close()
        }
        
    }
    
    
    @Test("WithHandle: file not exist")
    func withReadHandle2() async throws {
        
        let path = makeTestingFilePath()
        
        await #expect(throws: Error.self) {
            try await manager.withFileHandle(forReadingFrom: path) { _ in }
        }
        
        if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
            
            await #expect(throws: Error.self) {
                try await manager.withFileHandle(forReadingFrom: path) { _ in 
                    await Task.yield()      // make the compiler to use the async version
                }
            }
            
        }
        
    }
    
}
