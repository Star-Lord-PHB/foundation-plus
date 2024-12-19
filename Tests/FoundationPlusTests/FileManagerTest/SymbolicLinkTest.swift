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
    final class SymbolicLinkTest: FileManagerTestCases {
        
        init() throws {
            try super.init(relativePath: "foundation_plus/file_manager/symbolic_link")
        }
        
    }
    
}



extension FileManagerTest.SymbolicLinkTest {
    
    @Test("Resolve: link exist / dest exist / recursive: no")
    func resolve1() async throws {
        
        try await withSymbolicLinkAtPath(depth: 3) { paths, content in
            let resolved = try await manager.destinationOfSymbolicLink(at: paths[0], recursive: false)
            #expect(resolved == paths[1])
        }
        
    }
    
    
    @Test("Resolve: link exist / dest exist / recursive: yes")
    func resolve2() async throws {
        try await withSymbolicLinkAtPath(depth: 3) { paths, content in
            let resolved = try await manager.destinationOfSymbolicLink(at: paths[0])
            #expect(resolved == paths.last)
        }
    }
    
    
    @Test("Resolve: link not exist / dest not exist / recursive: yes")
    func resolve3() async throws {
        
        let path = makeTestingFilePath()
        await #expect(throws: Error.self) {
            try await manager.destinationOfSymbolicLink(at: path)
        }
        
    }
    
    
    @Test("Resolve: link not exist / dest not exist / recursive: no")
    func resolve4() async throws {
        
        let path = makeTestingFilePath()
        await #expect(throws: Error.self) {
            try await manager.destinationOfSymbolicLink(at: path, recursive: false)
        }
        
    }
    
    
    @Test("Resolve: link exist / dest not exist / recursive: yes")
    func resolve5() async throws {
        
        let srcPath = makeTestingFilePath(suffix: "-src")
        let destPath = makeTestingFilePath(suffix: "-dest")
        defer { try? manager.removeItem(atPath: srcPath.string) }
        
        try manager.createSymbolicLink(atPath: srcPath.string, withDestinationPath: destPath.string)
        
        let resolved = try await manager.destinationOfSymbolicLink(at: srcPath)
        #expect(resolved == destPath)
        
    }
    
    
    @Test("Resolve: link exist / dest not exist / recursive: no")
    func resolve6() async throws {
        
        let srcPath = makeTestingFilePath(suffix: "-src")
        let destPath = makeTestingFilePath(suffix: "-dest")
        defer { try? manager.removeItem(atPath: srcPath.string) }
        
        try manager.createSymbolicLink(atPath: srcPath.string, withDestinationPath: destPath.string)
        
        let resolved = try await manager.destinationOfSymbolicLink(at: srcPath, recursive: false)
        #expect(resolved == destPath)
        
    }
    
    
    @Test("Create: src not exist / dest exist / replace: no")
    func create1() async throws {
        
        try await withFileAtPath(content: "test") { destPath, content in
            
            let srcPath = makeTestingFilePath(suffix: "-src")
            defer { try? manager.removeItem(atPath: srcPath.string) }
            
            try await manager.createSymbolicLink(at: srcPath, withDestination: destPath)
            
            try #expect(self.contentOfFile(at: srcPath) == content)
            
        }
        
    }
    
    
    @Test("Create: src not exist / dest exist / replace: yes")
    func create2() async throws {
        
        try await withFileAtPath(content: "test") { destPath, content in
            
            let srcPath = makeTestingFilePath(suffix: "-src")
            defer { try? manager.removeItem(atPath: srcPath.string) }
            
            try await manager.createSymbolicLink(at: srcPath, withDestination: destPath, replaceExisting: true)
            
            try #expect(self.contentOfFile(at: srcPath) == content)
            
        }
        
    }
    
    
    @Test("Create: src not exist / dest not exist / replace: no")
    func create3() async throws {
        
        let srcPath = makeTestingFilePath(suffix: "-src")
        let destPath = makeTestingFilePath(suffix: "-dest")
        defer { try? manager.removeItem(atPath: srcPath.string) }
        
        try await manager.createSymbolicLink(at: srcPath, withDestination: destPath)
        
        try #expect(manager.destinationOfSymbolicLink(atPath: srcPath.string) == destPath.string)
        
    }
    
    
    @Test("Create: src not exist / dest not exist / replace: yes")
    func create4() async throws {
        
        let srcPath = makeTestingFilePath(suffix: "-src")
        let destPath = makeTestingFilePath(suffix: "-dest")
        defer { try? manager.removeItem(atPath: srcPath.string) }
        
        try await manager.createSymbolicLink(at: srcPath, withDestination: destPath, replaceExisting: true)
        
        try #expect(manager.destinationOfSymbolicLink(atPath: srcPath.string) == destPath.string)
        
    }
    
    
    @Test("Create: src exist / dest exist / replace: no")
    func create5() async throws {

        try await withFileTree(
            [
                .file(name: "src"),
                .file(name: "dest")
            ]
        ) { tree in

            let src = tree["src"]
            let dest = tree["dest"]

            await #expect(throws: Error.self) {
                try await manager.createSymbolicLink(at: src.path, withDestination: dest.path)
            }

        }
        
    }
    
    
    @Test("Create: src exist / dest exist / replace: yes")
    func create6() async throws {

        try await withFileTree(
            [
                .file(name: "src"),
                .file(name: "dest", content: "test")
            ]
        ) { tree in
            
            let src = tree["src"]
            let dest = tree["dest"]

            try await manager.createSymbolicLink(at: src.path, withDestination: dest.path, replaceExisting: true)

            try #expect(self.contentOfFile(at: src.path) == dest.content)

        }
        
    }
    
    
    @Test("Create: src exist / dest not exist / replace: yes")
    func create7() async throws {
        
        try await withFileAtPath(suffix: "-src") { srcPath, _ in
            
            let destPath = makeTestingFilePath(suffix: "-dest")
            
            try await manager.createSymbolicLink(at: srcPath, withDestination: destPath, replaceExisting: true)
            
            try #expect(manager.destinationOfSymbolicLink(atPath: srcPath.string) == destPath.string)
            
        }
        
    }
    
}
