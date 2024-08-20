//
//  FileInfoTest.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/8/11.
//

import Testing
@testable import FoundationPlus


extension FileManagerTest {
    
    @Suite("Test Getting / Setting File Info")
    class FileInfoTest: FileManagerTestCases {
        
        init() throws {
            try super.init(relativePath: "foundation_plus/file_manager/file_info")
        }
        
    }
    
}



extension FileManagerTest.FileInfoTest {
    
    @Test("Get: file exist / type: regular")
    func getFileInfo1() async throws {
        
        try await withFile(content: "test1") { url, _ in
            
            try await Task.sleep(for: .milliseconds(500))
            
            let content = Data("test".utf8)
            try await manager.write(content, to: url)
            let _ = try await manager.contents(at: url)
            
            let info = try await manager.infoAsync(ofItemAt: url)
            let fileManagerAttributes = try manager.attributesOfItem(atPath: url.compactPath())
            
            #expect(info.fileSize == content.count)
            try #expect(url.resourceValues(forKeys: [.creationDateKey]).creationDate == info.creationDate)
            try #expect(url.resourceValues(forKeys: [.contentAccessDateKey]).contentAccessDate == info.contentAccessDate)
            try #expect(url.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate == info.contentModificationDate)
            #expect(info.ownerUID == getuid())
            #expect(info.ownerGID == getgid())
            #expect(info.posixPermission == fileManagerAttributes[.posixPermissions] as? UInt16)
            #expect(info.fileResourceType == .regular)
            #expect(info.isRegularFile)
            #expect(info.isDirectory == false)
            #expect(info.isSymbolicLink == false)
            #expect(info.isVolume == false)
            #expect(info.isPackage == false)
            #expect(info.isApplication == false)
            try #expect(url.resourceValues(forKeys: [.isReadableKey]).isReadable == info.isReadable)
            try #expect(url.resourceValues(forKeys: [.isWritableKey]).isWritable == info.isWritable)
            try #expect(url.resourceValues(forKeys: [.isExecutableKey]).isExecutable == info.isExecutable)
            
        }
        
    }
    
    
    @Test("Get: file exist / type: directory")
    func getFileInfo2() async throws {
        
        try await withDirectory { url in
            
            try await Task.sleep(for: .milliseconds(500))
            
            try await withFile(baseUrl: url) { entryUrl, _ in
                
                let info = try await manager.infoAsync(ofItemAt: url)
                let fileManagerAttributes = try manager.attributesOfItem(atPath: url.compactPath())
                
                #expect(info.fileSize == 0)
                try #expect(url.resourceValues(forKeys: [.creationDateKey]).creationDate == info.creationDate)
                try #expect(url.resourceValues(forKeys: [.contentAccessDateKey]).contentAccessDate == info.contentAccessDate)
                try #expect(url.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate == info.contentModificationDate)
                #expect(info.ownerUID == getuid())
                #expect(info.ownerGID == getgid())
                #expect(info.posixPermission == fileManagerAttributes[.posixPermissions] as? UInt16)
                #expect(info.fileResourceType == .directory)
                #expect(info.isRegularFile == false)
                #expect(info.isDirectory)
                #expect(info.isSymbolicLink == false)
                #expect(info.isVolume == false)
                #expect(info.isPackage == false)
                #expect(info.isApplication == false)
                try #expect(url.resourceValues(forKeys: [.isReadableKey]).isReadable == info.isReadable)
                try #expect(url.resourceValues(forKeys: [.isWritableKey]).isWritable == info.isWritable)
                try #expect(url.resourceValues(forKeys: [.isExecutableKey]).isExecutable == info.isExecutable)
                
                if #available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *) {
                    try #expect(manager.info(.directoryEntryCount, ofItemAt: url) == 1)
                }
                
            }
            
        }
        
    }
    
    
    @Test("Get: file exist / type: symbolic link")
    func getFileInfo3() async throws {
        
        try await withSymbolicLink { urls, _ in
            
            let url = urls.first!
            
            let info = try await manager.infoAsync(ofItemAt: url)
            let fileManagerAttributes = try manager.attributesOfItem(atPath: url.compactPath())
            
            try #expect(url.resourceValues(forKeys: [.fileSizeKey]).fileSize == info.fileSize)
            try #expect(url.resourceValues(forKeys: [.creationDateKey]).creationDate == info.creationDate)
            try #expect(url.resourceValues(forKeys: [.contentAccessDateKey]).contentAccessDate == info.contentAccessDate)
            try #expect(url.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate == info.contentModificationDate)
            #expect(info.ownerUID == getuid())
            #expect(info.ownerGID == getgid())
            #expect(info.posixPermission == fileManagerAttributes[.posixPermissions] as? UInt16)
            #expect(info.fileResourceType == .symbolicLink)
            #expect(info.isRegularFile == false)
            #expect(info.isDirectory == false)
            #expect(info.isSymbolicLink)
            #expect(info.isVolume == false)
            #expect(info.isPackage == false)
            #expect(info.isApplication == false)
            try #expect(url.resourceValues(forKeys: [.isReadableKey]).isReadable == info.isReadable)
            try #expect(url.resourceValues(forKeys: [.isWritableKey]).isWritable == info.isWritable)
            try #expect(url.resourceValues(forKeys: [.isExecutableKey]).isExecutable == info.isExecutable)
            
        }
        
    }
    
    
    @Test("Get: file not exist")
    func getFileInfo4() async throws {
        
        let url = makeTestingFileUrl()
        
        await #expect(throws: Error.self) {
            try await manager.infoAsync(ofItemAt: url)
        }
        
    }
    
}



