//
//  MoveFileTest.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/8/3.
//

import Testing
@testable import FoundationPlus


extension FileManagerTest {
    
    @Suite("Test Moving File & Dir")
    final class MoveFileTest: FileManagerTestCases {
        
        init() throws {
            try super.init(relativePath: "foundation_plus/file_manager/move_file")
        }
        
    }
    
}


extension FileManagerTest.MoveFileTest {
    
    @Test("Move File: file exist / dest not exist")
    func moveFile1() async throws {
        
        try await withFileAtPath(suffix: "-src", content: "test") { path, content in
            
            let destPath = makeTestingFilePath(suffix: "-dest")
            defer { try? manager.removeItem(atPath: destPath.string) }
            
            try await manager.moveItem(at: path, to: destPath)
            
            #expect(!manager.fileExists(atPath: path.string))
            #expect(throws: Never.self) {
                try #expect(self.contentOfFile(at: destPath) == content)
            }
            
        }
        
    }
    
    
    @Test("Move File: file exist / dest exist")
    func moveFile2() async throws {

        try await withFileTree(
            [
                .file(name: "src", content: "src"),
                .file(name: "dest", content: "dest")
            ]
        ) { tree in

            let srcFile = tree["src"]
            let destFile = tree["dest"]
            
            await #expect(throws: Error.self) {
                try await self.manager.moveItem(at: srcFile.path, to: destFile.path)
            }
            
            try #expect(self.contentOfFile(at: srcFile.path) == srcFile.content)
            try #expect(self.contentOfFile(at: destFile.path) == destFile.content)

        }
        
    }
    
    
    @Test("Move File: file not exist / dest not exist")
    func moveFile3() async throws {
        
        let srcFilePath = makeTestingFilePath(suffix: "-src")
        let destFilePath = makeTestingFilePath(suffix: "-dest")
        
        await #expect(throws: Error.self) {
            try await self.manager.moveItem(at: srcFilePath, to: destFilePath)
        }
        
    }
    
    
    @Test("Move Dir: dir exist / dest not exist")
    func moveDir1() async throws {

        try await withFileTree(
            [
                .directory(name: "src", [
                    .file(name: "test", content: "test")]),
            ]
        ) { tree in
            
            let srcDir = tree["src"]
            let srcContainedFile = srcDir["test"]
            let destDirPath = tree.path.appending("dest")
            let destContainedFilePath = destDirPath.appending(srcContainedFile.name)

            try await manager.moveItem(at: srcDir.path, to: destDirPath)

            #expect(!manager.fileExists(atPath: srcDir.path.string))
            var isDir = ObjCBool(false)
            #expect(manager.fileExists(atPath: destDirPath.string, isDirectory: &isDir))
            #expect(isDir.boolValue)
            try #expect(self.contentOfFile(at: destContainedFilePath) == srcContainedFile.content)

        }
        
    }
    
    
    @Test("Move Dir: dir exist / dest exist")
    func moveDir2() async throws {

        try await withFileTree(
            [
                .directory(name: "src", [
                    .file(name: "test", content: "test1")]),
                .directory(name: "dest", [
                    .file(name: "test", content: "test2")])
            ]
        ) { tree in
            
            let srcDir = tree["src"]
            let srcContainedFile = srcDir["test"]
            let destDir = tree["dest"]
            let destContainedFile = destDir["test"]

            await #expect(throws: Error.self) {
                try await self.manager.moveItem(at: srcDir.path, to: destDir.path)
            }

            var isDir = ObjCBool(false)
            #expect(manager.fileExists(atPath: srcDir.path.string, isDirectory: &isDir))
            #expect(isDir.boolValue)
            #expect(manager.fileExists(atPath: destDir.path.string))
            try #expect(self.contentOfFile(at: srcContainedFile.path) == srcContainedFile.content)
            try #expect(self.contentOfFile(at: destContainedFile.path) == destContainedFile.content)

        }
        
    }
    
    
    @Test("Move Dir: dir not exist / dest not exist")
    func moveDir3() async throws {
        
        let srcFilePath = makeTestingFilePath(suffix: "-src")
        let destFilePath = makeTestingFilePath(suffix: "-dest")
        
        await #expect(throws: Error.self) {
            try await self.manager.moveItem(at: srcFilePath, to: destFilePath)
        }
        
    }
    
}
