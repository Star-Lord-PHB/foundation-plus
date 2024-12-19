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
        /// The date the file was created
        public var creationDate: Date
        /// The date the file was last accessed
        public var lastAccessDate: Date
        /// The time the content was last modified
        public var modificationDate: Date
        /// The file system object type as [`FileAttributeType`]
        ///
        /// - seealso: [`FileAttributeType`]
        ///
        /// [`FileAttributeType`]: https://developer.apple.com/documentation/foundation/fileattributetype
        public let type: FileAttributeType

#if os(Windows)
        public let sid: String
        public internal(set) var fileAttributes: DWORD
        public let isExecutable: Bool 
        public var posixPermissionBits: UInt16 {
            var poxisPermissions = UInt16(_S_IREAD)
            if fileAttributes & DWORD(FILE_ATTRIBUTE_READONLY) == 0 {
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
        public var posixPermissions: FileManager.PosixPermission
        public var posixPermissionBits: UInt16 { 
            get { posixPermissions.bits }
            set { posixPermissions = .init(bits: newValue) }
        }
        public let isImmutable: Bool 
        /// file’s POSIX mode
        public var fileMode: UInt16 {
            TODO()
        }
#endif
        public var name: String { path.lastComponent?.string ?? "" }
        public var isRegularFile: Bool { type == .typeRegular }
        public var isDirectory: Bool { type == .typeDirectory }
        public var isSymbolicLink: Bool { type == .typeSymbolicLink }
        

#if os(Windows) 
        public init(
            path: FilePath = "",
            size: Int64 = 0,
            creationDate: Date = .now,
            lastAccessDate: Date = .now,
            modificationDate: Date = .now,
            sid: String = "",
            fileAttributes: DWORD = 0,
            type: FileAttributeType = .typeUnknown,
            isExecutable: Bool = false
        ) {
            self.path = path
            self.size = size
            self.creationDate = creationDate
            self.lastAccessDate = lastAccessDate
            self.modificationDate = modificationDate
            self.sid = sid
            self.fileAttributes = fileAttributes
            self.type = type
            self.isExecutable = isExecutable
        }
#else 
        public init(
            path: FilePath = "",
            size: Int64 = 0,
            creationDate: Date = .now,
            lastAccessDate: Date = .now,
            modificationDate: Date = .now,
            ownerUID: UInt32 = 0,
            ownerGID: UInt32 = 0,
            poxisPermissions: FileManager.PosixPermission = 0,
            fileResourceType: FileAttributeType = .typeUnknown,
            isImmutable: Bool = false
        ) {
            self.path = path
            self.size = size
            self.creationDate = creationDate
            self.lastAccessDate = lastAccessDate
            self.modificationDate = modificationDate
            self.ownerUID = ownerUID
            self.ownerGID = ownerGID
            self.posixPermissions = poxisPermissions
            self.type = fileResourceType
            self.isImmutable = isImmutable
        }
#endif
        
    }
    
}


extension FileManager.FileInfo: Equatable, Hashable {}


extension FileManager.FileInfo {
    
    /// Create a `FileInfo` instance by fetching the attributes from the file
    /// located at the provided `path`
    public init(path: FilePath) throws {
        let attributes = try FileManager.default.attributesOfItem(atPath: path.string)
        var fileStat = stat()
        guard stat(path.string, &fileStat) == 0 else {
            throw CocoaError.fileError(.init(rawValue: errno.intVal), path: path)
        }
#if os(Windows)
        let (infoByHandle, type) = try WindowsFileUtils.interceptWindowsErrorAsCocorError(path: path, reading: true) {
            try WindowsFileUtils.withFileHandle(
                ofItemAt: path, 
                accessMode: .genericRead, 
                shareMode: .shareRead | .shareWrite | .shareDelete, 
                createMode: .openExisting,
                flagsAndAttributes: .fileFlags.backupSemantics | .fileFlags.openReparsePoint
            ) { handle in
                let infoByHandle = try WindowsFileUtils.getFileInformation(from: handle)
                let type = GetFileType(handle)
                let isReparsePoint = Int32(infoByHandle.dwFileAttributes) & FILE_ATTRIBUTE_REPARSE_POINT != 0
                var isSymbolicLink: Bool {
                    var tagInfo = FILE_ATTRIBUTE_TAG_INFO()
                    guard GetFileInformationByHandleEx(handle, FileAttributeTagInfo, &tagInfo, DWORD(MemoryLayout<FILE_ATTRIBUTE_TAG_INFO>.size)) else {
                        return false
                    }
                    return Int32(tagInfo.FileAttributes) & FILE_ATTRIBUTE_REPARSE_POINT != 0
                }
                let fileAttributeType = switch Int32(type) {
                    case _ where isReparsePoint && isSymbolicLink: .typeSymbolicLink
                    case FILE_TYPE_CHAR: .typeCharacterSpecial
                    case FILE_TYPE_DISK where (Int32(infoByHandle.dwFileAttributes) & FILE_ATTRIBUTE_DIRECTORY != 0): .typeDirectory
                    case FILE_TYPE_DISK: .typeRegular
                    case FILE_TYPE_PIPE: .typeSocket
                    case FILE_TYPE_UNKNOWN: .typeUnknown
                    default: .typeUnknown
                } as FileAttributeType
                return (infoByHandle, fileAttributeType)
            }
        }
        let ownerSid = try WindowsFileUtils.interceptWindowsErrorAsCocorError(path: path, reading: true) {
            try WindowsFileUtils.withSecurityDescriptor(ofItemAt: path) { securityDescriptor in
                try WindowsFileUtils.getOwnerSid(from: securityDescriptor)
            }
        }
        self.init(
            path: path,
            size: Int64(infoByHandle.nFileSizeHigh) << 32 | Int64(infoByHandle.nFileSizeLow),
            creationDate: infoByHandle.ftCreationTime.date,
            lastAccessDate: infoByHandle.ftLastAccessTime.date,
            modificationDate: infoByHandle.ftLastWriteTime.date,
            sid: ownerSid,
            fileAttributes: infoByHandle.dwFileAttributes,
            type: type,
            isExecutable: SaferiIsExecutableFileType(path.toLpwstr(), 0)
        )
#else
        let timeInterval = TimeInterval(fileStat.st_atimespec.tv_sec) + TimeInterval(fileStat.st_atimespec.tv_nsec) / 1_000_000_000
        let lastAccessDate = Date(timeIntervalSince1970: timeInterval)
        self.init(
            name: path.lastComponent?.string ?? "",
            size: attributes[.size] as? Int ?? 0,
            creationDate: attributes[.creationDate] as? Date,
            lastAccessDate: lastAccessDate,
            modificationDate: attributes[.modificationDate] as? Date,
            ownerUID: fileStat.st_uid,
            ownerGID: fileStat.st_gid,
            fileMode: fileStat.st_mode,
            fileResourceType: attributes[.type] as? FileAttributeType ?? .typeUnknown,
            isImmutable: attributes[.immutable] as? Bool ?? false
        )
#endif
    }


    public init(url: URL) throws {
        try self.init(path: url.assertAsFilePath())
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