extension FileManagerTest.FileInfoTest {
    
    @Test("Set: file exist / type: regular")
    func setFileInfo1() async throws {
        
        try await withFile { url, _ in
            
            let originalInfo = try await manager.infoAsync(ofItemAt: url)
            
            var setInfo = originalInfo
            setInfo.creationDate = .now.addingTimeInterval(-10)
            setInfo.contentAccessDate = .now.addingTimeInterval(-5)
            setInfo.contentModificationDate = .now.addingTimeInterval(-7)
            setInfo.posixPermission = (1 << 9) - 1
            
            try await manager.setInfoAsync(setInfo, forItemAt: url)
            
            let actualInfo = try url.resourceValues(forKeys: [
                .creationDateKey,
                .contentAccessDateKey,
                .contentModificationDateKey,
                .posixPermissionKey
            ])
            
            #expect(actualInfo.creationDate == setInfo.creationDate)
            #expect(actualInfo.contentAccessDate == setInfo.contentAccessDate)
            #expect(actualInfo.contentModificationDate == setInfo.contentModificationDate)
            #expect(actualInfo.posixPermission == setInfo.posixPermission)
            
        }
        
    }
    
    
    @Test("Set: file exist / type: directory")
    func setFileInfo2() async throws {
        
        try await withDirectory { url in
            
            let originalInfo = try await manager.infoAsync(ofItemAt: url)
            
            var setInfo = originalInfo
            setInfo.creationDate = .now.addingTimeInterval(-10)
            setInfo.contentAccessDate = .now.addingTimeInterval(-5)
            setInfo.contentModificationDate = .now.addingTimeInterval(-7)
            setInfo.posixPermission = (1 << 9) - 1
            
            try await manager.setInfoAsync(setInfo, forItemAt: url)
            
            let actualInfo = try url.resourceValues(forKeys: [
                .creationDateKey,
                .contentAccessDateKey,
                .contentModificationDateKey,
                .posixPermissionKey
            ])
            
            #expect(actualInfo.creationDate == setInfo.creationDate)
            #expect(actualInfo.contentAccessDate == setInfo.contentAccessDate)
            #expect(actualInfo.contentModificationDate == setInfo.contentModificationDate)
            #expect(actualInfo.posixPermission == setInfo.posixPermission)
            
        }
        
    }
    
    
    @Test("Set: file exist / type: symbolic link")
    func setFileInfo3() async throws {
        
        try await withSymbolicLink { urls, _ in
            
            let url = urls.first!
            let originalInfo = try await manager.infoAsync(ofItemAt: url)
            
            var setInfo = originalInfo
            setInfo.creationDate = .now.addingTimeInterval(-10)
            setInfo.contentAccessDate = .now.addingTimeInterval(-5)
            setInfo.contentModificationDate = .now.addingTimeInterval(-7)
            setInfo.posixPermission = (1 << 9) - 1
            
            try await manager.setInfoAsync(setInfo, forItemAt: url)
            
            let actualInfo = try url.resourceValues(forKeys: [
                .creationDateKey,
                .contentAccessDateKey,
                .contentModificationDateKey,
                .posixPermissionKey
            ])
            
            #expect(actualInfo.creationDate == setInfo.creationDate)
            #expect(actualInfo.contentAccessDate == setInfo.contentAccessDate)
            #expect(actualInfo.contentModificationDate == setInfo.contentModificationDate)
            #expect(actualInfo.posixPermission == setInfo.posixPermission)
            
        }
        
    }
    
    
    @Test("Set: file not exist")
    func setFileInfo4() async throws {
        
        let url = makeTestingFileUrl()
        
        var setInfo = FileManager.FileInfo()
        setInfo.creationDate = .now.addingTimeInterval(-10)
        setInfo.contentAccessDate = .now.addingTimeInterval(-5)
        setInfo.contentModificationDate = .now.addingTimeInterval(-7)
        setInfo.posixPermission = (1 << 9) - 1
        
        await #expect(throws: Error.self) {
            try await manager.setInfoAsync(setInfo, forItemAt: url)
        }
        
    }
    
    
    @Test("Set Single: file exist / type: regular")
    func setFileInfo5() async throws {
        
        try await withFile { url, _ in
            
            let newValue = Date.now.addingTimeInterval(-10)
            
            try await manager.setInfoAsync(
                .creationDate,
                to: newValue,
                forItemAt: url
            )
            
            let actualValue = try url.resourceValues(forKeys: [.creationDateKey]).creationDate
            
            #expect(actualValue == newValue)
            
        }
        
    }
    
    
    @Test("Set Single: file exist / type: directory")
    func setFileInfo6() async throws {
        
        try await withDirectory { url in
            
            let newValue = Date.now.addingTimeInterval(-10)
            
            try await manager.setInfoAsync(
                .creationDate,
                to: newValue,
                forItemAt: url
            )
            
            let actualValue = try url.resourceValues(forKeys: [.creationDateKey]).creationDate
            
            #expect(actualValue == newValue)
            
        }
        
    }
    
    
    @Test("Set Single: file exist / type: symbolic link")
    func setFileInfo7() async throws {
        
        try await withSymbolicLink { urls, _ in
            
            let url = urls.first!
            
            let newValue = Date.now.addingTimeInterval(-10)
            
            try await manager.setInfoAsync(
                .creationDate,
                to: newValue,
                forItemAt: url
            )
            
            let actualValue = try url.resourceValues(forKeys: [.creationDateKey]).creationDate
            
            #expect(actualValue == newValue)
            
        }
        
    }
    
}
