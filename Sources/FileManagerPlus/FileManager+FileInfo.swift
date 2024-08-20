//
//  FileInfo.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/7/29.
//

import Foundation
import UniformTypeIdentifiers


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
        
        /// size of the file in bytes
        public let fileSize: Int
        /// The date the file was created
        public var creationDate: Date?
        /// The date the file was last accessed
        public var contentAccessDate: Date?
        /// The time the content was last modified
        public var contentModificationDate: Date?
        /// file’s owner UID
        public var ownerUID: UInt32?
        /// file’s group owner GID
        public var ownerGID: UInt32?
        /// file’s POSIX permissions
        public var fileMode: UInt16
        /// The file system object type as [`URLFileResourceType`]
        ///
        /// - seealso: [`URLFileResourceType`]
        ///
        /// [`URLFileResourceType`]: https://developer.apple.com/documentation/foundation/URLFileResourceType
        public let fileResourceType: URLFileResourceType
        /// Whether the file is a regular file
        public let isRegularFile: Bool
        /// whether the file is a directory
        public let isDirectory: Bool
        /// whether the file is a symbolic link
        public let isSymbolicLink: Bool
        /// whether the file is a root directory of a volume
        public let isVolume: Bool
        /// whether the file is a packaged directories
        public let isPackage: Bool
        /// Whether the file is an application
        public let isApplication: Bool
        /// Whether the current process can read the file
        public let isReadable: Bool
        /// Whether the current process can write to the file
        public let isWritable: Bool
        /// Whether the current process can execute the file or search the directory
        public let isExecutable: Bool
        
        public var posixPermission: UInt16 {
            get { fileMode & ((1 << 9) - 1) }
            set {
                let newValue = newValue & ((1 << 9) - 1)
                fileMode = (fileMode & (((1 << 7) - 1) << 9)) | newValue
            }
        }
        
        public init(
            fileSize: Int = 0,
            creationDate: Date? = nil,
            contentAccessDate: Date? = nil,
            contentModificationDate: Date? = nil,
            ownerUID: UInt32? = nil,
            ownerGID: UInt32? = nil,
            fileMode: UInt16 = 0,
            fileResourceType: URLFileResourceType = .unknown,
            isRegularFile: Bool = false,
            isDirectory: Bool = false,
            isSymbolicLink: Bool = false,
            isVolume: Bool = false,
            isPackage: Bool = false,
            isApplication: Bool = false,
            isReadable: Bool = false,
            isWritable: Bool = false,
            isExecutable: Bool = false
        ) {
            self.fileSize = fileSize
            self.creationDate = creationDate
            self.contentAccessDate = contentAccessDate
            self.contentModificationDate = contentModificationDate
            self.ownerUID = ownerUID
            self.ownerGID = ownerGID
            self.fileMode = fileMode
            self.fileResourceType = fileResourceType
            self.isRegularFile = isRegularFile
            self.isDirectory = isDirectory
            self.isSymbolicLink = isSymbolicLink
            self.isVolume = isVolume
            self.isPackage = isPackage
            self.isApplication = isApplication
            self.isReadable = isReadable
            self.isWritable = isWritable
            self.isExecutable = isExecutable
        }
        
    }
    
}


extension FileManager.FileInfo: Equatable, Hashable {}


extension FileManager.FileInfo {
    
    static let urlResourceKeys: Set<URLResourceKey> = [
        .fileSizeKey,
        .creationDateKey,
        .contentAccessDateKey,
        .contentModificationDateKey,
        .ownerUIDKey,
        .ownerGIDKey,
        .fileModeKey,
        .fileResourceTypeKey,
        .isRegularFileKey,
        .isDirectoryKey,
        .isSymbolicLinkKey,
        .isVolumeKey,
        .isPackageKey,
        .isApplicationKey,
        .isReadableKey,
        .isWritableKey,
        .isExecutableKey,
    ]
    
    /// Create a `FileInfo` instance by fetching the attributes from the file
    /// located at the provided `url`
    public init(url: URL) throws {
        let values = try url.resourceValues(forKeys: Self.urlResourceKeys)
        self.init(
            fileSize: values.fileSize ?? 0,
            creationDate: values.creationDate,
            contentAccessDate: values.contentAccessDate,
            contentModificationDate: values.contentModificationDate,
            ownerUID: values.ownerUID,
            ownerGID: values.ownerGID,
            fileMode: values.fileMode ?? 0,
            fileResourceType: values.fileResourceType ?? .unknown,
            isRegularFile: values.isRegularFile ?? false,
            isDirectory: values.isDirectory ?? false,
            isSymbolicLink: values.isSymbolicLink ?? false,
            isVolume: values.isVolume ?? false,
            isPackage: values.isPackage ?? false,
            isApplication: values.isApplication ?? false,
            isReadable: values.isReadable ?? false,
            isWritable: values.isWritable ?? false,
            isExecutable: values.isExecutable ?? false
        )
    }
    
    
    public func toResourceValues() -> URLResourceValues {
        var values = URLResourceValues()
        values.creationDate = creationDate
        values.contentAccessDate = contentAccessDate
        values.contentModificationDate = contentModificationDate
        values.ownerUID = ownerUID
        values.ownerGID = ownerGID
        values.fileMode = fileMode
        return values
    }
    
}


