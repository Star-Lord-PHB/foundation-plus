//
//  FileInfoTest.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/8/11.
//

import Testing
@testable import FoundationPlus
#if os(Windows)
import WinSDK
#endif


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
            
            #expect(fileManagerAttributes[.creationDate] as? Date == info.creationDate)

#if os(Windows)
            // The url ResourceValues only support precision to seconds on Windows
            let lastAccessDateToSeconds = Calendar.current.dateInterval(of: .second, for: info.lastAccessDate)?.start
            try #expect(url.resourceValues(forKeys: [.contentAccessDateKey]).contentAccessDate == lastAccessDateToSeconds)
#else
            try #expect(url.resourceValues(forKeys: [.contentAccessDateKey]).contentAccessDate == info.lastAccessDate)
#endif

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
            
            #expect(fileManagerAttributes[.creationDate] as? Date == info.creationDate)
            
#if os(Windows)
            // The url ResourceValues only support precision to seconds on Windows
            let lastAccessDateToSeconds = Calendar.current.dateInterval(of: .second, for: info.lastAccessDate)?.start
            try #expect(url.resourceValues(forKeys: [.contentAccessDateKey]).contentAccessDate == lastAccessDateToSeconds)
#else
            try #expect(url.resourceValues(forKeys: [.contentAccessDateKey]).contentAccessDate == info.lastAccessDate)
#endif

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
            
            #expect(fileManagerAttributes[.creationDate] as? Date == info.creationDate)
            
#if os(Windows)
            // The url ResourceValues only support precision to seconds on Windows
            let lastAccessDateToSeconds = Calendar.current.dateInterval(of: .second, for: info.lastAccessDate)?.start
            try #expect(url.resourceValues(forKeys: [.contentAccessDateKey]).contentAccessDate == lastAccessDateToSeconds)
#else
            try #expect(url.resourceValues(forKeys: [.contentAccessDateKey]).contentAccessDate == info.lastAccessDate)
#endif

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
// #if os(Windows)
//             setInfo.setCreationDate(.now.addingTimeInterval(-10))
// #endif
//             setInfo.lastAccessDate = .now.addingTimeInterval(-5)
//             setInfo.modificationDate = .now.addingTimeInterval(-7)
#if os(Windows)
            setInfo.fileFlags.isHidden = true
            setInfo.fileFlags.isArchive = true
            setInfo.fileFlags.notContentIndexed = true 
#else
            setInfo.posixPermissions = .userReadWriteExecute
            setInfo.fileFlags.isHidden = true
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
// #if os(Windows)
//             setInfo.setCreationDate(.now.addingTimeInterval(-10))
// #endif
//             setInfo.lastAccessDate = .now.addingTimeInterval(-5)
//             setInfo.modificationDate = .now.addingTimeInterval(-7)
#if os(Windows)
            setInfo.fileFlags.isHidden = true
            setInfo.fileFlags.isArchive = true
            setInfo.fileFlags.notContentIndexed = true 
#else
            setInfo.posixPermissions = .userReadWriteExecute
            setInfo.fileFlags.isHidden = true
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
// #if os(Windows)
//             setInfo.setCreationDate(.now.addingTimeInterval(-10))
// #endif
//             setInfo.lastAccessDate = .now.addingTimeInterval(-5)
//             setInfo.modificationDate = .now.addingTimeInterval(-7)
#if os(Windows)
            setInfo.fileFlags.isHidden = true
            setInfo.fileFlags.isArchive = true
            setInfo.fileFlags.notContentIndexed = true 
#else
            setInfo.posixPermissions = .userReadWriteExecute
            setInfo.fileFlags.isHidden = true
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
// #if os(Windows)
//         setInfo.setCreationDate(.now.addingTimeInterval(-10))
// #endif
//         setInfo.lastAccessDate = .now.addingTimeInterval(-5)
//         setInfo.modificationDate = .now.addingTimeInterval(-7)
#if os(Windows)
            setInfo.fileFlags.isHidden = true
            setInfo.fileFlags.isArchive = true
            setInfo.fileFlags.notContentIndexed = true 
#else
            setInfo.posixPermissions = .userReadWriteExecute
            setInfo.fileFlags.isHidden = true
#endif
        
        await #expect(throws: Error.self) {
            try await manager.setInfo(setInfo, forItemAt: path)
        }
        
    }
    
}
