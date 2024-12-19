//
//  WriteHandleCreationTest.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/8/2.
//

import Testing
@testable import FoundationPlus


extension FileManagerTest {
    
    @Suite("Test Creating FileHandle for Writing")
    final class WriteHandleCreationTest: FileManagerTestCases {
        
        init() throws {
            try super.init(relativePath: "foundation_plus/file_manager/write_handle_creation")
        }
    }
    
}



extension FileManagerTest.WriteHandleCreationTest {
    
    // MARK: Group 1 - File Exist / Create: No, Existing: Open
    
    
    @Test("Open - file exist / create: no, existing: open")
    func openForWrite1() async throws {
        
        try await withFileAtPath(content: "original") { path, originalContent in
            
            let newContent = Data("test".utf8)
            
            let handle = try await manager.openFile(forWritingTo: path)
            try await handle.write(contentsOf: newContent)
            
            let expectedContent = newContent + originalContent.dropFirst(newContent.count)
            try #expect(self.contentOfFile(at: path) == expectedContent)
            
        }
        
    }
    
    
    @Test("WithHandle: file exist / create: no, existing: open")
    func withWriteHandle1() async throws {
        
        try await withFileAtPath(content: "original") { path, originalContent in
            
            let newContent = Data("test".utf8)
            
            try await manager.withFileHandle(forWritingTo: path) { handle in
                try handle.write(contentsOf: newContent)
            }
            
            let expectedContent = newContent + originalContent.dropFirst(newContent.count)
            try #expect(self.contentOfFile(at: path) == expectedContent)
            
        }
        
    }
    
    
    // MARK: Group 2 - File Not Exist / Create: No / Existing: Open
    
    
    @Test("Open: file not exist / create: no, replace: open")
    func openForWrite2() async throws {
        
        let path = makeTestingFilePath()
        
        await #expect(throws: Error.self) {
            let handle = try await manager.openFile(forWritingTo: path)
            try await handle.close()
        }
        
    }
    
    
    @Test("WithHandle: file not exist / create: no, existing: open")
    func withWriteHandle2() async throws {
        
        let path = makeTestingFilePath()
        
        await #expect(throws: Error.self) {
            let _ = try await manager.withFileHandle(forWritingTo: path, operation: { _ in })
        }
        
    }
    
    
    // MARK: Group 3 - File Exist / Create: No, Existing: Truncate
    
    
    @Test("Open: file exist / create: no, existing: truncate")
    func openForWrite3() async throws {
        
        try await withFileAtPath(content: "test1") { path, content in
            
            let handle = try await manager.openFile(
                forWritingTo: path,
                options: .init(newFile: false, existingFile: .truncate)
            )

            defer { try? handle.close() }
            
            let newContent = Data("test".utf8)
            try await handle.write(contentsOf: newContent)
            
            try #expect(self.contentOfFile(at: path) == newContent)
            
        }
        
    }
    
    
    @Test("WithHandle: file exist / create: no, existing: truncate")
    func withWriteHandle3() async throws {
        
        try await withFileAtPath(content: "test1") { path, content in
            
            let newContent = Data("test".utf8)
            
            try await manager.withFileHandle(
                forWritingTo: path,
                options: .init(newFile: false, existingFile: .truncate)
            ) { handle in
                try handle.write(contentsOf: newContent)
            }
            
            try #expect(self.contentOfFile(at: path) == newContent)
            
        }
        
    }
    
    
    // MARK: Group 4 - File Not Exist / Create: No, Existing: truncate
    
    
    @Test("Open: file not exist / create: no, existing: truncate")
    func openForWrite4() async throws {
        
        let path = makeTestingFilePath()
        
        await #expect(throws: Error.self) {
            let handle = try await manager.openFile(
                forWritingTo: path,
                options: .init(newFile: false, existingFile: .truncate)
            )
            try await handle.close()
        }
        
    }
    
    
    @Test("WithHandle: file not exist / create: no, existing: truncate")
    func withWriteHandle4() async throws {
        
        let path = makeTestingFilePath()
        
        await #expect(throws: Error.self) {
            let _ = try await manager.withFileHandle(
                forWritingTo: path,
                options: .init(newFile: false, existingFile: .truncate),
                operation: { _ in }
            )
        }
        
    }
    
    
    // MARK: Group 5 - File Exist / Create: No, Existing: Error
    
    
    @Test("Open: file exist / create: no, existing: error")
    func openForWrite5() async throws {
        
        try await withFileAtPath { path, _ in
            await #expect(throws: Error.self) {
                let _ = try await self.manager.openFile(
                    forWritingTo: path,
                    options: .init(newFile: false, existingFile: .error)
                )
            }
        }
        
    }
    
    
    @Test("WithHandle: file exist / create: no, existing: error")
    func withWriteHandle5() async throws {
        
        try await withFileAtPath { path, _ in
            await #expect(throws: Error.self) {
                let _ = try await self.manager.withFileHandle(
                    forWritingTo: path,
                    options: .init(newFile: false, existingFile: .error),
                    operation: { _ in }
                )
            }
        }
        
    }
    
    
    // MARK: Group 6 - File Not Exist / Create: No, Existing: Error
    
    
    @Test("Open: file not exist / create: no, existing: error")
    func openForWrite6() async throws {
        
        let path = makeTestingFilePath()
        
        await #expect(throws: Error.self) {
            let handle = try await self.manager.openFile(
                forWritingTo: path,
                options: .init(newFile: false, existingFile: .error)
            )
            try await handle.close()
        }
        
    }
    
    
    @Test("WithHandle: file not exist / create: no, existing: error")
    func withWriteHandle6() async throws {
        
        let path = makeTestingFilePath()
        
        await #expect(throws: Error.self) {
            let _ = try await self.manager.withFileHandle(
                forWritingTo: path,
                options: .init(newFile: false, existingFile: .error),
                operation: { _ in }
            )
        }
        
    }
    
    
    // MARK: Group 7 - File Exist / Create: Yes, Existing: Error
    
    
    @Test("Open: file exist / create: yes, existing: error")
    func openForWrite7() async throws {
        
        try await withFileAtPath { path, _ in
            
            await #expect(throws: Error.self) {
                let handle = try await self.manager.openFile(
                    forWritingTo: path,
                    options: .newFile(replaceExisting: false)
                )
                try await handle.close()
            }
            
        }
        
    }
    
    
    @Test("WithHandle: file exist / create: yes, existing: error")
    func withWriteHandle7() async throws {
        
        try await withFileAtPath { path, _ in
            
            await #expect(throws: Error.self) {
                try await self.manager.withFileHandle(
                    forWritingTo: path,
                    options: .newFile(replaceExisting: false),
                    operation: { _ in }
                )
            }
            
        }
        
    }
    
    
    // MARK: Group 8 - File Not Exist / Create: Yes, Existing: Error
    
    
    @Test("Open: file not exist / create: yes, existing: error")
    func openForWrite8() async throws {
        
        let path = makeTestingFilePath()
        let content = Data("test".utf8)
        
        defer { try? manager.removeItem(atPath: path.string) }
        
        let handle = try await manager.openFile(
            forWritingTo: path,
            options: .newFile(replaceExisting: false)
        )

        defer { try? handle.close() }
        
        try await handle.write(contentsOf: content)
        
        try #expect(self.contentOfFile(at: path) == content)
        
    }
    
    
    @Test("WithHandle: file not exist / create: yes, existing: error")
    func withWriteHandle8() async throws {
        
        let path = makeTestingFilePath()
        let content = Data("test".utf8)
        
        defer { try? manager.removeItem(atPath: path.string) }
        
        try await manager.withFileHandle(
            forWritingTo: path,
            options: .newFile(replaceExisting: false)
        ) { handle in
            try handle.write(contentsOf: content)
        }
        
        try #expect(self.contentOfFile(at: path) == content)
        
    }
    
    
    // MARK: Group 9 - File Exist / Create: Yes, Existing: Truncate
    
    
    @Test("Open: file exist / create: yes, existing: truncate")
    func openForWrite9() async throws {
        
        try await withFileAtPath(content: "test1") { path, content in
            
            let newContent = Data("test".utf8)
            
            let handle = try await manager.openFile(forWritingTo: path, options: .newFile(replaceExisting: true))
            defer {  try? handle.close() }

            try await handle.write(contentsOf: newContent)
            
            try #expect(self.contentOfFile(at: path) == newContent)
            
        }
        
    }
    
    
    @Test("WithHandle: file exist / create: yes, existing: truncate")
    func withWriteHandle9() async throws {
        
        try await withFileAtPath(content: "test1") { path, content in
            
            let newContent = Data("test".utf8)
            
            try await manager.withFileHandle(
                forWritingTo: path,
                options: .newFile(replaceExisting: true)
            ) { handle in
                try handle.write(contentsOf: newContent)
            }
            
            try #expect(self.contentOfFile(at: path) == newContent)
            
        }
        
    }
    
    
    // MARK: Group 10 - File Not Exist / Create: Yes, Existing: Truncate
    
    
    @Test("Open: file not exist / create: yes, existing: truncate")
    func openForWrite10() async throws {
        
        let path = makeTestingFilePath()
        let newContent = Data("test".utf8)
        
        defer { try? manager.removeItem(atPath: path.string) }
        
        let handle = try await manager.openFile(forWritingTo: path, options: .newFile(replaceExisting: true))
        defer { try? handle.close() }

        try await handle.write(contentsOf: newContent)
        
        try #expect(self.contentOfFile(at: path) == newContent)
        
    }
    
    
    @Test("WithHandle: file not exist / create: yes, existing: truncate")
    func withWriteHandle10() async throws {
        
        let path = makeTestingFilePath()
        let newContent = Data("test".utf8)
        
        defer { try? manager.removeItem(atPath: path.string) }
        
        try await manager.withFileHandle(
            forWritingTo: path,
            options: .newFile(replaceExisting: true)
        ) { handle in
            try handle.write(contentsOf: newContent)
        }
        
        try #expect(self.contentOfFile(at: path) == newContent)
        
    }
    
    
    // MARK: Group 11 - File Exist / Create: Yes, Existing: Open
    
    
    @Test("Open: file exist / create: yes, existing: open")
    func openForWrite11() async throws {
        
        try await withFileAtPath(content: "original") { path, originalContent in
            
            let newContent = Data("test".utf8)
            
            let handle = try await manager.openFile(
                forWritingTo: path,
                options: .init(newFile: true, existingFile: .open)
            )
            try await handle.write(contentsOf: newContent)
            
            let expectedContent = newContent + originalContent.dropFirst(newContent.count)
            try #expect(self.contentOfFile(at: path) == expectedContent)
            
        }
        
    }
    
    
    @Test("WithHandle: file exist / create: yes, existing: open")
    func withWriteHandle11() async throws {
        
        try await withFileAtPath(content: "original") { path, originalContent in
            
            let newContent = Data("test".utf8)
            
            try await manager.withFileHandle(
                forWritingTo: path,
                options: .init(newFile: true, existingFile: .open)
            ) { handle in
                try handle.write(contentsOf: newContent)
            }
            
            let expectedContent = newContent + originalContent.dropFirst(newContent.count)
            try #expect(self.contentOfFile(at: path) == expectedContent)
            
        }
        
    }
    
    
    // MARK: Group 12 - File Not Exist / Create: Yes, Existing: Open
    
    
    @Test("Open: file not exist / create: yes, existing: open")
    func openForWrite12() async throws {
        
        let path = makeTestingFilePath()
        let content = Data("test".utf8)
        
        defer { try? manager.removeItem(atPath: path.string) }
        
        let handle = try await manager.openFile(
            forWritingTo: path,
            options: .init(newFile: true, existingFile: .open)
        )
        try await handle.write(contentsOf: content)
        
        try #expect(self.contentOfFile(at: path) == content)
        
    }
    
    
    @Test("WithHandle: file not exist / create: yes, existing: open")
    func withWriteHandle12() async throws {
        
        let path = makeTestingFilePath()
        let content = Data("test".utf8)
        
        defer { try? manager.removeItem(atPath: path.string) }
        
        try await manager.withFileHandle(
            forWritingTo: path,
            options: .init(newFile: true, existingFile: .open)
        ) { handle in
            try handle.write(contentsOf: content)
        }
        
        try #expect(self.contentOfFile(at: path) == content)
        
    }
    
}
