import Foundation
import SystemPackage
import FoundationPlusEssential
#if os(Windows)
import WinSDK
#endif
#if os(Linux)
import GlibcInterop
#endif


extension FileManager.FileInfo {
    
    /// Create a `FileInfo` instance by fetching the attributes from the file
    /// located at the provided path
    public init(path: FilePath) throws {

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
            creationDate: infoByHandle.ftCreationTime.fileTimeStamp,
            lastAccessDate: infoByHandle.ftLastAccessTime.fileTimeStamp,
            modificationDate: infoByHandle.ftLastWriteTime.fileTimeStamp,
            sid: ownerSid,
            fileFlags: .init(bits: infoByHandle.dwFileAttributes),
            type: type,
            isExecutable: SaferiIsExecutableFileType(path.toLpwstr(), 0)
        )

#else

#if canImport(Darwin)

        var fileStat = stat()
        guard lstat(path.string, &fileStat) == 0 else {
            throw CocoaError.lastPosixError(path: path, reading: true)
        }

        self.init(
            path: path, 
            size: fileStat.st_size, 
            creationDate: fileStat.st_birthtimespec.fileTimeStamp, 
            lastAccessDate: fileStat.st_atimespec.fileTimeStamp, 
            modificationDate: fileStat.st_mtimespec.fileTimeStamp, 
            ownerUID: fileStat.st_uid, 
            ownerGID: fileStat.st_gid, 
            fileMode: fileStat.st_mode, 
            fileFlags: .init(bits: fileStat.st_flags)
        )

#else   

        var fileStat = statx()
        guard stat_compat(path.string, &fileStat) == 0 else {
            throw CocoaError.lastPosixError(path: path, reading: true)
        }

        // symbolic link on linux does not support file flags
        var flags = 0 as UInt32
        if fileStat.stx_mode & .init(clamping: Glibc.S_IFMT) != Glibc.S_IFLNK {
            let fd = openat(AT_FDCWD, path.string, O_RDONLY)
            guard fd >= 0 else {
                throw CocoaError.lastPosixError(path: path, reading: true)
            }
            defer { close(fd) }
            guard fgetFileFlags(fd, &flags) == 0 || errno == ENOSYS else {
                throw CocoaError.lastPosixError(path: path, reading: true)
            }
        }

        self.init(
            path: path,
            size: .init(fileStat.stx_size),
            creationDate: SUPPORT_BIRTHTIME ? fileStat.stx_btime.fileTimeStamp : nil,
            lastAccessDate: fileStat.stx_atime.fileTimeStamp,
            modificationDate: fileStat.stx_mtime.fileTimeStamp,
            ownerUID: fileStat.stx_uid,
            ownerGID: fileStat.stx_gid,
            fileMode: .init(fileStat.stx_mode),
            fileFlags: .init(bits: flags)
        )

#endif

#endif

    }


    /// Create a `FileInfo` instance by fetching the attributes from the file
    /// located at the provided url
    public init(url: URL) throws {
        try self.init(path: url.assertAsFilePath())
    }
    
}



extension FileManager {

    /// Get a ``FileInfo`` instance holding the information of the item at the specified path
    /// - Parameters:
    ///   - path: The path to the item
    ///   - resolveSymbolicLink: Whether to (recursively) resolve the symbolic link to find the destination
    public func infoOfItem(at path: FilePath, resolveSymbolicLink: Bool = false) throws -> FileInfo {
        if resolveSymbolicLink {
            let destPath = try self.destinationOfSymbolicLink(at: path, recursive: true)
            return try .init(path: destPath)
        } else {
            return try .init(path: path)
        }
    }


    /// Get a ``FileInfo`` instance holding the information of the item at the specified url
    /// - Parameters:
    ///   - url: The url to the item
    ///   - resolveSymbolicLink: Whether to (recursively) resolve the symbolic link to find the destination
    public func infoOfItem(at url: URL, resolveSymbolicLink: Bool = false) throws -> FileInfo {
        try self.infoOfItem(at: url.assertAsFilePath(), resolveSymbolicLink: resolveSymbolicLink)
    }


    /// Get a ``FileInfo`` instance holding the information of the item at the specified path
    /// - Parameters:
    ///   - path: The path to the item
    ///   - resolveSymbolicLink: Whether to (recursively) resolve the symbolic link to find the destination
    /// 
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    public func infoOfItem(at path: FilePath, resolveSymbolicLink: Bool = false) async throws -> FileInfo {
        try await Self.runOnIOQueue {
            try self.infoOfItem(at: path, resolveSymbolicLink: resolveSymbolicLink)
        }
    }

    
    /// Get a ``FileInfo`` instance holding the information of the item at the specified url
    /// - Parameters:
    ///   - url: The url to the item
    ///   - resolveSymbolicLink: Whether to (recursively) resolve the symbolic link to find the destination
    /// 
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    public func infoOfItem(at url: URL, resolveSymbolicLink: Bool = false) async throws -> FileInfo {
        try await Self.runOnIOQueue {
            try self.infoOfItem(at: url, resolveSymbolicLink: resolveSymbolicLink)
        }
    }


