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
    final class CreateFileTest: FileManagerTestCases {
        
        init() throws {
            try super.init(relativePath: "foundation_plus/file_manager/create_file")
        }
        
    }
    
}



extension FileManagerTest.CreateFileTest {
    
    @Test("Create File: file not exist / replace: no")
    func createFile1() async throws {
        
        let path = makeTestingFilePath()
        let content = Data("test".utf8)
        defer { try? manager.removeItem(atPath: path.string) }
        
        try await manager.createFile(at: path, with: content)
        
        #expect(throws: Never.self) {
            try #expect(self.contentOfFile(at: path) == content)
        }
        
    }
    
    
    @Test("Create File: file exist / replace: no")
    func createFile2() async throws {
        
        try await withFileAtPath { path, _ in
            
            await #expect(throws: Error.self) {
                try await self.manager.createFile(at: path)
            }
            
        }
        
    }
    
    
    @Test("Create File: file not exist / replace yes")
    func createFile3() async throws {
        
        let path = makeTestingFilePath()
        let content = Data("test".utf8)
        defer { try? manager.removeItem(atPath: path.string) }
        
        try await manager.createFile(at: path, replaceExisting: true, with: content)
        
        #expect(throws: Never.self) {
            try #expect(self.contentOfFile(at: path) == content)
        }
        
    }
    
    
    @Test("Create File: file exist / replace: yes")
    func createFile4() async throws {
        
        try await withFileAtPath(content: "test1") { path, _ in

            let content = Data("test".utf8)
            try await manager.createFile(at: path, replaceExisting: true, with: content)
            
            try #expect(self.contentOfFile(at: path) == content)
            
        }
        
    }
    
    
    @Test("Create Dir: dir not exist / intermediate: exist / createIntermediate: no")
    func createDir1() async throws {
        
        let path = makeTestingFilePath()
        defer { try? manager.removeItem(atPath: path.string) }
        
        try await manager.createDirectory(at: path)
        
        var isDir = ObjCBool(false)
        #expect(manager.fileExists(atPath: path.string, isDirectory: &isDir))
        #expect(isDir.boolValue)
        
    }
    
    
    @Test("Create Dir: dir exist / intermediate: exist / createIntermediate: no")
    func createDir2() async throws {
        
        try await withDirectoryAtPath { path in
            
            await #expect(throws: Error.self) {
                try await self.manager.createDirectory(at: path)
            }
            
        }
        
    }
    
    
    @Test("Create Dir: dir not exist / intermediate: not exist / createIntermediate: no")
    func createDir3() async throws {
        
        let intermediateFolderPath = makeTestingFilePath()
        let path = intermediateFolderPath.appending("final")
        defer { try? manager.removeItem(atPath: intermediateFolderPath.string) }
        
        await #expect(throws: Error.self) {
            try await self.manager.createDirectory(at: path)
        }
        
    }
    
    
    @Test("Create Dir: dir not exist / intermediate: file / createIntermediate: no")
    func createDir4() async throws {
        
        try await withFileAtPath { path, _ in
            
            let folderPath = path.appending("final")
            
            await #expect(throws: Error.self) {
                try await self.manager.createDirectory(at: folderPath)
            }
            
        }
        
    }
    
    
    @Test("Create Dir: dir not exist / intermediate: exist / createIntermediate: yes")
    func createDir5() async throws {
        
        let path = makeTestingFilePath()
        defer { try? manager.removeItem(atPath: path.string) }
        
        try await manager.createDirectory(at: path, withIntermediateDirectories: true)
        
        var isDir = ObjCBool(false)
        #expect(manager.fileExists(atPath: path.string, isDirectory: &isDir))
        #expect(isDir.boolValue)
        
    }
    
    
    @Test("Create Dir: dir exist / intermediate: exist / createIntermediate: yes")
    func createDir6() async throws {
        
        try await withDirectoryAtPath { path in
            
            let containedFilePath = path.appending("contained.txt")
            let _ = manager.createFile(atPath: containedFilePath.string, contents: nil)
            
            try await manager.createDirectory(at: path, withIntermediateDirectories: true)
            
            var isDir = ObjCBool(false)
            #expect(manager.fileExists(atPath: path.string, isDirectory: &isDir))
            #expect(isDir.boolValue)
            #expect(manager.fileExists(atPath: containedFilePath.string))
            
        }
        
    }
    
    
    @Test("Create Dir: dir not exist / intermediate: not exist / createIntermediate: yes")
    func createDir7() async throws {
        
        let intermediateFolderPath = makeTestingFilePath()
        let path = intermediateFolderPath.appending("final")
        defer { try? manager.removeItem(atPath: intermediateFolderPath.string) }
        
        try await manager.createDirectory(at: path, withIntermediateDirectories: true)
        
        var isDir = ObjCBool(false)
        #expect(manager.fileExists(atPath: path.string, isDirectory: &isDir))
        #expect(isDir.boolValue)
        
    }
    
    
    @Test("Create Dir: dir not exist / intermediate: file / createIntermediate: yes")
    func createDir8() async throws {
        
        try await withFileAtPath { path, _ in
            
            let folderPath = path.appending("final")
            
            await #expect(throws: Error.self) {
                try await self.manager.createDirectory(at: folderPath, withIntermediateDirectories: true)
            }
            
        }
        
    }
    
}
