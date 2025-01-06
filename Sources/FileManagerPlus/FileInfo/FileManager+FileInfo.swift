//
//  FileInfo.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/7/29.
//

import Foundation
import SystemPackage
import FoundationPlusEssential
#if os(Windows)
import WinSDK
#endif


extension FileManager {
    
    /// A type holding common attributes of a file
    ///
    /// It contains only a subset of [`URLResourceValues`] and it will not record which attributes
    /// are modified
    ///
    /// - Note: Whenever possible, use this instead of `FileAttributes` or
    /// `[FileAttributeKey: Any]`
    ///
    /// [`URLResourceValues`]: https://developer.apple.com/documentation/foundation/urlresourcevalues
    public struct FileInfo: Sendable {
        
        /// The path of the file
        public let path: FilePath
        /// size of the file in bytes
        public let size: Int64
#if os(Windows)
        /// The date the file was created
        public private(set) var creationDate: FileManager.FileTimeStamp?
#else
        /// The date the file was created
        public let creationDate: FileManager.FileTimeStamp?
#endif
        /// The date the file was last accessed
        public var lastAccessDate: FileManager.FileTimeStamp
        /// The time the content was last modified
        public var modificationDate: FileManager.FileTimeStamp
        /// The file system object type as [`FileAttributeType`]
        ///
        /// - seealso: [`FileAttributeType`]
        ///
        /// [`FileAttributeType`]: https://developer.apple.com/documentation/foundation/fileattributetype
        public let type: FileAttributeType

        private(set) var originalLastAccessDate: FileManager.FileTimeStamp
        private(set) var originalModificationDate: FileManager.FileTimeStamp
        var lastAccessDateChanged: Bool { lastAccessDate != originalLastAccessDate }
        var modificationDateChanged: Bool { modificationDate != originalModificationDate }

        public var fileFlags: PlatformFileFlags
        private var originalFileFlags: PlatformFileFlags
        var fileFlagsChanged: Bool { fileFlags != originalFileFlags }