extension URL {
    
    /// Fetch attributes of the file located at the `url` as a `FileInfo` instance
    public func fetchFileInfo() throws -> FileManager.FileInfo {
        try .init(url: self)
    }
    
}



extension FileManager {
    
    /// Get a set of file information values specified with `keys` of the file at `url`
    /// - Parameters:
    ///   - keys: The set of values to fetch, specified as a set of [`URLResourceKey`]
    ///   - url: The url of the file to get the information values
    /// - Returns: The required set of file information values as [`URLResourceValues`]
    ///
    /// [`URLResourceValues`]: https://developer.apple.com/documentation/foundation/urlresourcevalues
    /// [`URLResourceKey`]: https://developer.apple.com/documentation/foundation/urlresourcekey
    public func info(
        _ keys: Set<URLResourceKey>,
        ofItemAt url: URL
    ) throws -> URLResourceValues {
        try url.resourceValues(forKeys: keys)
    }
    
    
    /// Get a file information value specified with a ``URLResourcePair`` of the file at `url`
    /// - Parameters:
    ///   - pair: Specify the value to fetch
    ///   - url: The url of the file to get the information value
    /// - Returns: The required file information value
    public func info<K: KeyPath<URLResourceValues, T>, T>(
        _ pair: URLResourcePair<K, T>,
        ofItemAt url: URL
    ) throws -> T {
        try url.resourceValues(forKeys: [pair.key])[keyPath: pair.valueKeyPath]
    }
    
    
    /// Get a file information value specified with a ``URLResourcePair`` of the file at `url`
    /// - Parameters:
    ///   - pair: Specify the value to fetch
    ///   - url: The url of the file to get the information value
    ///   - default: The default value to use if the fetched file information value is nil
    /// - Returns: The required file information value
    public func info<K: KeyPath<URLResourceValues, T?>, T>(
        _ pair: URLResourcePair<K, T?>,
        ofItemAt url: URL,
        default: T
    ) throws -> T {
        try url.resourceValues(forKeys: [pair.key])[keyPath: pair.valueKeyPath] ?? `default`
    }
    
    
    /// Get the information of the file at the specified url
    /// - Parameter url: The url of the file to get the information
    /// - Returns: The file information of the file
    public func info(ofItemAt url: URL) throws -> FileInfo {
        try .init(url: url)
    }
    
    
    /// Get a set of file information values specified with `keys` of the file at `url`
    /// - Parameters:
    ///   - keys: The set of values to fetch, specified as a set of [`URLResourceKey`]
    ///   - url: The url of the file to get the information values
    /// - Returns: The required set of file information values as [`URLResourceValues`]
    ///
    /// [`URLResourceValues`]: https://developer.apple.com/documentation/foundation/urlresourcevalues
    /// [`URLResourceKey`]: https://developer.apple.com/documentation/foundation/urlresourcekey
    ///
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func infoAsync(
        _ keys: Set<URLResourceKey>,
        ofItemAt url: URL
    ) async throws -> URLResourceValues {
        try await Self.runOnIOQueue {
            Self.assertOnIOQueue()
            return try self.info(keys, ofItemAt: url)
        }
    }
    
    
    /// Get a file information value specified with a ``URLResourcePair`` of the file at `url`
    /// - Parameters:
    ///   - pair: Specify the value to fetch
    ///   - url: The url of the file to get the information value
    /// - Returns: The required file information value
    ///
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func infoAsync<K: KeyPath<URLResourceValues, T>, T>(
        _ key: URLResourcePair<K, T>,
        ofItemAt url: URL
    ) async throws -> T {
        try await Self.runOnIOQueue {
            Self.assertOnIOQueue()
            return try self.info(key, ofItemAt: url)
        }
    }
    
    
    /// Get a file information value specified with a ``URLResourcePair`` of the file at `url`
    /// - Parameters:
    ///   - pair: Specify the value to fetch
    ///   - url: The url of the file to get the information value
    ///   - default: The default value to use if the fetched file information value is nil
    /// - Returns: The required file information value
    ///
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func infoAsync<K: KeyPath<URLResourceValues, T?>, T>(
        _ key: URLResourcePair<K, T?>,
        ofItemAt url: URL,
        default: T
    ) async throws -> T {
        try await Self.runOnIOQueue {
            Self.assertOnIOQueue()
            return try self.info(key, ofItemAt: url) ?? `default`
        }
    }
    
    
    /// Get the information of the file at the specified url
    /// - Parameter url: The url of the file to get the information
    /// - Returns: The file information of the file
    ///
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func infoAsync(ofItemAt url: URL) async throws -> FileInfo {
        try await Self.runOnIOQueue {
            Self.assertOnIOQueue()
            return try self.info(ofItemAt: url)
        }
    }
    
}



