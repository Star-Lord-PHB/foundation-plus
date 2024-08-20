//
//  ReadWriteTest.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/8/2.
//

import Testing
@testable import FoundationPlus


extension FileManagerTest {
    
    @Suite("Test Reading & Writing File")
    class ReadWriteTest: FileManagerTestCases {
        
        init() throws {
            try super.init(relativePath: "foundation_plus/file_manager/read_write")
        }
        
    }
    
}



extension FileManagerTest.ReadWriteTest {
    
    @Test("Read File: file exist")
    func readFile1() async throws {
        
        try await withFile(content: "test") { url, content in
            let actualContent = try await manager.contents(at: url)
            #expect(actualContent == content)
        }
        
    }
    
    
    @Test("Read File: file not exist")
    func readFile2() async throws {
        
        let url = makeTestingFileUrl()
        
        await #expect(throws: Error.self) {
            let _ = try await manager.contents(at: url)
        }
        
    }
    
    
    @Test("Write File: file exist / overwrite: yes")
    func writeFile1() async throws {
        
        try await withFile(content: "test1") { url, _ in
            
            let content = Data("test".utf8)
            try await manager.write(content, to: url)
            
            try #expect(Data(contentsOf: url) == content)
            
        }
        
    }
    
    
    @Test("Write File: file not exist / overwrite: yes")
    func writeFile2() async throws {
        
        let url = makeTestingFileUrl()
        defer { try? manager.removeItem(at: url) }
        
        let content = Data("test".utf8)
        try await manager.write(content, to: url)
        
        try #expect(Data(contentsOf: url) == content)
        
    }
    
    
    @Test("Write File: file exist / overwrite: no")
    func writeFile3() async throws {
        
        try await withFile(baseUrl: baseUrl) { url, originalContent in
            
            await #expect(throws: Error.self) {
                let content = Data("test".utf8)
                try await self.manager.write(content, to: url, replaceExisting: false)
            }
            
        }
        
    }
    
    
    @Test("Write File: file not exist / overwrite: no")
    func writeFile4() async throws {
        
        let url = makeTestingFileUrl()
        defer { try? manager.removeItem(at: url) }
        
        let content = Data("test".utf8)
        try await manager.write(content, to: url, replaceExisting: false)
        
        try #expect(Data(contentsOf: url) == content)
        
    }
    
    
    @Test("Append File: file exist")
    func appendFile1() async throws {
        
        try await withFile(content: "test") { url, content in
            try await manager.append(content, to: url)
            try #expect(Data(contentsOf: url) == content + content)
        }
        
    }
    
    
    @Test("Append File: file not exist")
    func appendFile2() async throws {
        
        let url = makeTestingFileUrl()
        
        await #expect(throws: Error.self) {
            try await manager.append(.init(), to: url)
        }
        
    }
    
}
