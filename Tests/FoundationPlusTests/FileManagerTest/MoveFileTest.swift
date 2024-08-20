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
    class MoveFileTest: FileManagerTestCases {
        
        init() throws {
            try super.init(relativePath: "foundation_plus/file_manager/move_file")
        }
        
    }
    
}


extension FileManagerTest.MoveFileTest {
    
    @Test("Move File: file exist / dest not exist")
    func moveFile1() async throws {
        
        try await withFile(suffix: "-src", content: "test") { url, content in
            
            let dest = makeTestingFileUrl(suffix: "-dest")
            defer { try? manager.removeItem(at: dest) }
            
            try await manager.move(url, to: dest)
            
            #expect(!manager.fileExists(atPath: url.compactPath()))
            #expect(throws: Never.self) {
                try #expect(Data(contentsOf: dest) == content)
            }
            
        }
        
    }
    
    
    @Test("Move File: file exist / dest exist")
    func moveFile2() async throws {
        
        try await withFile(suffix: "-src", content: "src") { srcUrl, srcContent in
            
            try await withFile(suffix: "-dest", content: "dest") { destUrl, destContent in
                
                await #expect(throws: Error.self) {
                    try await self.manager.move(srcUrl, to: destUrl)
                }
                
                try #expect(Data(contentsOf: srcUrl) == srcContent)
                try #expect(Data(contentsOf: destUrl) == destContent)
                
            }
            
        }
        
    }
    
    
    @Test("Move File: file not exist / dest not exist")
    func moveFile3() async throws {
        
        let srcUrl = makeTestingFileUrl(suffix: "-src")
        let destUrl = makeTestingFileUrl(suffix: "-dest")
        
        await #expect(throws: Error.self) {
            try await self.manager.move(srcUrl, to: destUrl)
        }
        
    }
    
    
    @Test("Move Dir: dir exist / dest not exist")
    func moveDir1() async throws {
        
        try await withDirectory(suffix: "-src") { src in
            
            try await withFile(baseUrl: src, content: "test") { containedFileUrl, content in
                
                let dest = makeTestingFileUrl(suffix: "-dest")
                let destContainedFileUrl = dest.appending(path: containedFileUrl.lastPathComponent)
                defer { try? manager.removeItem(at: dest) }
                
                try await manager.move(src, to: dest)
                
                #expect(!manager.fileExists(atPath: src.compactPath()))
                var isDir = ObjCBool(false)
                #expect(manager.fileExists(atPath: dest.compactPath(), isDirectory: &isDir))
                #expect(isDir.boolValue)
                try #expect(Data(contentsOf: destContainedFileUrl) == content)
                
            }
            
        }
        
    }
    
    
    @Test("Move Dir: dir exist / dest exist")
    func moveDir2() async throws {
        
        try await withDirectory(suffix: "-src") { src in
            
            try await withDirectory(suffix: "-dest") { dest in
                
                try await withFile(baseUrl: src, content: "test1") { srcContainedFileUrl, srcContent in
                    
                    try await withFile(baseUrl: dest, content: "test2") { destContainedFileUrl, destContent in
                        
                        await #expect(throws: Error.self) {
                            try await self.manager.move(src, to: dest)
                        }
                        
                        var isDir = ObjCBool(false)
                        #expect(manager.fileExists(atPath: src.compactPath(), isDirectory: &isDir))
                        #expect(isDir.boolValue)
                        #expect(manager.fileExists(atPath: dest.compactPath()))
                        #expect(throws: Never.self) {
                            try #expect(Data(contentsOf: srcContainedFileUrl) == srcContent)
                            try #expect(Data(contentsOf: destContainedFileUrl) == destContent)
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    
    @Test("Move Dir: dir not exist / dest not exist")
    func moveDir3() async throws {
        
        let src = makeTestingFileUrl(suffix: "-src")
        let dest = makeTestingFileUrl(suffix: "-dest")
        
        await #expect(throws: Error.self) {
            try await self.manager.move(src, to: dest)
        }
        
    }
    
}