extension FileManager {
    
    public func fileExists(at url: URL, resolveSymbolicLink: Bool = true) -> Bool {
        if resolveSymbolicLink {
            self.fileExists(atPath: url.compactPath())
        } else {
            (try? url.checkResourceIsReachable()) == true
        }
    }
    
    
    /// Check whether a file or directory exists at the specified url
    /// - Parameter url: The url to check
    /// - Returns: true if a file or directory exists, false otherwise
    ///
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func fileExistsAsync(at url: URL, resolveSymbolicLink: Bool = true) async -> Bool {
        
        await Self.runOnIOQueue {
            Self.assertOnIOQueue()
            return self.fileExists(at: url, resolveSymbolicLink: resolveSymbolicLink)
        }
        
    }
    
    
    /// Get the number of enties in a directory
    /// - Parameter url: The url of the directory
    /// - Returns: The number of entries in the directory
    ///
    /// - Note: The item at the provided `url` MUST be a directory, or an error will be thrown
    public func directoryEntriesCount(of url: URL) throws -> Int {
        guard try info(.isDirectory, ofItemAt: url) == true else {
            throw CocoaError.fileError(
                .fileReadInvalidFileName, url: url,
                description: "The file at \(url) is not a directory",
                underlyingError: POSIXError(.ENOTDIR)
            )
        }
        return if #available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *) {
            try info(.directoryEntryCount, ofItemAt: url) ?? 0
        } else {
            try self.contentsOfDirectory(at: url, includingPropertiesForKeys: []).count
        }
    }
    
    
    /// Get the number of enties in a directory
    /// - Parameter url: The url of the directory
    /// - Returns: The number of entries in the directory
    ///
    /// - Note: The item at the provided `url` MUST be a directory, or an error will be thrown
    ///
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func directoryEntriesCountAsync(of url: URL) async throws -> Int {
        try await Self.runOnIOQueue {
            try self.directoryEntriesCount(of: url)
        }
    }
    
}


extension FileManager {
    
    /// Set information values for the file located at `url` using [`URLResourceValues`]
    /// - Parameters:
    ///   - info: The information values to set
    ///   - url: The url of the file to set the information values
    ///
    /// - Note: [`URLResourceValues`] will record which attributes are modified, so only those
    /// file information values will be set into the file
    ///
    /// [`URLResourceValues`]: https://developer.apple.com/documentation/foundation/urlresourcevalues
    public func setInfo(_ info: URLResourceValues, forItemAt url: URL) throws {
        var url = url
        try url.setResourceValues(info)
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
    /// [`URLResourceValues`]: https://developer.apple.com/documentation/foundation/urlresourcevalues
    public func setInfo(_ info: FileInfo, forItemAt url: URL) throws {
        try self.setInfo(info.toResourceValues(), forItemAt: url)
    }
    
    
    /// Set the specific information value for the file located at `url`
    /// - Parameters:
    ///   - key: The key of the information value to set
    ///   - newValue: The new value to set
    ///   - url: The url of the file to set the information values
    ///
    /// - Note: Not all the file information values can be set since some of them are read-only
    public func setInfo<T>(
        _ key: URLResourcePair<WritableKeyPath<URLResourceValues, T>, T>,
        to newValue: T,
        forItemAt url: URL
    ) throws {
        var resourceValue = URLResourceValues()
        resourceValue[keyPath: key.valueKeyPath] = newValue
        try setInfo(resourceValue, forItemAt: url)
    }
    
    
    /// Set information values for the file located at `url` using [`URLResourceValues`]
    /// - Parameters:
    ///   - info: The information values to set
    ///   - url: The url of the file to set the information values
    ///
    /// - Note: [`URLResourceValues`] will record which attributes are modified, so only those
    /// file information values will be set into the file
    ///
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    ///
    /// [`URLResourceValues`]: https://developer.apple.com/documentation/foundation/urlresourcevalues
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func setInfoAsync(_ info: URLResourceValues, forItemAt url: URL) async throws {
        try await Self.runOnIOQueue {
            try self.setInfo(info, forItemAt: url)
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
    public func setInfoAsync(_ info: FileInfo, forItemAt url: URL) async throws {
        try await Self.runOnIOQueue {
            try self.setInfo(info, forItemAt: url)
        }
    }
    
    
    /// Set the specific information value for the file located at `url`
    /// - Parameters:
    ///   - key: The key of the information value to set
    ///   - newValue: The new value to set
    ///   - url: The url of the file to set the information values
    ///
    /// - Note: Not all the file information values can be set since some of them are read-only
    ///
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func setInfoAsync<T>(
        _ key: URLResourcePair<WritableKeyPath<URLResourceValues, T>, T>,
        to newValue: T,
        forItemAt url: URL
    ) async throws {
        try await Self.runOnIOQueue {
            try self.setInfo(key, to: newValue, forItemAt: url)
        }
    }
    
}
