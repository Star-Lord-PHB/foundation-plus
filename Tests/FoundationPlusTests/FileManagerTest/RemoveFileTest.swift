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
    class RemoveFileTest: FileManagerTestCases {
        
        init() throws {
            try super.init(relativePath: "foundation_plus/file_manager/remove_file")
        }
        
    }
    
}


extension FileManagerTest.RemoveFileTest {
    
    @Test("Remove File: file exist")
    func removeFile1() async throws {
        
        try await withFile { url, _ in
            try await manager.remove(at: url)
            #expect(!manager.fileExists(atPath: url.compactPath()))
        }
        
    }
    
    
    @Test("Remove File: file not exist")
    func removeFile2() async throws {
        
        let url = makeTestingFileUrl()
        
        await #expect(throws: Error.self) {
            try await manager.remove(at: url)
        }
        
    }
    
    
    @Test("Remove Dir: dir exist")
    func removeDir1() async throws {
        
        try await withDirectory { url in
            
            manager.createFile(
                atPath: url.appending(path: "contained.txt").compactPath(),
                contents: nil
            )
            
            try await manager.remove(at: url)
            
            #expect(!manager.fileExists(atPath: url.compactPath()))
            
        }
        
    }
    
    
    @Test("Remove Dir: dir not exist")
    func removeDir2() async throws {
        
        let url = makeTestingFileUrl()
        
        await #expect(throws: Error.self) {
            try await manager.remove(at: url)
        }
        
    }
    
}
