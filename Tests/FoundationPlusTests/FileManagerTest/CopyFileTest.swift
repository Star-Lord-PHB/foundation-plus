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
    class CopyFileTest: FileManagerTestCases {
        
        init() throws {
            try super.init(relativePath: "foundation_plus/file_manager/copy_file")
        }
        
    }
    
}


extension FileManagerTest.CopyFileTest {
    
    @Test("Copy File: file exist / dest not exist")
    func copyFile1() async throws {
        
        try await withFile(suffix: "-src", content: "test1") { src, srcContent in
            
            let dest = makeTestingFileUrl(suffix: "-dest")
            defer { try? manager.removeItem(at: dest) }
            
            try await manager.copy(src, to: dest)
            
            #expect(throws: Never.self) {
                try #expect(Data(contentsOf: src) == srcContent)
                try #expect(Data(contentsOf: dest) == srcContent)
            }
            
        }
        
    }
    
    
    @Test("Copy File: file exist / dest exist")
    func copyFile2() async throws {
        
        try await withFile(suffix: "-src", content: "test1") { src, srcContent in
            
            try await withFile(suffix: "-dest", content: "test2") { dest, destContent in
                
                await #expect(throws: Error.self) {
                    try await manager.copy(src, to: dest)
                }
                
                #expect(throws: Never.self) {
                    try #expect(Data(contentsOf: src) == srcContent)
                    try #expect(Data(contentsOf: dest) == destContent)
                }
                
            }
            
        }
        
    }
    
    
    @Test("Copy File: file not exist / dest not exist")
    func copyFile3() async throws {
        
        let src = makeTestingFileUrl(suffix: "-src")
        let dest = makeTestingFileUrl(suffix: "-dest")
        
        await #expect(throws: Error.self) {
            try await manager.copy(src, to: dest)
        }
        
    }
    
    
    @Test("Copy Dir: dir exist / dest not exist")
    func copyDir1() async throws {
        
        try await withDirectory(suffix: "-src") { src in
            
            try await withFile(baseUrl: src, content: "test1") { srcContainedUrl, srcContainedContent in
                
                let dest = makeTestingFileUrl(suffix: "-dest")
                let destContainedUrl = dest.appending(path: srcContainedUrl.lastPathComponent)
                defer { try? manager.removeItem(at: dest) }
                
                try await manager.copy(src, to: dest)
                
                #expect(throws: Never.self) {
                    try #expect(Data(contentsOf: srcContainedUrl) == srcContainedContent)
                    try #expect(Data(contentsOf: destContainedUrl) == srcContainedContent)
                }
                
            }
            
        }
        
    }
    
    
    @Test("Copy Dir: dir exist / dest exist")
    func copyDir2() async throws {
        
        try await withDirectory(suffix: "-src") { src in
            
            try await withDirectory(suffix: "-dest") { dest in
                
                try await withFile(baseUrl: src) { srcContainedUrl, srcContainedContent in
                    
                    try await withFile(baseUrl: dest) { destContainedUrl, destContainedContent in
                        
                        await #expect(throws: Error.self) {
                            try await self.manager.copy(src, to: dest)
                        }
                        
                        #expect(throws: Never.self) {
                            try #expect(Data(contentsOf: srcContainedUrl) == srcContainedContent)
                            try #expect(Data(contentsOf: destContainedUrl) == destContainedContent)
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    
    @Test("Copy Dir: dir not exist / dest not exist")
    func copyDir3() async throws {
        
        let src = makeTestingFileUrl(suffix: "-src")
        let dest = makeTestingFileUrl(suffix: "-dest")
        
        await #expect(throws: Error.self) {
            try await self.manager.copy(src, to: dest)
        }
        
    }
    
}
