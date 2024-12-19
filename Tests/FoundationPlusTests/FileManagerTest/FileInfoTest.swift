//
//  FileInfoTest.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/8/11.
//

import Testing
@testable import FoundationPlus
import WinSDK


extension FileManagerTest {
    
    @Suite("Test Getting / Setting File Info")
    final class FileInfoTest: FileManagerTestCases {
        
        init() throws {
            try super.init(relativePath: "foundation_plus/file_manager/file_info")
        }
        
    }
    
}



extension FileManagerTest.FileInfoTest {
    
    @Test("Get: file exist / type: regular")
    func getFileInfo1() async throws {
        
        try await withFileAtPath(content: "test1") { path, content in
            
            let url = URL(filePath: path.string)
            let info = try await manager.infoOfItem(at: path)
            let fileManagerAttributes = try manager.attributesOfItem(atPath: path.string)
            
            #expect(info.size == content.count)
            #expect(fileManagerAttributes[.creationDate] as? Date == info.creationDate)

            // The url ResourceValues only support precision to seconds
            let lastAccessDateToSeconds = Calendar.current.dateInterval(of: .second, for: info.lastAccessDate)?.start
            try #expect(url.resourceValues(forKeys: [.contentAccessDateKey]).contentAccessDate == lastAccessDateToSeconds)

            #expect(fileManagerAttributes[.modificationDate] as? Date == info.modificationDate)
#if os(Windows)
            try await #expect(getFileOwnerSidWithCmd(at: path) == info.sid)
#else
            #expect(info.ownerUID == getuid())
            #expect(info.ownerGID == getgid())
#endif
            #expect(info.posixPermissionBits == fileManagerAttributes[.posixPermissions] as? UInt16)
            #expect(info.type == .typeRegular)
            
        }
        
    }
    
    
    @Test("Get: file exist / type: directory")
    func getFileInfo2() async throws {
        
        try await withDirectoryAtPath { path in
            
            let url = URL(filePath: path.string)
            let info = try await manager.infoOfItem(at: path)
            let fileManagerAttributes = try manager.attributesOfItem(atPath: path.string)
            
            #expect(info.size == 0)
            #expect(fileManagerAttributes[.creationDate] as? Date == info.creationDate)
            
            let lastAccessDateToSeconds = Calendar.current.dateInterval(of: .second, for: info.lastAccessDate)?.start
            try #expect(url.resourceValues(forKeys: [.contentAccessDateKey]).contentAccessDate == lastAccessDateToSeconds)
            #expect(fileManagerAttributes[.modificationDate] as? Date == info.modificationDate)

            #expect(fileManagerAttributes[.modificationDate] as? Date == info.modificationDate)
#if os(Windows)
            try await #expect(getFileOwnerSidWithCmd(at: path) == info.sid)
#else
            #expect(info.ownerUID == getuid())
            #expect(info.ownerGID == getgid())
#endif
            #expect(info.posixPermissionBits == fileManagerAttributes[.posixPermissions] as? UInt16)
            #expect(info.type == .typeDirectory)
            
        }
        
    }
    
    
    @Test("Get: file exist / type: symbolic link")
    func getFileInfo3() async throws {
        
        try await withSymbolicLinkAtPath { paths, _ in
            
            let path = paths.first!
            let url = URL(filePath: path.string)
            
            let info = try await manager.infoOfItem(at: path)
            let fileManagerAttributes = try manager.attributesOfItem(atPath: path.string)
            
            #expect(info.size == 0)
            #expect(fileManagerAttributes[.creationDate] as? Date == info.creationDate)
            
            let lastAccessDateToSeconds = Calendar.current.dateInterval(of: .second, for: info.lastAccessDate)?.start
            try #expect(url.resourceValues(forKeys: [.contentAccessDateKey]).contentAccessDate == lastAccessDateToSeconds)
            #expect(fileManagerAttributes[.modificationDate] as? Date == info.modificationDate)

            #expect(fileManagerAttributes[.modificationDate] as? Date == info.modificationDate)
#if os(Windows)
            try await #expect(getFileOwnerSidWithCmd(at: path) == info.sid)
#else
            #expect(info.ownerUID == getuid())
            #expect(info.ownerGID == getgid())
#endif
            #expect(info.posixPermissionBits == fileManagerAttributes[.posixPermissions] as? UInt16)
            #expect(info.type == .typeSymbolicLink)
            
        }
        
    }
    
    
    @Test("Get: file not exist")
    func getFileInfo4() async throws {
        
        let path = makeTestingFilePath()
        
        await #expect(throws: Error.self) {
            try await manager.infoOfItem(at: path)
        }
        
    }
    
}