    /// Check whether an item exists at the specified path
    /// - Parameters:
    ///   - path: The path to check
    ///   - resolveSymbolicLink: Whether to (recursively) resolve the symbolic link to find the destination
    public func fileExists(at path: FilePath, resolveSymbolicLink: Bool = true) -> Bool {
        if resolveSymbolicLink {
            return self.fileExists(atPath: path.string)
        } else {
            do {
                let _ = try self.attributesOfItem(atPath: path.string)
                return true
            } catch let error as NSError where error.code == CocoaError.fileReadNoSuchFile.rawValue {
                return false
            } catch {
                return true
            }
        }
    }


    /// Check whether an item exists at the specified url
    /// - Parameters:
    ///   - url: The url to check
    ///   - resolveSymbolicLink: Whether to (recursively) resolve the symbolic link to find the destination
    public func fileExists(at url: URL, resolveSymbolicLink: Bool = true) -> Bool {
        self.fileExists(at: try! url.assertAsFilePath(), resolveSymbolicLink: resolveSymbolicLink)
    }


    /// Check whether an item exists at the specified path
    /// - Parameters:
    ///   - path: The path to check
    ///   - resolveSymbolicLink: Whether to (recursively) resolve the symbolic link to find the destination
    /// 
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    public func fileExists(at path: FilePath, resolveSymbolicLink: Bool = true) async -> Bool {
        await Self.runOnIOQueue {
            self.fileExists(at: path, resolveSymbolicLink: resolveSymbolicLink)
        }
    }
    
    
    /// Check whether an item exists at the specified url
    /// - Parameters:
    ///   - url: The url to check
    ///   - resolveSymbolicLink: Whether to (recursively) resolve the symbolic link to find the destination
    ///
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func fileExists(at url: URL, resolveSymbolicLink: Bool = true) async -> Bool {
        await Self.runOnIOQueue {
            self.fileExists(at: url, resolveSymbolicLink: resolveSymbolicLink)
        }
    }
    
}


extension FileManager {