        public var name: String { path.lastComponent?.string ?? "" }
        public var isRegularFile: Bool { type == .typeRegular }
        public var isDirectory: Bool { type == .typeDirectory }
        public var isSymbolicLink: Bool { type == .typeSymbolicLink }

#if os(Windows)
        private(set) var originalCreationDate: FileManager.FileTimeStamp
        var creationDateChanged: Bool { creationDate != originalCreationDate }
        public let sid: String
        public let isExecutable: Bool 
        public var posixPermissionBits: UInt16 {
            var poxisPermissions = UInt16(_S_IREAD)
            if !fileFlags.isReadOnly {
                poxisPermissions |= UInt16(_S_IWRITE)
            }
            if isExecutable || type == .typeDirectory {
                poxisPermissions |= UInt16(_S_IEXEC)
            }
            return poxisPermissions
        }
        public var posixPermissions: FileManager.PosixPermission { .init(bits: posixPermissionBits) }
#else
        /// file’s owner UID
        public let ownerUID: UInt32
        /// file’s group owner GID
        public let ownerGID: UInt32
        public let typeBits: UInt16
        public var posixPermissions: FileManager.PosixPermission
        public var posixPermissionBits: UInt16 { 
            get { posixPermissions.bits }
            set { posixPermissions = .init(bits: newValue) }
        }
        private(set) var originalFileMode: mode_t
        /// file’s POSIX mode
        public var fileMode: mode_t { .init(typeBits | posixPermissionBits) }
        var fileModeChanged: Bool { fileMode != originalFileMode }
#endif
        

#if os(Windows) 
        public init(
            path: FilePath = "",
            size: Int64 = 0,
            creationDate: FileManager.FileTimeStamp? = .now,
            lastAccessDate: FileManager.FileTimeStamp = .now,
            modificationDate: FileManager.FileTimeStamp = .now,
            sid: String = "",
            fileFlags: FileManager.PlatformFileFlags = 0,
            type: FileAttributeType = .typeUnknown,
            isExecutable: Bool = false
        ) {
            self.path = path
            self.size = size
            self.creationDate = creationDate
            self.lastAccessDate = lastAccessDate
            self.modificationDate = modificationDate
            self.sid = sid
            self.fileFlags = fileFlags
            self.type = type
            self.isExecutable = isExecutable
            self.originalFileFlags = fileFlags
            self.originalCreationDate = creationDate ?? .now
            self.originalLastAccessDate = lastAccessDate
            self.originalModificationDate = modificationDate
        }
#elseif canImport(Darwin)
        public init(
            path: FilePath = "",
            size: Int64 = 0,
            creationDate: FileManager.FileTimeStamp? = .now,
            lastAccessDate: FileManager.FileTimeStamp = .now,
            modificationDate: FileManager.FileTimeStamp = .now,
            ownerUID: UInt32 = 0,
            ownerGID: UInt32 = 0,
            fileMode: mode_t = 0,
            fileFlags: PlatformFileFlags = 0
        ) {
            self.path = path
            self.size = size
            self.creationDate = creationDate
            self.lastAccessDate = lastAccessDate
            self.modificationDate = modificationDate
            self.ownerUID = ownerUID
            self.ownerGID = ownerGID
            self.posixPermissions = .init(bits: fileMode)
            self.type = fileMode.fileType
            self.originalFileMode = fileMode
            self.typeBits = fileMode & S_IFMT
            self.fileFlags = fileFlags
            self.originalLastAccessDate = lastAccessDate
            self.originalModificationDate = modificationDate
            self.originalFileFlags = fileFlags
        }
#else
        public init(
            path: FilePath = "",
            size: Int64 = 0,
            creationDate: FileManager.FileTimeStamp? = nil,
            lastAccessDate: FileManager.FileTimeStamp = .now,
            modificationDate: FileManager.FileTimeStamp = .now,
            ownerUID: UInt32 = 0,
            ownerGID: UInt32 = 0,
            fileMode: mode_t = 0,
            fileFlags: PlatformFileFlags = 0
        ) {
            self.path = path
            self.size = size
            self.creationDate = creationDate
            self.lastAccessDate = lastAccessDate
            self.modificationDate = modificationDate
            self.ownerUID = ownerUID
            self.ownerGID = ownerGID
            self.posixPermissions = .init(bits: .init(clamping: fileMode))
            self.type = fileMode.fileType
            self.fileFlags = fileFlags
            self.originalFileMode = fileMode
            self.typeBits = .init(clamping: fileMode & S_IFMT)
            self.originalLastAccessDate = lastAccessDate
            self.originalModificationDate = modificationDate
            self.originalFileFlags = fileFlags
        }
#endif


#if !os(Windows)
        @available(*, unavailable, message: "Only support changing creation date on Windows")
#endif
        public mutating func setCreationDate(_ date: FileManager.FileTimeStamp) {
            #if os(Windows)
            self.creationDate = date
            #endif
        }
        
    }
    
}



extension FileManager.FileInfo: Equatable, Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(path)
        hasher.combine(size)
        hasher.combine(creationDate)
        hasher.combine(lastAccessDate)
        hasher.combine(modificationDate)
        hasher.combine(type)
#if os(Windows)
        hasher.combine(sid)
        hasher.combine(fileFlags)
        hasher.combine(isExecutable)
#else
        hasher.combine(ownerUID)
        hasher.combine(ownerGID)
        hasher.combine(posixPermissions)
        hasher.combine(fileFlags)
