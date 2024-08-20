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
    class ReadHandleCreationTest: FileManagerTestCases {
        
        init() throws {
            try super.init(relativePath: "foundation_plus/file_manager/read_handle_creation")
        }
        
    }
    
}



extension FileManagerTest.ReadHandleCreationTest {
    
    @Test("Open: file exist")
    func openForRead1() async throws {
        
        try await withFile(content: "test") { url, content in
            
            let actualContent = try await manager.openFile(forReadingFrom: url).readToEnd()
            #expect(actualContent == content)
            
        }
        
    }
    
    
    @Test("WithHandle: file exist")
    func withReadHandle1() async throws {
        
        try await withFile(content: "test") { url, content in
            
            let actualContent = try await manager.withFileHandle(forReadingFrom: url) { handle in
                dispatchPrecondition(condition: .onQueue(DefaultTaskExecutor.io.queue))
                return try handle.readToEnd()
            }
            
            #expect(actualContent == content)
            
        }
        
        if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
            
            try await withFile(content: "test") { url, content in
                
                let actualContent = try await manager.withFileHandle(
                    forReadingFrom: url
                ) { handle in
                    dispatchPrecondition(condition: .onQueue(DefaultTaskExecutor.io.queue))
                    return try await handle.bytes.reduce(into: Data()) { partialResult, byte in
                        partialResult.append(contentsOf: [byte])
                    }
                }
                
                #expect(actualContent == content)
                
            }
            
        }
        
    }
    
    
    @Test("Open: file not exist")
    func openForRead2() async throws {
        
        let url = makeTestingFileUrl()
        
        await #expect(throws: Error.self) {
            let _ = try await manager.openFile(forReadingFrom: url).readToEnd()
        }
        
    }
    
    
    @Test("WithHandle: file not exist")
    func withReadHandle2() async throws {
        
        let url = makeTestingFileUrl()
        
        await #expect(throws: Error.self) {
            try await manager.withFileHandle(forReadingFrom: url) { _ in }
        }
        
        if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
            
            await #expect(throws: Error.self) {
                try await manager.withFileHandle(forReadingFrom: url) { _ in }
            }
            
        }
        
    }
    
}
