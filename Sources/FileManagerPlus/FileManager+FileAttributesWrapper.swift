//
//  FileManager+FileAttributesWrapper.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/8/11.
//

import Foundation
import SystemPackage


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
    public struct FileAttributes: Sendable, ExpressibleByDictionaryLiteral {
        
        fileprivate var attributes: [FileAttributeKey: AttributeValue]
        
        
        /// Create a ``FileAttributes`` instance from the return value of
        /// [`attributesOfItem(atPath:)`]
        ///
        /// [`attributesOfItem(atPath:)`]: https://developer.apple.com/documentation/foundation/filemanager/1410452-attributesofitem
        public init(attributes: [FileAttributeKey : AttributeValue] = [:]) {
            self.attributes = attributes
        }
        
        
        public init(dictionaryLiteral elements: (FileAttributeKey, AttributeValue)...) {
            attributes = .init(elements, uniquingKeysWith: { $1 })
        }
        
        
        /// Access a file attribute value for the given key and convert it to the specified type
        ///
        /// - Parameters:
        ///   - key: The key for accessing the file attribute value
        ///   - type: The expected type of the file attribute value
        /// - Returns: The file attribute value, or `nil` if the required attribute does not
        /// existe or the type conversion fails
        public subscript(
            _ key: FileAttributeKey
        ) -> AttributeValue? {
            get { attributes[key] }
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
        public subscript(
            _ key: FileAttributeKey,
            default defaultValue: AttributeValue
        ) -> AttributeValue {
            get { (attributes[key]) ?? defaultValue }
            set { attributes[key] = newValue }
        }


        public func toRawAttributes() -> [FileAttributeKey: Any] {
            attributes.mapValues { $0.any }
        }
        
    }
    
}


extension FileManager.FileAttributes {
    
