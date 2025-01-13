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
    /// - Note: Whenever possible, use this instead of `FileAttributes` or
    /// `[FileAttributeKey: Any]`
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

        /// Additional platform-specific file flags
        public var fileFlags: PlatformFileFlags
        private var originalFileFlags: PlatformFileFlags
        var fileFlagsChanged: Bool { fileFlags != originalFileFlags }

        /// The name of the file, if it is the root directory, it will be an empty string
        public var name: String { path.lastComponent?.string ?? "" }
        /// Whether the file is a regular file
        public var isRegularFile: Bool { type == .typeRegular }
        /// Whether the file is a directory
        public var isDirectory: Bool { type == .typeDirectory }
        /// Whether the file is a symbolic link
        public var isSymbolicLink: Bool { type == .typeSymbolicLink }

#if os(Windows)
        private(set) var originalCreationDate: FileManager.FileTimeStamp
        var creationDateChanged: Bool { creationDate != originalCreationDate }
        /// The security identifier of the owner of the file
        /// - Attention: Windows only
        public let sid: String
        /// Whether the file is executable
        /// - Attention: Windows only
        public let isExecutable: Bool
        /// Bits representing the POSIX permission of the file
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
        /// The POSIX permission of the file
        public var posixPermissions: FileManager.PosixPermission { .init(bits: posixPermissionBits) }
#else
        /// File’s owner UID
        /// - Attention: Not available on Windows
        public let ownerUID: UInt32
        /// File’s group owner GID
        /// - Attention: Not available on Windows
        public let ownerGID: UInt32
        /// Bits representing the file type
        /// - Attention: Not available on Windows
        public let typeBits: UInt16
        /// The POSIX permission of the file
        public var posixPermissions: FileManager.PosixPermission
        /// Bits representing the POSIX permission of the file
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


        /// Update the creation date of the file
        /// - Attention: Windows only
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

    /// Load the ACL of the file
    /// - Returns: An array of ACE if the file has an ACL, otherwise `nil`
    /// - Attention: Windows only
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


    /// Load the ACL of the file
    /// - Returns: An array of ACE if the file has an ACL, otherwise `nil`
    /// - Attention: Windows only
    public func loadACL() async throws -> [AccessPermissionACE]? {
        try await FileManager.runOnIOQueue {
            try self.loadACL()
        }
    }

}
#endif


#if os(Windows)
extension FileManager.FileInfo {

    /// A type representing an access control entry (ACE), 
    /// which are the elements in an access control list (ACL)
    public struct AccessPermissionACE: Sendable, Equatable, Hashable {
        /// The security identifier of a user or a group
        public let sid: String
        /// The access permission mask of the ACE
        public let mask: DWORD
        /// The type of the ACE
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

    /// A type representing the type of an ``ACE``
    /// 
    /// Two pre-defined types are `allow` and `deny`
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
