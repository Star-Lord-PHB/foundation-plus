//
//  CreateFileTest.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/8/3.
//

import Testing
@testable import FoundationPlus


extension FileManagerTest {
    
    @Suite("Test Creating File & Dir")
    class CreateFileTest: FileManagerTestCases {
        
        init() throws {
            try super.init(relativePath: "foundation_plus/file_manager/create_file")
        }
        
    }
    
}



extension FileManagerTest.CreateFileTest {
    
    @Test("Create File: file not exist / replace: no")
    func createFile1() async throws {
        
        let url = makeTestingFileUrl()
        let content = Data("test".utf8)
        defer { try? manager.removeItem(at: url) }
        
        try await manager.createFile(at: url, with: content)
        
        #expect(throws: Never.self) {
            try #expect(Data(contentsOf: url) == content)
        }
        
    }
    
    
    @Test("Create File: file exist / replace: no")
    func createFile2() async throws {
        
        try await withFile { url, _ in
            
            await #expect(throws: Error.self) {
                try await self.manager.createFile(at: url)
            }
            
        }
        
    }
    
    
    @Test("Create File: file not exist / replace yes")
    func createFile3() async throws {
        
        let url = makeTestingFileUrl()
        let content = Data("test".utf8)
        defer { try? manager.removeItem(at: url) }
        
        try await manager.createFile(at: url, replaceExisting: true, with: content)
        
        #expect(throws: Never.self) {
            try #expect(Data(contentsOf: url) == content)
        }
        
    }
    
    
    @Test("Create File: file exist / replace: yes")
    func createFile4() async throws {
        
        try await withFile(content: "test1") { url, _ in

            let content = Data("test".utf8)
            try await manager.createFile(at: url, replaceExisting: true, with: content)
            
            try #expect(Data(contentsOf: url) == content)
            
        }
        
    }
    
    
    @Test("Create Dir: dir not exist / intermediate: exist / createIntermediate: no")
    func createDir1() async throws {
        
        let url = makeTestingFileUrl()
        defer { try? manager.removeItem(at: url) }
        
        try await manager.createDirectory(at: url)
        
        var isDir = ObjCBool(false)
        #expect(manager.fileExists(atPath: url.compactPath(), isDirectory: &isDir))
        #expect(isDir.boolValue)
        
    }
    
    
    @Test("Create Dir: dir exist / intermediate: exist / createIntermediate: no")
    func createDir2() async throws {
        
        try await withDirectory { url in
            
            await #expect(throws: Error.self) {
                try await self.manager.createDirectory(at: url)
            }
            
        }
        
    }
    
    
    @Test("Create Dir: dir not exist / intermediate: not exist / createIntermediate: no")
    func createDir3() async throws {
        
        let intermediate = makeTestingFileUrl()
        let url = intermediate.appending(path: "final")
        defer { try? manager.removeItem(at: intermediate) }
        
        await #expect(throws: Error.self) {
            try await self.manager.createDirectory(at: url)
        }
        
    }
    
    
    @Test("Create Dir: dir not exist / intermediate: file / createIntermediate: no")
    func createDir4() async throws {
        
        try await withFile { url, _ in
            
            let folderUrl = url.appending(path: "final")
            
            await #expect(throws: Error.self) {
                try await self.manager.createDirectory(at: folderUrl)
            }
            
        }
        
    }
    
    
    @Test("Create Dir: dir not exist / intermediate: exist / createIntermediate: yes")
    func createDir5() async throws {
        
        let url = makeTestingFileUrl()
        defer { try? manager.removeItem(at: url) }
        
        try await manager.createDirectory(at: url, withIntermediateDirectories: true)
        
        var isDir = ObjCBool(false)
        #expect(manager.fileExists(atPath: url.compactPath(), isDirectory: &isDir))
        #expect(isDir.boolValue)
        
    }
    
    
    @Test("Create Dir: dir exist / intermediate: exist / createIntermediate: yes")
    func createDir6() async throws {
        
        try await withDirectory { url in
            
            let containedFileUrl = url.appending(path: "contained.txt")
            manager.createFile(atPath: containedFileUrl.compactPath(), contents: nil)
            
            try await manager.createDirectory(at: url, withIntermediateDirectories: true)
            
            var isDir = ObjCBool(false)
            #expect(manager.fileExists(atPath: url.compactPath(), isDirectory: &isDir))
            #expect(isDir.boolValue)
            #expect(manager.fileExists(atPath: containedFileUrl.compactPath()))
            
        }
        
    }
    
    
    @Test("Create Dir: dir not exist / intermediate: not exist / createIntermediate: yes")
    func createDir7() async throws {
        
        let intermediate = makeTestingFileUrl()
        let url = intermediate.appending(path: "final")
        defer { try? manager.removeItem(at: intermediate) }
        
        try await manager.createDirectory(at: url, withIntermediateDirectories: true)
        
        var isDir = ObjCBool(false)
        #expect(manager.fileExists(atPath: url.compactPath(), isDirectory: &isDir))
        #expect(isDir.boolValue)
        
    }
    
    
    @Test("Create Dir: dir not exist / intermediate: file / createIntermediate: yes")
    func createDir8() async throws {
        
        try await withFile { url, _ in
            
            let folderUrl = url.appending(path: "final")
            
            await #expect(throws: Error.self) {
                try await self.manager.createDirectory(at: folderUrl, withIntermediateDirectories: true)
            }
            
        }
        
    }
    
}