    /// size of the file in bytes
    public var size: UInt64 {
        get { (attributes[.size]?.uint64) ?? 0 }
        set { attributes[.size] = .uint64(newValue) }
    }
    /// whether the file is busy
    public var busy: Bool {
        get { (attributes[.busy]?.bool) ?? false }
        set { attributes[.busy] = .bool(newValue) }
    }
    /// file’s creation date
    public var creationDate: Date? {
        get { attributes[.creationDate]?.date }
        set { if let newValue { attributes[.creationDate] = .date(newValue) } }
    }
    /// file’s group owner account ID
    public var groupOwnerId: UInt64? {
        get { attributes[.groupOwnerAccountID]?.uint64 }
        set { if let newValue { attributes[.groupOwnerAccountID] = .uint64(newValue) } }
    }
    /// file’s group owner account name
    public var groupOwnerName: String? {
        get { attributes[.groupOwnerAccountName]?.string }
        set { if let newValue { attributes[.groupOwnerAccountName] = .string(newValue) } }
    }
    /// whether the file is immutable
    public var immutable: Bool {
        get { (attributes[.immutable]?.bool) ?? false }
        set { attributes[.immutable] = .bool(newValue) }
    }
    /// file’s modification date
    public var modificationDate: Date? {
        get { attributes[.modificationDate]?.date }
        set { if let newValue { attributes[.modificationDate] = .date(newValue) } }
    }
    /// file’s owner account ID
    public var ownerId: UInt64? {
        get { attributes[.ownerAccountID]?.uint64 }
        set { if let newValue { attributes[.ownerAccountID] = .uint64(newValue) } }
    }
    /// file’s owner account name
    public var ownerName: String? {
        get { attributes[.ownerAccountName]?.string }
        set { if let newValue { attributes[.ownerAccountName] = .string(newValue) } }
    }
    /// file’s POSIX permissions
    public var posixPermissions: UInt16 {
        get { (attributes[.posixPermissions]?.uint16) ?? 0 }
        set { attributes[.posixPermissions] = .uint16(newValue) }
    }
    public var referenceCount: UInt64 {
        get { (attributes[.referenceCount]?.uint64) ?? 0 }
        set { attributes[.referenceCount] = .uint64(newValue) }
    }
    public var systemNumber: UInt32 {
        get { (attributes[.systemNumber]?.uint32) ?? 0 }
        set { attributes[.systemNumber] = .uint32(newValue) }
    }
    public var systemFileNumber: UInt64 {
        get { (attributes[.systemFileNumber]?.uint64) ?? 0 }
        set { attributes[.systemFileNumber] = .uint64(newValue) }
    }
    public var deviceIdentifier: UInt64 {
        get { (attributes[.deviceIdentifier]?.uint64) ?? 0 }
        set { attributes[.deviceIdentifier] = .uint64(newValue) }
    }
    public var extensionHidden: Bool {
        get { (attributes[.extensionHidden]?.bool) ?? false }
        set { attributes[.extensionHidden] = .bool(newValue) }
    }
    public var hfsCreatorCode: UInt32 {
        get { (attributes[.hfsCreatorCode]?.uint32) ?? 0 }
        set { attributes[.hfsCreatorCode] = .uint32(newValue) }
    }
    public var hfsTypeCode: UInt32 {
        get { (attributes[.hfsTypeCode]?.uint32) ?? 0 }
        set { attributes[.hfsTypeCode] = .uint32(newValue) }
    }
    public var isAppendOnly: Bool {
        get { (attributes[.appendOnly]?.bool) ?? false }
        set { attributes[.appendOnly] = .bool(newValue) }
    }
    public var protectionKey: String? {
        get { (attributes[.protectionKey]?.string) }
        set { if let newValue { attributes[.protectionKey] = .string(newValue) } }
    }
    public var systemSize: UInt64 {
        get { (attributes[.systemSize]?.uint64) ?? 0 }
        set { attributes[.systemSize] = .uint64(newValue) }
    }
    public var systemFreeSize: UInt64 {
        get { (attributes[.systemFreeSize]?.uint64) ?? 0 }
        set { attributes[.systemFreeSize] = .uint64(newValue) }
    }
    public var systemNodes: UInt64 {
        get { (attributes[.systemNodes]?.uint64) ?? 0 }
        set { attributes[.systemNodes] = .uint64(newValue) }
    }
    public var systemFreeNodes: UInt64 {
        get { (attributes[.systemFreeNodes]?.uint64) ?? 0 }
        set { attributes[.systemFreeNodes] = .uint64(newValue) }
    }
    /// file type as [`FileAttributeType`]
    ///
    /// - seealso: [`FileAttributeType`]
    ///
    /// [`FileAttributeType`]: https://developer.apple.com/documentation/foundation/fileattributetype
    public var type: FileAttributeType {
        get { attributes[.type]?.type ?? .typeUnknown }
        set { attributes[.type] = .type(newValue) }
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



extension FileManager.FileAttributes {

    public enum AttributeValue: Sendable {
        case string(String)
        case uint64(UInt64)
        case date(Date)
        case bool(Bool)
        case type(FileAttributeType)

        public var any: Any { 
            switch self {
                case .string(let value): value
                case .uint64(let value): value
                case .date(let value): value
                case .bool(let value): value
                case .type(let value): value
            }
        }

        public var string: String? {
            guard case let .string(value) = self else { return nil }
            return value
        }

        public var uint16: UInt16? {
            guard case let .uint64(value) = self else { return nil }
            return .init(value)
        }

        public var uint32: UInt32? {
            guard case let .uint64(value) = self else { return nil }
            return .init(value)
        }

        public var uint64: UInt64? {
            guard case let .uint64(value) = self else { return nil }
            return value
        }

        public var date: Date? {
            guard case let .date(value) = self else { return nil }
            return value
        }

        public var bool: Bool? {
            guard case let .bool(value) = self else { return nil }
            return value
        }

        public var type: FileAttributeType? {
            guard case let .type(value) = self else { return nil }
            return value
        }

        public static func uint16(_ value: UInt16) -> Self {
            .uint64(.init(value))
        }

        public static func uint32(_ value: UInt32) -> Self {
            .uint64(.init(value))
        }
    }

}



extension FileManager.FileAttributes.AttributeValue: ExpressibleByIntegerLiteral, ExpressibleByStringLiteral, ExpressibleByBooleanLiteral {

    public init(integerLiteral value: IntegerLiteralType) {
        self = .uint64(.init(value))
    }

    public init(stringLiteral value: StringLiteralType) {
        self = .string(value)
    }

    public init(booleanLiteral value: BooleanLiteralType) {
        self = .bool(value)
    }

}



extension FileManager {

    public func attributesOfItem(at path: FilePath) throws -> FileAttributes {
        let rawAttrs = try self.attributesOfItem(atPath: path.string)
        var attributes = FileAttributes()
        rawAttrs.forEach { key, value in
            switch value {
                case let value as String:
                    attributes[key] = .string(value)
                case let value as NSNumber where type(of: value) == type(of: NSNumber(booleanLiteral: true)):
                    attributes[key] = .bool(value.boolValue)
                case let value as NSNumber:
                    attributes[key] = .uint64(value.uint64Value)
                case let value as Date:
                    attributes[key] = .date(value)
                case let value as FileAttributeType:
                    attributes[key] = .type(value)
                default:
                    break
            }
        }
        return attributes
    }

    
    /// Get the attributes of the file at the specified url
    /// - Parameter url: The url of the file to get the attributes
    /// - Returns: The file attributes of the file
    public func attributesOfItem(at url: URL) throws -> FileAttributes {
        try self.attributesOfItem(at: url.assertAsFilePath())
    }


    public func attributesOfItem(at path: FilePath) async throws -> FileAttributes {
        try await Self.runOnIOQueue {
            try self.attributesOfItem(at: path)
        }
    }
    
    
    /// Get the attributes of the file at the specified url
    /// - Parameter url: The url of the file to get the attributes
    /// - Returns: The file attributes of the file
    ///
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func attributesOfItem(at url: URL) async throws -> FileAttributes {
        try await Self.runOnIOQueue {
            try self.attributesOfItem(at: url)
        }
    }


    public func setAttributes(_ attributes: FileAttributes, ofItemAt path: FilePath) throws {
        try self.setAttributes(attributes.toRawAttributes(), ofItemAtPath: path.string)
    }


    public func setAttributes(_ attributes: FileAttributes, ofItemAt url: URL) throws {
        try self.setAttributes(attributes.toRawAttributes(), ofItemAtPath: url.compatPath())
    }


    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func setAttributes(_ attributes: FileAttributes, ofItemAt path: FilePath) async throws {
        try await Self.runOnIOQueue {
            try self.setAttributes(attributes, ofItemAt: path)
        }
    }


    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func setAttributes(_ attributes: FileAttributes, ofItemAt url: URL) async throws {
        try await Self.runOnIOQueue {
            try self.setAttributes(attributes, ofItemAt: url)
        }
    }
    
}