    /// Set attributes for the item located at the specified path using the provided ``FileInfo`` instance
    /// - Parameters:
    ///   - info: The ``FileInfo`` instance used to set the attributes for the item
    ///   - path: The path of the item to set the information values
    /// 
    /// Not all attributes in the ``FileInfo`` instance will be set into the item, supported
    /// properties are:
    /// - `creationDate` (Windows only)
    /// - `lastAccessDate` 
    /// - `modificationDate`
    /// - `fileMode` (Only bits related to permissions. Not supported on Windows)
    /// - `fileFlags`
    public func setInfo(_ info: FileInfo, forItemAt path: FilePath) throws {

#if os(Windows)

        let ftCreate = info.creationDate?.windowsFileTime
        let ftModify = info.modificationDate.windowsFileTime
        let ftAccess = info.lastAccessDate.windowsFileTime

        let ftCreatPointer = if var ftCreate { .init(&ftCreate) } else { nil } as UnsafePointer<FILETIME>?
        let ftAccessPointer = if var ftAccess { .init(&ftAccess) } else { nil } as UnsafePointer<FILETIME>?
        let ftModifyPointer = if var ftModify { .init(&ftModify) } else { nil } as UnsafePointer<FILETIME>?

        try WindowsFileUtils.interceptWindowsErrorAsCocorError(path: path, reading: false) {
            if info.creationDateChanged, info.lastAccessDateChanged, info.modificationDateChanged {
                try WindowsFileUtils.withFileHandle(
                    ofItemAt: path, 
                    accessMode: .fileWriteAttributes, 
                    shareMode: .shareRead | .shareWrite, 
                    flagsAndAttributes: .fileFlags.backupSemantics | .fileFlags.openReparsePoint
                ) { handle in
                    guard SetFileTime(handle, ftCreatPointer, ftAccessPointer, ftModifyPointer) else { 
                        throw WindowsError.fromLastError()
                    }
                }
            }
            if info.fileFlagsChanged {
                guard SetFileAttributesW(path.toLpwstr(), info.fileFlags.bits) else {
                    throw WindowsError.fromLastError()
                }
            }
        }

#elseif canImport(Darwin)

        let fd = openat(AT_FDCWD, path.string, O_RDONLY | AT_SYMLINK_NOFOLLOW | O_SYMLINK)

        guard fd >= 0 else {
            throw CocoaError.lastPosixError(path: path, reading: false)
        }
        defer { close(fd) }

        var times = (
            info.lastAccessDateChanged ? info.lastAccessDate.timeSpec : .omit, 
            info.modificationDateChanged ? info.modificationDate.timeSpec : .omit
        )
        try withUnsafeMutablePointer(to: &times) { ptr in 
            try ptr.withMemoryRebound(to: timespec.self, capacity: 2) { ptr in 
                guard futimens(fd, ptr) == 0 else {
                    throw CocoaError.lastPosixError(path: path, reading: false)
                }
            }
        }

        if info.fileModeChanged {
            guard fchmod(fd, info.fileMode) == 0 else {
                print(errno)
                throw CocoaError.lastPosixError(path: path, reading: false)
            }
        }

        if info.fileFlagsChanged {
            guard fchflags(fd, info.fileFlags.bits) == 0 else {
                throw CocoaError.lastPosixError(path: path, reading: false)
            }
        }

#else

        guard !(info.isSymbolicLink && (info.fileFlagsChanged || info.fileModeChanged)) else {
            throw CocoaError.posixError(path: path, posixError: .init(.EOPNOTSUPP), reading: false)
        }

        var times = (
            info.lastAccessDateChanged ? info.lastAccessDate.timeSpec : .omit, 
            info.modificationDateChanged ? info.modificationDate.timeSpec : .omit
        )
        try withUnsafeMutablePointer(to: &times) { ptr in 
            try ptr.withMemoryRebound(to: timespec.self, capacity: 2) { ptr in 
                guard utimensat(AT_FDCWD, path.string, ptr, AT_SYMLINK_NOFOLLOW) == 0 else {
                    throw CocoaError.lastPosixError(path: path, reading: false)
                }
            }
        }

        if info.fileModeChanged || info.fileFlagsChanged {

            let fd = openat(AT_FDCWD, path.string, O_RDONLY)
            defer { close(fd) }

            if info.fileModeChanged {
                guard fchmodat(fd, "", info.fileMode, AT_EMPTY_PATH) == 0 else {
                    throw CocoaError.lastPosixError(path: path, reading: false)
                }
            }

            if info.fileFlagsChanged {
                guard fsetFileFlags(fd, info.fileFlags.bits) == 0 else {
                    throw CocoaError.lastPosixError(path: path, reading: false)
                }
            }

        }

#endif

    }

    
    /// Set attributes for the item located at the specified url using the provided ``FileInfo`` instance
    /// - Parameters:
    ///   - info: The ``FileInfo`` instance used to set the attributes for the item
    ///   - url: The url of the item to set the information values
    /// 
    /// Not all attributes in the ``FileInfo`` instance will be set into the item, supported
    /// properties are:
    /// - `creationDate` (Windows only)
    /// - `lastAccessDate` 
    /// - `modificationDate`
    /// - `fileMode` (Only bits related to permissions. Not supported on Windows)
    /// - `fileFlags`
    public func setInfo(_ info: FileInfo, forItemAt url: URL) throws {
        try self.setInfo(info, forItemAt: url.assertAsFilePath())
    }


    /// Set attributes for the item located at the specified path using the provided ``FileInfo`` instance
    /// - Parameters:
    ///   - info: The ``FileInfo`` instance used to set the attributes for the item
    ///   - path: The path of the item to set the information values
    /// 
    /// Not all attributes in the ``FileInfo`` instance will be set into the item, supported
    /// properties are:
    /// - `creationDate` (Windows only)
    /// - `lastAccessDate` 
    /// - `modificationDate`
    /// - `fileMode` (Only bits related to permissions. Not supported on Windows)
    /// - `fileFlags`
    /// 
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    public func setInfo(_ info: FileInfo, forItemAt path: FilePath) async throws {
        try await Self.runOnIOQueue {
            try self.setInfo(info, forItemAt: path)
        }
    }
    
    
    /// Set attributes for the item located at the specified url using the provided ``FileInfo`` instance
    /// - Parameters:
    ///   - info: The ``FileInfo`` instance used to set the attributes for the item
    ///   - url: The url of the item to set the information values
    /// 
    /// Not all attributes in the ``FileInfo`` instance will be set into the item, supported
    /// properties are:
    /// - `creationDate` (Windows only)
    /// - `lastAccessDate` 
    /// - `modificationDate`
    /// - `fileMode` (Only bits related to permissions. Not supported on Windows)
    /// - `fileFlags`
    ///
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    public func setInfo(_ info: FileInfo, forItemAt url: URL) async throws {
        try await Self.runOnIOQueue {
            try self.setInfo(info, forItemAt: url)
        }
    }
    
}