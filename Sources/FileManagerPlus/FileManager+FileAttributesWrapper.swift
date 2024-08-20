//
//  FileManager+FileAttributesWrapper.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/8/11.
//

import Foundation


extension FileManager {
    
    /// A type representing attributes of a file
    ///
    /// It is basically a wrapper for `[FileAttributeKey: Any]`, which is the return value of
    /// [`attributesOfItem(atPath:)`].
    ///
    /// It provides APIs for easier access to commonly used file attributes
    ///
    /// For attributes that are not directly supported by those APIs, use ``subscript(_:as:)``
    /// or ``subscript(_:as:default:)`` to get the value
    ///
    /// - Note: Whenever possible, prefer `FileInfo` instead of this type or
    /// `[FileAttributeKey: Any]`
    ///
    /// [`attributesOfItem(atPath:)`]: https://developer.apple.com/documentation/foundation/filemanager/1410452-attributesofitem
    public struct FileAttributes: @unchecked Sendable, ExpressibleByDictionaryLiteral {
        
        fileprivate var attributes: [FileAttributeKey: Any]
        fileprivate var nsAttributes: NSDictionary { attributes as NSDictionary }
        
        
        /// Create a ``FileAttributes`` instance from the return value of
        /// [`attributesOfItem(atPath:)`]
        ///
        /// [`attributesOfItem(atPath:)`]: https://developer.apple.com/documentation/foundation/filemanager/1410452-attributesofitem
        public init(attributes: [FileAttributeKey : Any] = [:]) {
            self.attributes = attributes
        }
        
        
        public init(dictionaryLiteral elements: (FileAttributeKey, Any)...) {
            attributes = .init(elements, uniquingKeysWith: { $1 })
        }
        
        
        /// Access a file attribute value for the given key and convert it to the specified type
        ///
        /// - Parameters:
        ///   - key: The key for accessing the file attribute value
        ///   - type: The expected type of the file attribute value
        /// - Returns: The file attribute value, or `nil` if the required attribute does not
        /// existe or the type conversion fails
        public subscript<T>(
            _ key: FileAttributeKey,
            as type: T.Type = T.self
        ) -> T? {
            get { attributes[key] as? T}
            set { attributes[key] = newValue }
        }
        
        
        /// Access a file attribute value for the given key and convert it to the specified type
        ///
        /// - Parameters:
        ///   - key: The key for accessing the file attribute value
        ///   - type: The expected type of the file attribute value
        ///   - defaultValue: The default value to use if the attribute does not exist or the type
        ///   conversion fails
        /// - Returns: The file attribute value, or `defaultValue` if the required attribute does not
        /// exist or the type conversion fails
        public subscript<T>(
            _ key: FileAttributeKey,
            as type: T.Type = T.self,
            default defaultValue: T
        ) -> T {
            get { (attributes[key] as? T) ?? defaultValue }
            set { attributes[key] = newValue }
        }
        
    }
    
}


extension FileManager.FileAttributes {
    
    /// size of the file in bytes
    public var size: UInt64 {
        get { nsAttributes.fileSize() }
        set { attributes[.size] = newValue }
    }
    /// whether the file is busy
    public var busy: Bool {
        get { (attributes[.busy] as? Bool) ?? false }
        set { attributes[.busy] = newValue }
    }
    /// file’s creation date
    public var creationDate: Date? {
        get { nsAttributes.fileCreationDate() }
        set { if let newValue { attributes[.creationDate] = newValue } }
    }
    /// file’s group owner account ID
    public var groupOwnerId: UInt64? {
        get { nsAttributes.fileGroupOwnerAccountID() as? UInt64 }
        set { if let newValue { attributes[.groupOwnerAccountID] = newValue } }
    }
    /// file’s group owner account name
    public var groupOwnerName: String? {
        get { nsAttributes.fileGroupOwnerAccountName() }
        set { if let newValue { attributes[.groupOwnerAccountName] = newValue } }
    }
    /// whether the file is immutable
    public var immutable: Bool {
        get { nsAttributes.fileIsImmutable() }
        set { attributes[.immutable] = newValue }
    }
    /// file’s modification date
    public var modificationDate: Date? {
        get { nsAttributes.fileModificationDate() }
        set { if let newValue { attributes[.modificationDate] = newValue } }
    }
    /// file’s owner account ID
    public var ownerId: UInt64? {
        get { nsAttributes.fileOwnerAccountID() as? UInt64 }
        set { if let newValue { attributes[.ownerAccountID] = newValue } }
    }
    /// file’s owner account name
    public var ownerName: String? {
        get { nsAttributes.fileOwnerAccountName() }
        set { if let newValue { attributes[.ownerAccountName] = newValue } }
    }
    /// file’s POSIX permissions
    public var posixPermissions: Int {
        get { nsAttributes.filePosixPermissions() }
        set { attributes[.posixPermissions] = newValue }
    }
    /// file type as [`FileAttributeType`]
    ///
    /// - seealso: [`FileAttributeType`]
    ///
    /// [`FileAttributeType`]: https://developer.apple.com/documentation/foundation/fileattributetype
    public var type: FileAttributeType {
        get {
            guard let typeStr = nsAttributes.fileType() else { return .typeUnknown }
            return .init(rawValue: typeStr)
        }
        set {
            attributes[.type] = newValue.rawValue
        }
    }
    
    /// whether the file is a directory
    public var isDirectory: Bool {
        self.type == .typeDirectory
    }
    
    /// whether the file is a symbolic link
    public var isSymbolicLink: Bool {
        self.type == .typeSymbolicLink
    }
    
}



extension FileManager {
    
    /// Get the attributes of the file at the specified url
    /// - Parameter url: The url of the file to get the attributes
    /// - Returns: The file attributes of the file
    public func attributes(ofItemAt url: URL) throws -> FileAttributes {
        .init(attributes: try self.attributesOfItem(atPath: url.compactPath()))
    }
    
    
    /// Get the attributes of the file at the specified url
    /// - Parameter url: The url of the file to get the attributes
    /// - Returns: The file attributes of the file
    ///
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func attributesAsync(ofItemAt url: URL) async throws -> FileAttributes {
        
        try await Self.runOnIOQueue {
            Self.assertOnIOQueue()
            let attributes = try self.attributesOfItem(atPath: url.compactPath())
            return FileAttributes(attributes: attributes)
        }
        
    }
    
}
