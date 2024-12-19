import Foundation
import SystemPackage
import FoundationPlusEssential
#if os(Windows)
import WinSDK
#endif


extension FileManager {

    public func infoOfItem(at path: FilePath, resolveSymbolicLink: Bool = false) throws -> FileInfo {
        if resolveSymbolicLink {
            let destPath = try self.destinationOfSymbolicLink(at: path, recursive: true)
            return try .init(path: destPath)
        } else {
            return try .init(path: path)
        }
    }


    public func infoOfItem(at url: URL, resolveSymbolicLink: Bool = false) throws -> FileInfo {
        try self.infoOfItem(at: url.assertAsFilePath(), resolveSymbolicLink: resolveSymbolicLink)
    }


    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func infoOfItem(at path: FilePath, resolveSymbolicLink: Bool = false) async throws -> FileInfo {
        try await Self.runOnIOQueue {
            try self.infoOfItem(at: path, resolveSymbolicLink: resolveSymbolicLink)
        }
    }


    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func infoOfItem(at url: URL, resolveSymbolicLink: Bool = false) async throws -> FileInfo {
        try await Self.runOnIOQueue {
            try self.infoOfItem(at: url, resolveSymbolicLink: resolveSymbolicLink)
        }
    }


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


    public func fileExists(at url: URL, resolveSymbolicLink: Bool = true) -> Bool {
        self.fileExists(at: try! url.assertAsFilePath(), resolveSymbolicLink: resolveSymbolicLink)
    }


    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func fileExists(at path: FilePath, resolveSymbolicLink: Bool = true) async -> Bool {
        await Self.runOnIOQueue {
            self.fileExists(at: path, resolveSymbolicLink: resolveSymbolicLink)
        }
    }
    
    
    /// Check whether a file or directory exists at the specified url
    /// - Parameter url: The url to check
    /// - Returns: true if a file or directory exists, false otherwise
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

    public func setInfo(_ info: FileInfo, forItemAt path: FilePath) throws {

#if os(Windows)

        let ftCreate = info.creationDate.windowsFileTime
        let ftModify = info.modificationDate.windowsFileTime
        let ftAccess = info.lastAccessDate.windowsFileTime

        let ftCreatPointer = if var ftCreate { .init(&ftCreate) } else { nil } as UnsafePointer<FILETIME>?
        let ftAccessPointer = if var ftAccess { .init(&ftAccess) } else { nil } as UnsafePointer<FILETIME>?
        let ftModifyPointer = if var ftModify { .init(&ftModify) } else { nil } as UnsafePointer<FILETIME>?

        try WindowsFileUtils.interceptWindowsErrorAsCocorError(path: path, reading: false) {
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
            
            guard SetFileAttributesW(path.toLpwstr(), info.fileAttributes) else {
                throw WindowsError.fromLastError()
            }
        }

#else 

        var attributes = FileAttributes()
        attributes.creationDate = info.creationDate
        attributes.modificationDate = info.modificationDate
        attributes.posixPermissions = info.posixPermissionBits
        try self.setAttributes(attributes, ofItemAt: path)
        var accessTimeSpec = timespec()
        let interval = info.lastAccessDate?.timeIntervalSince1970 ?? 0
        accessTimeSpec.tv_sec = time_t(interval)
        accessTimeSpec.tv_nsec = Int(interval.truncatingRemainder(dividingBy: 1) * 1_000_000_000)
        var times = [accessTimeSpec, timespec(tv_sec: .init(UTIME_OMIT), tv_nsec: 0)]
        utimensat(AT_FDCWD, path.string, &times, 0)

#endif

    }

    
    /// Set information values for the file located at `url` using [`URLResourceValues`]
    /// - Parameters:
    ///   - info: The information values to set
    ///   - url: The url of the file to set the information values
    ///
    /// - Note: [`URLResourceValues`] will record which attributes are modified, so only those
    /// file information values will be set into the file
    ///
    /// [`URLResourceValues`]: https://developer.apple.com/documentation/foundation/urlresourcevalues
    public func setInfo(_ info: FileInfo, forItemAt url: URL) throws {
        try self.setInfo(info, forItemAt: url.assertAsFilePath())
    }


    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func setInfo(_ info: FileInfo, forItemAt path: FilePath) async throws {
        try await Self.runOnIOQueue {
            try self.setInfo(info, forItemAt: path)
        }
    }
    
    
    /// Set information values for the file located at `url` using ``FileInfo``
    /// - Parameters:
    ///   - info: The information values to set
    ///   - url: The url of the file to set the information values
    ///
    /// - Note: Unlike [`URLResourceValues`], the ``FileInfo`` will NOT record which attributes are
    /// modified, so everything inside will be set into the file, but values that are not included
    /// by ``FileInfo`` will not be changed
    ///
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    ///
    /// [`URLResourceValues`]: https://developer.apple.com/documentation/foundation/urlresourcevalues
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func setInfo(_ info: FileInfo, forItemAt url: URL) async throws {
        try await Self.runOnIOQueue {
            try self.setInfo(info, forItemAt: url)
        }
    }
    
}