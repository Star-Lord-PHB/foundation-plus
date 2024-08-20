//
//  SymbolicLinkTest.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/8/4.
//

import Testing
@testable import FoundationPlus


extension FileManagerTest {
    
    @Suite("Test Symbolic Link")
    class SymbolicLinkTest: FileManagerTestCases {
        
        init() throws {
            try super.init(relativePath: "foundation_plus/file_manager/symbolic_link")
        }
        
    }
    
}



extension FileManagerTest.SymbolicLinkTest {
    
    @Test("Resolve: link exist / dest exist / recursive: no")
    func resolve1() async throws {
        
        try await withSymbolicLink(depth: 3) { urls, content in
            let resolved = try await manager.resolveSymbolicLink(at: urls[0], recursive: false)
            #expect(resolved == urls[1])
        }
        
    }
    
    
    @Test("Resolve: link exist / dest exist / recursive: yes")
    func resolve2() async throws {
        try await withSymbolicLink(depth: 3) { urls, content in
            let resolved = try await manager.resolveSymbolicLink(at: urls[0])
            #expect(resolved == urls.last!)
        }
    }
    
    
    @Test("Resolve: link not exist / dest not exist / recursive: yes")
    func resolve3() async throws {
        
        let url = makeTestingFileUrl()
        try await #expect(manager.resolveSymbolicLink(at: url) == url)
        
    }
    
    
    @Test("Resolve: link not exist / dest not exist / recursive: no")
    func resolve4() async throws {
        
        let url = makeTestingFileUrl()
        try await #expect(manager.resolveSymbolicLink(at: url, recursive: false) == url)
        
    }
    
    
    @Test("Resolve: link exist / dest not exist / recursive: yes")
    func resolve5() async throws {
        
        let src = makeTestingFileUrl(suffix: "-src")
        let dest = makeTestingFileUrl(suffix: "-dest")
        defer { try? manager.removeItem(at: src) }
        
        try manager.createSymbolicLink(at: src, withDestinationURL: dest)
        
        let resolved = try await manager.resolveSymbolicLink(at: src)
        #expect(resolved == dest)
        
    }
    
    
    @Test("Resolve: link exist / dest not exist / recursive: no")
    func resolve6() async throws {
        
        let src = makeTestingFileUrl(suffix: "-src")
        let dest = makeTestingFileUrl(suffix: "-dest")
        defer { try? manager.removeItem(at: src) }
        
        try manager.createSymbolicLink(at: src, withDestinationURL: dest)
        
        let resolved = try await manager.resolveSymbolicLink(at: src, recursive: false)
        #expect(resolved == dest)
        
    }
    
    
    @Test("Create: src not exist / dest exist / replace: no")
    func create1() async throws {
        
        try await withFile(content: "test") { dest, content in
            
            let src = makeTestingFileUrl(suffix: "-src")
            defer { try? manager.removeItem(at: src) }
            
            try await manager.createSymbolicLink(at: src, for: dest)
            
            try #expect(Data(contentsOf: src) == content)
            
        }
        
    }
    
    
    @Test("Create: src not exist / dest exist / replace: yes")
    func create2() async throws {
        
        try await withFile(content: "test") { dest, content in
            
            let src = makeTestingFileUrl(suffix: "-src")
            defer { try? manager.removeItem(at: src) }
            
            try await manager.createSymbolicLink(at: src, for: dest, replaceExisting: true)
            
            try #expect(Data(contentsOf: src) == content)
            
        }
        
    }
    
    
    @Test("Create: src not exist / dest not exist / replace: no")
    func create3() async throws {
        
        let src = makeTestingFileUrl(suffix: "-src")
        let dest = makeTestingFileUrl(suffix: "-dest")
        defer { try? manager.removeItem(at: src) }
        
        try await manager.createSymbolicLink(at: src, for: dest)
        
        try #expect(manager.destinationOfSymbolicLink(atPath: src.compactPath()) == dest.compactPath())
        
    }
    
    
    @Test("Create: src not exist / dest not exist / replace: yes")
    func create4() async throws {
        
        let src = makeTestingFileUrl(suffix: "-src")
        let dest = makeTestingFileUrl(suffix: "-dest")
        defer { try? manager.removeItem(at: src) }
        
        try await manager.createSymbolicLink(at: src, for: dest, replaceExisting: true)
        
        try #expect(manager.destinationOfSymbolicLink(atPath: src.compactPath()) == dest.compactPath())
        
    }
    
    
    @Test("Create: src exist / dest exist / replace: no")
    func create5() async throws {
        
        try await withFile(suffix: "-src") { _, _ in
            
            try await withFile(suffix: "-dest") { dest, _ in
                
                let src = makeTestingFileUrl(suffix: "-src")
                defer { try? manager.removeItem(at: src) }
                
                await #expect(throws: Error.self) {
                    try await manager.createSymbolicLink(at: src, for: dest)
                }
                
            }
            
        }
        
    }
    
    
    @Test("Create: src exist / dest exist / replace: yes")
    func create6() async throws {
        
        try await withFile(suffix: "-src") { _, _ in
            
            try await withFile(suffix: "-dest", content: "test") { dest, content in
                
                let src = makeTestingFileUrl(suffix: "-src")
                defer { try? manager.removeItem(at: src) }
                
                try await manager.createSymbolicLink(at: src, for: dest, replaceExisting: true)
                
                try #expect(Data(contentsOf: src) == content)
                
            }
            
        }
        
    }
    
    
    @Test("Create: src exist / dest not exist / replace: yes")
    func create7() async throws {
        
        try await withFile(suffix: "-src") { _, _ in
            
            let src = makeTestingFileUrl(suffix: "-src")
            let dest = makeTestingFileUrl(suffix: "-dest")
            defer { try? manager.removeItem(at: src) }
            
            try await manager.createSymbolicLink(at: src, for: dest, replaceExisting: true)
            
            try #expect(manager.destinationOfSymbolicLink(atPath: src.compactPath()) == dest.compactPath())
            
        }
        
    }
    
}
