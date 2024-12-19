//
//  CopyFileTest.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/8/3.
//

import Testing
@testable import FoundationPlus


extension FileManagerTest {
    
    @Suite("Test Copying File & Dir")
    final class CopyFileTest: FileManagerTestCases {
        
        init() throws {
            try super.init(relativePath: "foundation_plus/file_manager/copy_file")
        }
        
    }
    
}


extension FileManagerTest.CopyFileTest {
    
    @Test("Copy File: file exist / dest not exist")
    func copyFile1() async throws {
        
        try await withFileAtPath(suffix: "-src", content: "test1") { srcPath, srcContent in
            
            let destPath = makeTestingFilePath(suffix: "-dest")
            defer { try? manager.removeItem(at: destPath) }
            
            try await manager.copyItem(at: srcPath, to: destPath)
            
            #expect(throws: Never.self) {
                try #expect(self.contentOfFile(at: srcPath) == srcContent)
                try #expect(self.contentOfFile(at: destPath) == srcContent)
            }
            
        }
        
    }
    
    
    @Test("Copy File: file exist / dest exist")
    func copyFile2() async throws {

        try await withFileTree(
            [
                .file(name: "src", content: "test1"),
                .file(name: "dest", content: "test2")
            ]
        ) { tree in
            
            let srcFile = tree["src"]
            let destFile = tree["dest"]

            await #expect(throws: Error.self) {
                try await manager.copyItem(at: srcFile.path, to: destFile.path)
            }

            #expect(throws: Never.self) {
                try #expect(self.contentOfFile(at: srcFile.path) == srcFile.content)
                try #expect(self.contentOfFile(at: destFile.path) == destFile.content)
            }

        }
        
    }
    
    
    @Test("Copy File: file not exist / dest not exist")
    func copyFile3() async throws {
        
        let src = makeTestingFilePath(suffix: "-src")
        let dest = makeTestingFilePath(suffix: "-dest")
        
        await #expect(throws: Error.self) {
            try await manager.copyItem(at: src, to: dest)
        }
        
    }
    
    
    @Test("Copy Dir: dir exist / dest not exist")
    func copyDir1() async throws {

        try await withFileTree(
            [
                .directory(name: "src", [
                    .file(name: "test", content: "test")])
            ]
        ) { tree in
            
            let srcDir = tree["src"]
            let destDirPath = tree.path.appending("dest")
            let srcContainedFile = srcDir["test"]
            let destContainedPath = destDirPath.appending(srcContainedFile.path.lastComponent!)

            try await manager.copyItem(at: srcDir.path, to: destDirPath)

            #expect(throws: Never.self) {
                try #expect(self.contentOfFile(at: srcContainedFile.path) == srcContainedFile.content)
                try #expect(self.contentOfFile(at: destContainedPath) == srcContainedFile.content)
            }

        }
        
    }
    
    
    @Test("Copy Dir: dir exist / dest exist")
    func copyDir2() async throws {

        try await withFileTree(
            [
                .directory(name: "src", [
                    .file(name: "test", content: "test1")]),
                .directory(name: "dest", [
                    .file(name: "test", content: "test2")])
            ]
        ) { tree in
            
            let srcDir = tree["src"]
            let destDir = tree["dest"]
            let srcContainedFile = srcDir["test"]
            let destContainedFile = destDir["test"]

            await #expect(throws: Error.self) {
                try await manager.copyItem(at: srcDir.path, to: destDir.path)
            }

            #expect(throws: Never.self) {
                try #expect(self.contentOfFile(at: srcContainedFile.path) == srcContainedFile.content)
                try #expect(self.contentOfFile(at: destContainedFile.path) == destContainedFile.content)
            }

        }
        
    }
    
    
    @Test("Copy Dir: dir not exist / dest not exist")
    func copyDir3() async throws {
        
        let src = makeTestingFilePath(suffix: "-src")
        let dest = makeTestingFilePath(suffix: "-dest")
        
        await #expect(throws: Error.self) {
            try await self.manager.copyItem(at: src, to: dest)
        }
        
    }
    
}
