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
            
            // The resourceValues API causes atime to change, so call it at the beginning
            let expectedLastAccessDate = try URL(filePath: path.string).resourceValues(forKeys: [.contentAccessDateKey]).contentAccessDate
            let info = try await manager.infoOfItem(at: path)
            let fileManagerAttributes = try manager.attributesOfItem(atPath: path.string)
            
#if os(Linux)
            // on Linux, the creation date from file manager attributes use ctime instead of btime, which sometimes differ a little bit
            let creationDate = info.creationDate?.date
            let expectedCreationDate = fileManagerAttributes[.creationDate] as? Date
            if let creationDate, let expectedCreationDate {
                #expect(creationDate.approximateEqual(to: expectedCreationDate, within: 0.1))
            } else {
                #expect(creationDate == expectedCreationDate)
            }
#else
            #expect((fileManagerAttributes[.creationDate] as? Date).approximateEqual(to: info.creationDate?.date))
#endif

#if os(Windows)
            // The url ResourceValues only support precision to seconds on Windows
            let lastAccessDateToSeconds = Calendar.current.dateInterval(of: .second, for: info.lastAccessDate.date)?.start
            #expect(expectedLastAccessDate == lastAccessDateToSeconds)
#else
            #expect(expectedLastAccessDate.approximateEqual(to: info.lastAccessDate.date))
#endif

            #expect((fileManagerAttributes[.modificationDate] as? Date).approximateEqual(to: info.modificationDate.date))

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
            
            // The resourceValues API causes atime to change, so call it at the beginning
            let expectedLastAccessDate = try URL(filePath: path.string).resourceValues(forKeys: [.contentAccessDateKey]).contentAccessDate
            let info = try await manager.infoOfItem(at: path)
            let fileManagerAttributes = try manager.attributesOfItem(atPath: path.string)
            
#if os(Linux)
            // on Linux, the creation date from file manager attributes use ctime instead of btime, which sometimes differ a little bit
            let creationDate = info.creationDate?.date
            let expectedCreationDate = fileManagerAttributes[.creationDate] as? Date
            if let creationDate, let expectedCreationDate {
                #expect(creationDate.approximateEqual(to: expectedCreationDate, within: 0.1))
            } else {
                #expect(creationDate == expectedCreationDate)
            }
#else
            #expect((fileManagerAttributes[.creationDate] as? Date).approximateEqual(to: info.creationDate?.date))
#endif

#if os(Windows)
            // The url ResourceValues only support precision to seconds on Windows
            let lastAccessDateToSeconds = Calendar.current.dateInterval(of: .second, for: info.lastAccessDate.date)?.start
            #expect(expectedLastAccessDate == lastAccessDateToSeconds)
#else
            #expect(expectedLastAccessDate.approximateEqual(to: info.lastAccessDate.date))
#endif

            #expect((fileManagerAttributes[.modificationDate] as? Date).approximateEqual(to: info.modificationDate.date))

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
            // The resourceValues API causes atime to change, so call it at the beginning
            let expectedLastAccessDate = try URL(filePath: path.string).resourceValues(forKeys: [.contentAccessDateKey]).contentAccessDate
            
            let info = try await manager.infoOfItem(at: path)
            let fileManagerAttributes = try manager.attributesOfItem(atPath: path.string)
            
#if os(Linux)
            // on Linux, the creation date from file manager attributes use ctime instead of btime, which sometimes differ a little bit
            let creationDate = info.creationDate?.date
            let expectedCreationDate = fileManagerAttributes[.creationDate] as? Date
            if let creationDate, let expectedCreationDate {
                #expect(creationDate.approximateEqual(to: expectedCreationDate, within: 0.1))
            } else {
                #expect(creationDate == expectedCreationDate)
            }
#else
            #expect((fileManagerAttributes[.creationDate] as? Date).approximateEqual(to: info.creationDate?.date))
#endif

#if os(Windows)
            // The url ResourceValues only support precision to seconds on Windows
            let lastAccessDateToSeconds = Calendar.current.dateInterval(of: .second, for: info.lastAccessDate.date)?.start
            #expect(expectedLastAccessDate == lastAccessDateToSeconds)
#else
            #expect(expectedLastAccessDate.approximateEqual(to: info.lastAccessDate.date))
#endif

            #expect((fileManagerAttributes[.modificationDate] as? Date).approximateEqual(to: info.modificationDate.date))
            
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
#if os(Windows)
            setInfo.setCreationDate(.now.adding(seconds: -10, nanoseconds: 0))
#endif
            setInfo.lastAccessDate = (setInfo.creationDate ?? .now).adding(seconds: 120, nanoseconds: 0)
            setInfo.modificationDate = (setInfo.creationDate ?? .now).adding(seconds: 60, nanoseconds: 0)
#if os(Windows)
            setInfo.fileFlags.isHidden = true
            setInfo.fileFlags.isArchive = true
            setInfo.fileFlags.notContentIndexed = true 
