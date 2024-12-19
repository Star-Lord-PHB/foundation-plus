//
//  RemoveFileTest.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/8/3.
//

import Testing
@testable import FoundationPlus


extension FileManagerTest {
    
    @Suite("Test Removing File & Dir")
    final class RemoveFileTest: FileManagerTestCases {
        
        init() throws {
            try super.init(relativePath: "foundation_plus/file_manager/remove_file")
        }
        
    }
    
}


extension FileManagerTest.RemoveFileTest {
    
    @Test("Remove File: file exist")
    func removeFile1() async throws {
        
        try await withFileAtPath { path, _ in
            try await manager.removeItem(at: path)
            #expect(!manager.fileExists(atPath: path.string))
        }
        
    }
    
    
    @Test("Remove File: file not exist")
    func removeFile2() async throws {
        
        let path = makeTestingFilePath()
        
        await #expect(throws: Error.self) {
            try await manager.removeItem(at: path)
        }
        
    }
    
    
    @Test("Remove Dir: dir exist")
    func removeDir1() async throws {

        try await withFileTree(
            [
                .directory(name: "dir", [
                    .file(name: "contained.txt")])
            ]
        ) { tree in
            let dir = tree["dir"]
            try await manager.removeItem(at: dir.path)
            #expect(!manager.fileExists(at: dir.path))
        }
        
    }
    
    
    @Test("Remove Dir: dir not exist")
    func removeDir2() async throws {
        
        let path = makeTestingFilePath()
        
        await #expect(throws: Error.self) {
            try await manager.removeItem(at: path)
        }
        
    }
    
}
