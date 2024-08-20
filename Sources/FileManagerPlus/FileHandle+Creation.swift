//
//  FileHandle+Creation.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/7/31.
//

import Foundation


@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension FileManager {
    
    /// Options for opening a file
    public struct OpenFileOption: Sendable {
        /// Whether to create a new file if the file does not exist
        public let newFile: Bool
        /// Whether to replace the existed file
        public let existingFile: ExistingFileOption
        public init(newFile: Bool = false, existingFile: ExistingFileOption = .open) {
            self.newFile = newFile
            self.existingFile = existingFile
        }
        /// Option for creating a new file if it does not exist
        /// - Parameter replaceExisting: Whether to replace the existed file. If set to false
        /// and the file already exists, an error will be thrown
        public static func newFile(replaceExisting: Bool) -> Self {
            .init(newFile: true, existingFile: replaceExisting ? .truncate : .error)
        }
        /// Option for modifying existed file
        /// - Parameter createIfNeeded: Whether to create a new file if it does not exist. If set
        /// to false and the file does not exist, an error will be thrown
        public static func modifyFile(createIfNeeded: Bool) -> Self {
            .init(newFile: createIfNeeded, existingFile: .open)
        }
    }
    
    
    /// Options for handling existing file
    public enum ExistingFileOption: Sendable {
        /// assert that the file does not exist, otherwise throw an error
        case error
        /// open the file directly without clearing the contents
        case open
        /// open the file and clear the contents
        case truncate
    }
    
    
    /// Cases of opening a file, usually for writing
    public enum OpenFileActualOperation: Sendable {
        /// direct open, will throw an error if the file does not exist
        case openDirectly
        /// will create the file if the file does not exist
        case create
        /// clear content of the existed file, will throw an error if the file does not exist
        case truncate
    }
    
    
    private func inferActualOpenOperation(
        from url: URL,
        with options: OpenFileOption
    ) throws -> OpenFileActualOperation {
        if self.fileExists(atPath: url.compactPath()) {
            switch options.existingFile {
                case .open: .openDirectly
                case .error: throw CocoaError.fileError(.fileWriteFileExists, url: url)
                case .truncate: .truncate
            }
        } else {
            if options.newFile {
                .create
            } else {
                .openDirectly
            }
        }
    }
    
    
    private func makeWritingHandle(
        from url: URL,
        with options: OpenFileOption
    ) throws -> FileHandle {
        let actualOperation = try inferActualOpenOperation(from: url, with: options)
        if actualOperation == .create {
            self.createFile(atPath: url.compactPath(), contents: nil)
        }
        let handle = try FileHandle(forWritingTo: url)
        if actualOperation == .truncate {
            try handle.truncate(atOffset: 0)
        }
        return handle
    }
    
    
    private func makeUpdatingHandle(
        from url: URL,
        with options: OpenFileOption
    ) throws -> FileHandle {
        let actualOperation = try inferActualOpenOperation(from: url, with: options)
        if actualOperation == .create {
            self.createFile(atPath: url.compactPath(), contents: nil)
        }
        let handle = try FileHandle(forUpdating: url)
        if actualOperation == .truncate {
            try handle.truncate(atOffset: 0)
        }
        return handle
    }
    
    
    /// Create a file handle for reading the file at the specific url
    /// - Parameter url: The url of the file to create the file handle
    /// - Returns: The file handle
    ///
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    public func openFile(forReadingFrom url: URL) async throws -> FileHandle {
        try await Self.runOnIOQueue {
            Self.assertOnIOQueue()
            return try .init(forReadingFrom: url)
        }
    }
    
    
    /// Create a file handle for reading the file at the specific url
    /// - Parameters:
    ///   - url: The url of the file to create the file handle
    ///   - operation: operations on the file handle
    ///
    /// - Warning: Any operation on the file handle MUST happen within the `operation` closure.
    /// NEVER try to pass the handle outside the closure
    ///
    /// - Attention: The handle will automatically be closed after the closure returns, so no
    /// need to close it manually
    ///
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    public func withFileHandle<R: Sendable>(
        forReadingFrom url: URL,
        operation: @Sendable @escaping (FileHandle) throws -> R
    ) async throws -> R {
        try await Self.runOnIOQueue {
            Self.assertOnIOQueue()
            let handle = try FileHandle(forReadingFrom: url)
            defer { try? handle.close() }
            return try operation(handle)
        }
    }
    
    
    /// Create a file handle for reading the file at the specific url
    /// - Parameters:
    ///   - url: The url of the file to create the file handle
    ///   - operation: operations on the file handle
    ///
    /// - Warning: Any operation on the file handle MUST happen within the `operation` closure.
    /// NEVER try to pass the handle outside the closure
    ///
    /// - Attention: The handle will automatically be closed after the closure returns, so no
    /// need to close it manually
    ///
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    public func withFileHandle<R>(
        forReadingFrom url: URL,
        operation: (FileHandle) async throws -> R
    ) async throws -> R {
        try await withTaskExecutorPreference(.defaultExecutor.io) {
            Self.assertOnIOQueue()
            let handle = try FileHandle(forReadingFrom: url)
            defer { try? handle.close() }
            return try await operation(handle)
        }
    }
    
    
    /// Create a file handle for writing to the file at the specified url
    /// - Parameter url: The url of the file to create the file handle
    /// - Returns: The file handle
    ///
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    public func openFile(
        forWritingTo url: URL,
        options: OpenFileOption = .modifyFile(createIfNeeded: false)
    ) async throws -> FileHandle {
        try await Self.runOnIOQueue {
            Self.assertOnIOQueue()
            return try self.makeWritingHandle(from: url, with: options)
        }
    }
    
    
    /// Create a file handle for writing to the file at the specific url
    /// - Parameters:
    ///   - url: The url of the file to create the file handle
    ///   - operation: operations on the file handle
    ///
    /// - Warning: Any operation on the file handle MUST happen within the `operation` closure.
    /// NEVER try to pass the handle outside the closure
    ///
    /// - Attention: The handle will automatically be closed after the closure returns, so no
    /// need to close it manually
    ///
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    public func withFileHandle<R: Sendable>(
        forWritingTo url: URL,
        options: OpenFileOption = .modifyFile(createIfNeeded: false),
        operation: @Sendable @escaping (FileHandle) throws -> R
    ) async throws -> R {
        
        try await Self.runOnIOQueue {
            
            Self.assertOnIOQueue()
            
            let handle = try self.makeWritingHandle(from: url, with: options)
            defer { try? handle.close() }
            
            return try operation(handle)
            
        }
        
    }
    
    
    /// Create a file handle for writing to the file at the specific url
    /// - Parameters:
    ///   - url: The url of the file to create the file handle
    ///   - operation: operations on the file handle
    ///
    /// - Warning: Any operation on the file handle MUST happen within the `operation` closure.
    /// NEVER try to pass the handle outside the closure
    ///
    /// - Attention: The handle will automatically be closed after the closure returns, so no
    /// need to close it manually
    ///
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    public func withFileHandle<R>(
        forWritingTo url: URL,
        options: OpenFileOption = .modifyFile(createIfNeeded: false),
        operation: (FileHandle) async throws -> R
    ) async throws -> R {
        
        try await withTaskExecutorPreference(.defaultExecutor.io) {
            
            Self.assertOnIOQueue()
            
            let handle = try self.makeWritingHandle(from: url, with: options)
            defer { try? handle.close() }
            
            return try await operation(handle)
            
        }
        
    }
    
    
    /// Create a file handle for reading and writing to the file at the specific url
    /// - Parameter url: The url of the file to create the file handle
    /// - Returns: The file handle
    ///
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    public func openFile(
        forUpdating url: URL,
        options: OpenFileOption = .modifyFile(createIfNeeded: false)
    ) async throws -> FileHandle {
        try await Self.runOnIOQueue {
            Self.assertOnIOQueue()
            return try self.makeUpdatingHandle(from: url, with: options)
        }
    }
    
    
    /// Create a file handle for reading and writing to the file at the specific url
    /// - Parameters:
    ///   - url: The url of the file to create the file handle
    ///   - operation: operations on the file handle
    ///
    /// - Warning: Any operation on the file handle MUST happen within the `operation` closure.
    /// NEVER try to pass the handle outside the closure
    ///
    /// - Attention: The handle will automatically be closed after the closure returns, so no
    /// need to close it manually
    ///
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    public func withFileHandle<R: Sendable>(
        forUpdating url: URL,
        options: OpenFileOption = .modifyFile(createIfNeeded: false),
        operation: @escaping (FileHandle) throws -> R
    ) async throws -> R {
        
        try await Self.runOnIOQueue {
            
            Self.assertOnIOQueue()
            
            let handle = try self.makeUpdatingHandle(from: url, with: options)
            defer { try? handle.close() }
            
            return try operation(handle)
            
        }
        
    }
    
    
    /// Create a file handle for reading and writing to the file at the specific url
    /// - Parameters:
    ///   - url: The url of the file to create the file handle
    ///   - operation: operations on the file handle
    ///
    /// - Warning: Any operation on the file handle MUST happen within the `operation` closure.
    /// NEVER try to pass the handle outside the closure
    ///
    /// - Attention: The handle will automatically be closed after the closure returns, so no
    /// need to close it manually
    ///
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    public func withFileHandle<R>(
        forUpdating url: URL,
        options: OpenFileOption = .modifyFile(createIfNeeded: false),
        operation: (FileHandle) async throws -> R
    ) async throws -> R {
        
        try await withTaskExecutorPreference(.defaultExecutor.io) {
            
            Self.assertOnIOQueue()
            
            let handle = try self.makeUpdatingHandle(from: url, with: options)
            defer { try? handle.close() }
            
            return try await operation(handle)
            
        }
        
    }
    
}