extension FileManagerTest.FileInfoTest {
    
    @Test("Set: file exist / type: regular")
    func setFileInfo1() async throws {
        
        try await withFileAtPath { path, _ in
            
            var setInfo = try await manager.infoOfItem(at: path)
            setInfo.creationDate = .now.addingTimeInterval(-10)
            setInfo.lastAccessDate = .now.addingTimeInterval(-5)
            setInfo.modificationDate = .now.addingTimeInterval(-7)
#if os(Windows)
            setInfo.isHidden = true
            setInfo.isArchive = true
            setInfo.notContentIndexed = true 
#else
            setInfo.posixPermissions = (1 << 9) - 1
#endif

            try await manager.setInfo(setInfo, forItemAt: path)

            let newInfo = try await manager.infoOfItem(at: path)
            
            #expect(newInfo == setInfo)
            
        }
        
    }
    
    
    @Test("Set: file exist / type: directory")
    func setFileInfo2() async throws {
        
        try await withDirectoryAtPath { path in
            
            var setInfo = try await manager.infoOfItem(at: path)
            setInfo.creationDate = .now.addingTimeInterval(-10)
            setInfo.lastAccessDate = .now.addingTimeInterval(-5)
            setInfo.modificationDate = .now.addingTimeInterval(-7)
#if os(Windows)
            setInfo.isHidden = true
            setInfo.isArchive = true
            setInfo.notContentIndexed = true 
#else
            setInfo.posixPermissions = (1 << 9) - 1
#endif
            
            try await manager.setInfo(setInfo, forItemAt: path)

            let newInfo = try await manager.infoOfItem(at: path)
            
            #expect(newInfo == setInfo)
            
        }
        
    }
    
    
    @Test("Set: file exist / type: symbolic link")
    func setFileInfo3() async throws {
        
        try await withSymbolicLinkAtPath { paths, _ in

            let path = paths.first!
            
            var setInfo = try await manager.infoOfItem(at: path)
            setInfo.creationDate = .now.addingTimeInterval(-10)
            setInfo.lastAccessDate = .now.addingTimeInterval(-5)
            setInfo.modificationDate = .now.addingTimeInterval(-7)
#if os(Windows)
            setInfo.isHidden = true
            setInfo.isArchive = true
            setInfo.notContentIndexed = true 
#else
            setInfo.posixPermissions = (1 << 9) - 1
#endif
            
            try await manager.setInfo(setInfo, forItemAt: path)

            let newInfo = try await manager.infoOfItem(at: path)
            
            #expect(newInfo == setInfo)
            
        }
        
    }
    
    
    @Test("Set: file not exist")
    func setFileInfo4() async throws {
        
        let path = makeTestingFilePath()
        
        var setInfo = FileManager.FileInfo()
        setInfo.creationDate = .now.addingTimeInterval(-10)
        setInfo.lastAccessDate = .now.addingTimeInterval(-5)
        setInfo.modificationDate = .now.addingTimeInterval(-7)
#if os(Windows)
            setInfo.isHidden = true
            setInfo.isArchive = true
            setInfo.notContentIndexed = true 
#else
            setInfo.posixPermissions = (1 << 9) - 1
#endif
        
        await #expect(throws: Error.self) {
            try await manager.setInfo(setInfo, forItemAt: path)
        }
        
    }
    
}