#elseif canImport(Darwin)
            setInfo.posixPermissions = .userReadWriteExecute
            setInfo.fileFlags.isHidden = true
#else
            setInfo.posixPermissions = .userReadWriteExecute
            setInfo.fileFlags.secureRemove = true
#endif

            try await manager.setInfo(setInfo, forItemAt: path)

            let newInfo = try await manager.infoOfItem(at: path)
            
            #expect(newInfo == setInfo)
            print(newInfo.creationDate == setInfo.creationDate)
            
        }
        
    }
    
    
    @Test("Set: file exist / type: directory")
    func setFileInfo2() async throws {
        
        try await withDirectoryAtPath { path in
            
            var setInfo = try await manager.infoOfItem(at: path)
#if os(Windows)
            setInfo.setCreationDate(.now.adding(seconds: -10, nanoseconds: 0))
#endif
            setInfo.lastAccessDate = (setInfo.creationDate ?? .now).adding(seconds: 120, nanoseconds: 0)
            setInfo.modificationDate = (setInfo.creationDate ?? .now).adding(seconds: 60, nanoseconds: 0)
#if os(Windows)
            setInfo.fileFlags.isHidden = true
            setInfo.fileFlags.isArchive = true
            setInfo.fileFlags.notContentIndexed = true 
#elseif canImport(Darwin)
            setInfo.posixPermissions = .userReadWriteExecute
            setInfo.fileFlags.isHidden = true
#else
            setInfo.posixPermissions = .userReadWriteExecute
            setInfo.fileFlags.isCompressed = true
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
#if os(Windows)
            setInfo.setCreationDate(.now.adding(seconds: -10, nanoseconds: 0))
#endif
            setInfo.lastAccessDate = (setInfo.creationDate ?? .now).adding(seconds: 120, nanoseconds: 0)
            setInfo.modificationDate = (setInfo.creationDate ?? .now).adding(seconds: 60, nanoseconds: 0)
#if os(Windows)
            setInfo.fileFlags.isHidden = true
            setInfo.fileFlags.isArchive = true
            setInfo.fileFlags.notContentIndexed = true 
#elseif canImport(Darwin)
            setInfo.posixPermissions = .userReadWriteExecute
            setInfo.fileFlags.isHidden = true
#endif 
            
            try await manager.setInfo(setInfo, forItemAt: path)

            let newInfo = try await manager.infoOfItem(at: path)
            
            #expect(newInfo == setInfo)
            
        }
        
    }


#if canImport(Glibc)
    @Test("Set (Linux): file exist / type: symbolic link / set fileflags")
    func setFileInfo4() async throws {
        
        try await withSymbolicLinkAtPath { paths, _ in
            
            let path = paths.first!

            var setInfo = try await manager.infoOfItem(at: path)
            setInfo.fileFlags.isCompressed = true

            await #expect("Linux does not support setting file mode for symbolic link") {
                try await manager.setInfo(setInfo, forItemAt: path)
            } throws: { error in
                ((error as? CocoaError)?.underlying as? POSIXError)?.code == .EOPNOTSUPP
            }

        }

    }


    @Test("Set (Linux): file exist / type: symbolic link / set filemode")
    func setFileInfo5() async throws {
        
        try await withSymbolicLinkAtPath { paths, _ in
            
            let path = paths.first!

            var setInfo = try await manager.infoOfItem(at: path)
            setInfo.posixPermissions = .userReadWrite

            await #expect("Linux does not support setting file mode for symbolic link") {
                try await manager.setInfo(setInfo, forItemAt: path)
            } throws: { error in
                ((error as? CocoaError)?.underlying as? POSIXError)?.code == .EOPNOTSUPP
            }

        }

    }
#endif
    
    
    @Test("Set: file not exist")
    func setFileInfo6() async throws {
        
        let path = makeTestingFilePath()
        
        var setInfo = FileManager.FileInfo()

#if os(Windows)
        setInfo.setCreationDate(.now.adding(seconds: -10, nanoseconds: 0))
#endif
        setInfo.lastAccessDate = (setInfo.creationDate ?? .now).adding(seconds: 120, nanoseconds: 0)
        setInfo.modificationDate = (setInfo.creationDate ?? .now).adding(seconds: 60, nanoseconds: 0)

#if os(Windows)
        setInfo.fileFlags.isHidden = true
        setInfo.fileFlags.isArchive = true
        setInfo.fileFlags.notContentIndexed = true 
#elseif canImport(Darwin)
        setInfo.posixPermissions = .userReadWriteExecute
        setInfo.fileFlags.isHidden = true
#else
        setInfo.posixPermissions = .userReadWriteExecute
        setInfo.fileFlags.isCompressed = true
#endif
        
        await #expect(throws: Error.self) {
            try await manager.setInfo(setInfo, forItemAt: path)
        }
        
    }
    
}