#endif
    }


    public static func == (lhs: Self, rhs: Self) -> Bool {
        var result = lhs.path == rhs.path
            && lhs.size == rhs.size
            && lhs.creationDate == rhs.creationDate
            && lhs.lastAccessDate == rhs.lastAccessDate
            && lhs.modificationDate == rhs.modificationDate
            && lhs.type == rhs.type 
#if os(Windows)
        result = result && lhs.sid == rhs.sid
            && lhs.fileFlags == rhs.fileFlags
            && lhs.isExecutable == rhs.isExecutable
#else
        result = result && lhs.ownerUID == rhs.ownerUID
            && lhs.ownerGID == rhs.ownerGID
            && lhs.posixPermissions == rhs.posixPermissions
            && lhs.fileFlags == rhs.fileFlags
#endif
        return result
    }

}



#if os(Windows)
extension FileManager.FileInfo {

    public func loadACL() throws -> [AccessPermissionACE]? {

        try WindowsFileUtils.interceptWindowsErrorAsCocorError(path: path, reading: true) {

            try WindowsFileUtils.withSecurityDescriptor(ofItemAt: path) { securityDescriptor in

                try WindowsFileUtils.getACL(from: securityDescriptor)?.compactMap { type, ace in 

                    switch type {
                        case ACCESS_ALLOWED_ACE_TYPE:
                            try AccessPermissionACE(ace.assumingMemoryBound(to: ACCESS_ALLOWED_ACE.self))
                        case ACCESS_DENIED_ACE_TYPE:
                            try AccessPermissionACE(ace.assumingMemoryBound(to: ACCESS_DENIED_ACE.self))
                        default: nil
                    }

                }

            }

        }

    }


    public func loadACL() async throws -> [AccessPermissionACE]? {
        try await FileManager.runOnIOQueue {
            try self.loadACL()
        }
    }

}
#endif


#if os(Windows)
extension FileManager.FileInfo {

    public struct AccessPermissionACE: Sendable, Equatable, Hashable {
        public let sid: String
        public let mask: DWORD
        public let type: AccessPermissionACEType
        public init(sid: String, mask: DWORD, type: AccessPermissionACEType) {
            self.sid = sid
            self.mask = mask
            self.type = type
        }
        public init(_ ace: UnsafePointer<ACCESS_ALLOWED_ACE>) throws(WindowsError) {
            var sidString: LPWSTR? = nil
            let sidPtr = PSID(mutating: ace).advanced(by: MemoryLayout<ACCESS_ALLOWED_ACE>.offset(of: \.SidStart)!)
            guard ConvertSidToStringSidW(sidPtr, &sidString), let sidString else {
                throw WindowsError.fromLastError()
            }
            self.sid = String(decodingCString: sidString, as: UTF16.self)
            self.mask = ace.pointee.Mask
            self.type = .init(ace.pointee.Header.AceType)
        }
        public init(_ ace: UnsafePointer<ACCESS_DENIED_ACE>) throws(WindowsError) {
            var sidString: LPWSTR? = nil
            let sidPtr = PSID(mutating: ace).advanced(by: MemoryLayout<ACCESS_DENIED_ACE>.offset(of: \.SidStart)!)
            guard ConvertSidToStringSidW(sidPtr, &sidString), let sidString else {
                throw WindowsError.fromLastError()
            }
            self.sid = String(decodingCString: sidString, as: UTF16.self)
            self.mask = ace.pointee.Mask
            self.type = .init(ace.pointee.Header.AceType)
        }
    }

    public struct AccessPermissionACEType: Sendable, Equatable, Hashable {
        public let rawValue: DWORD
        public init(_ rawValue: DWORD) {
            self.rawValue = rawValue
        }
        public init(_ rawValue: Int32) {
            self.rawValue = .init(rawValue)
        }
        public init(_ rawValue: BYTE) {
            self.rawValue = .init(rawValue)
        }
        public static let allow: AccessPermissionACEType = .init(ACCESS_ALLOWED_ACE_TYPE)
        public static let deny: AccessPermissionACEType = .init(ACCESS_DENIED_ACE_TYPE)
    }

}
#endif
