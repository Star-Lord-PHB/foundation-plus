//
//  FileHandle+Creation.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/7/31.
//

import Foundation
import SystemPackage



extension FileManager {

    /// Options for opening a file
    /// 
    /// - Note: The implementation is based on https://github.com/apple/swift-nio/blob/main/Sources/NIOFileSystem/OpenOptions.swift
    public struct OpenFileOption: Sendable {
        /// Whether to create a new file if the file does not exist
        public let newFile: Bool
        /// How to handle existed file
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
    /// 
    /// - Note: The implementation is based on https://github.com/apple/swift-nio/blob/main/Sources/NIOFileSystem/OpenOptions.swift
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
        try self.inferActualOpenOperation(from: url.assertAsFilePath(), with: options)
    }


    private func inferActualOpenOperation(
        from path: FilePath,
        with options: OpenFileOption
    ) throws -> OpenFileActualOperation {
        if self.fileExists(atPath: path.string) {
            switch options.existingFile {
                case .open: .openDirectly
                case .error: throw CocoaError.fileError(.fileWriteFileExists, path: path)
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
        from path: FilePath,
        with options: OpenFileOption
    ) throws -> FileHandle {
        let actualOperation = try inferActualOpenOperation(from: path, with: options)
        if actualOperation == .create {
            let _ = self.createFile(atPath: path.string, contents: nil)
        }
        let handle = try FileHandle(forWritingTo: path)
        if actualOperation == .truncate {
            try handle.truncate(atOffset: 0)
        }
        return handle
    }
    
    
    private func makeUpdatingHandle(
        from path: FilePath,
        with options: OpenFileOption
    ) throws -> FileHandle {
        let actualOperation = try inferActualOpenOperation(from: path, with: options)
        if actualOperation == .create {
            let _ = self.createFile(atPath: path.string, contents: nil)
        }
        let handle = try FileHandle(forUpdating: path)
        if actualOperation == .truncate {
            try handle.truncate(atOffset: 0)
        }
        return handle
    }

}


extension FileManager {

    /// Open a file handle for reading the file at the specified file path.
    public func openFile(forReadingFrom path: FilePath) throws -> FileHandle {
        try .init(forReadingFrom: path)
    }


    /// Open a file handle for reading the file at the specified url.
    public func openFile(forReadingFrom url: URL) throws -> FileHandle {
        try .init(forReadingFrom: url)
    }


    /// Open a file handle for reading the file at the specified file path, and use
    /// it immediately in the operation closure.
    /// 
    /// - Warning: DO NOT pass the file handle outside the closure
    public func withFileHandle<R>(
        forReadingFrom path: FilePath,
        operation: (FileHandle) throws -> R
    ) throws -> R {
        let handle = try FileHandle(forReadingFrom: path)
        defer {  try? handle.close() }
        return try operation(handle)
    }


    /// Open a file handle for reading the file at the specified url, and use
    /// it immediately in the operation closure.
    /// 
    /// - Warning: DO NOT pass the file handle outside the closure
    public func withFileHandle<R>(
        forReadingFrom url: URL,
        operation: (FileHandle) throws -> R
    ) throws -> R {
        try self.withFileHandle(forReadingFrom: url.assertAsFilePath(), operation: operation)
    }


    /// Open a file handle for writing to the file at the specified file path.
    /// - Parameters:
    ///   - path: The file path of the file to open
    ///   - options: Options for opening the file. 
    ///     By default, it will open the file directly and throw an error if the file does not exist
    public func openFile(
        forWritingTo path: FilePath,
        options: OpenFileOption = .modifyFile(createIfNeeded: false)
    ) throws -> FileHandle {
        try self.makeWritingHandle(from: path, with: options)
    }


    /// Open a file handle for writing to the file at the specified url.
    /// - Parameters:
    ///   - url: The url of the file to open
    ///   - options: Options for opening the file. 
    ///    By default, it will open the file directly and throw an error if the file does not exist
    public func openFile(
        forWritingTo url: URL,
        options: OpenFileOption = .modifyFile(createIfNeeded: false)
    ) throws -> FileHandle {
        try self.makeWritingHandle(from: url.assertAsFilePath(), with: options)
    }


    /// Open a file handle for writing to the file at the specified file path, and use
    /// it immediately in the operation closure.
    /// - Parameters:
    ///   - path: The file path of the file to open
    ///   - options: Options for opening the file.
    ///   - operation: The operation to perform with the file handle
    /// 
    /// - Warning: DO NOT pass the file handle outside the closure
    public func withFileHandle<R>(
        forWritingTo path: FilePath,
        options: OpenFileOption = .modifyFile(createIfNeeded: false),
        operation: (FileHandle) throws -> R
    ) throws -> R {
        let handle = try self.makeWritingHandle(from: path, with: options)
        defer { try? handle.close() }
        return try operation(handle)
    }


    /// Open a file handle for writing to the file at the specified url, and use
    /// it immediately in the operation closure.
    /// - Parameters:
    ///   - url: The url of the file to open
    ///   - options: Options for opening the file.
    ///   - operation: The operation to perform with the file handle
    /// 
    /// - Warning: DO NOT pass the file handle outside the closure
    public func withFileHandle<R>(
        forWritingTo url: URL,
        options: OpenFileOption = .modifyFile(createIfNeeded: false),
        operation: (FileHandle) throws -> R
    ) throws -> R {
        try self.withFileHandle(forWritingTo: url.assertAsFilePath(), options: options, operation: operation)
    }


    /// Open a file handle for updating the file at the specified file path.
    /// - Parameters:
    ///   - path: The file path of the file to open
    ///   - options: Options for opening the file.
    ///     By default, it will open the file directly and throw an error if the file does not exist
    public func openFile(
        forUpdating path: FilePath,
        options: OpenFileOption = .modifyFile(createIfNeeded: false)
    ) throws -> FileHandle {
        try self.makeUpdatingHandle(from: path, with: options)
    }


    /// Open a file handle for updating the file at the specified url.
    /// - Parameters:
    ///   - url: The url of the file to open
    ///   - options: Options for opening the file.
    ///     By default, it will open the file directly and throw an error if the file does not exist
    public func openFile(
        forUpdating url: URL,
        options: OpenFileOption = .modifyFile(createIfNeeded: false)
    ) throws -> FileHandle {
        try self.makeUpdatingHandle(from: url.assertAsFilePath(), with: options)
    }


    /// Open a file handle for updating the file at the specified file path, and use
    /// it immediately in the operation closure.
    /// - Parameters:
    ///   - path: The file path of the file to open
    ///   - options: Options for opening the file.
    ///   - operation: The operation to perform with the file handle
    ///
    /// - Warning: DO NOT pass the file handle outside the closure 
    public func withFileHandle<R>(
        forUpdating path: FilePath,
        options: OpenFileOption = .modifyFile(createIfNeeded: false),
        operation: (FileHandle) throws -> R
    ) throws -> R {
        let handle = try self.makeUpdatingHandle(from: path, with: options)
        defer { try? handle.close() }
        return try operation(handle)
    }


    /// Open a file handle for updating the file at the specified url, and use
    /// it immediately in the operation closure.
    /// - Parameters:
    ///   - url: The url of the file to open
    ///   - options: Options for opening the file.
    ///   - operation: The operation to perform with the file handle
    ///
    /// - Warning: DO NOT pass the file handle outside the closure 
    public func withFileHandle<R>(
        forUpdating url: URL,
        options: OpenFileOption = .modifyFile(createIfNeeded: false),
        operation: (FileHandle) throws -> R
    ) throws -> R {
        try self.withFileHandle(forUpdating: url.assertAsFilePath(), options: options, operation: operation)
    }

}



@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension FileManager {

    /// Open a file handle for reading the file at the specified file path.
    /// 
    /// - Note: This operation will automatically be executed on
    /// ``FoundationPlusTaskExecutor/io`` executor
    public func openFile(forReadingFrom path: FilePath) async throws -> FileHandle {
        try await Self.runOnIOQueue {
            try .init(forReadingFrom: path)
        }
    }

    
    /// Open a file handle for reading the file at the specified url.
    ///
    /// - Note: This operation will automatically be executed on
    /// ``FoundationPlusTaskExecutor/io`` executor
    public func openFile(forReadingFrom url: URL) async throws -> FileHandle {
        try await Self.runOnIOQueue {
            try .init(forReadingFrom: url)
        }
    }


    /// Open a file handle for reading the file at the specified file path, and use
    /// it immediately in the operation closure.
    /// 
    /// - Warning: DO NOT pass the file handle outside the closure
    /// 
    /// - Note: This operation will automatically be executed
    /// on ``FoundationPlusTaskExecutor/io`` executor
    public func withFileHandle<R>(
        forReadingFrom path: FilePath,
        operation: @escaping (FileHandle) throws -> R
    ) async throws -> R {
        try await Self.runOnIOQueue {
            let handle = try FileHandle(forReadingFrom: path)
            defer { try? handle.close() }
            return try operation(handle)
        }
    }


    /// Open a file handle for reading the file at the specified file path, and use
    /// it immediately in the operation closure.
    /// 
    /// - Warning: DO NOT pass the file handle outside the closure
    /// 
    /// - Note: This operation will automatically be executed
    /// on ``FoundationPlusTaskExecutor/io`` executor
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    public func withFileHandle<R>(
        forReadingFrom path: FilePath,
        operation: (FileHandle) async throws -> R
    ) async throws -> R {
        try await withTaskExecutorPreference(.foundationPlusTaskExecutor.io) {
            let handle = try FileHandle(forReadingFrom: path)
            defer { try? handle.close() }
            return try await operation(handle)
        }
    }
    
    
    /// Open a file handle for reading the file at the specified file path, and use
    /// it immediately in the operation closure.
    /// 
    /// - Warning: DO NOT pass the file handle outside the closure
    /// 
    /// - Note: This operation will automatically be executed
    /// on ``FoundationPlusTaskExecutor/io`` executor
    public func withFileHandle<R>(
        forReadingFrom url: URL,
        operation: @escaping (FileHandle) throws -> R
    ) async throws -> R {
        try await Self.runOnIOQueue {
            let handle = try FileHandle(forReadingFrom: url)
            defer { try? handle.close() }
            return try operation(handle)
        }
    }


    /// Open a file handle for reading the file at the specified file path, and use
    /// it immediately in the operation closure.
    /// 
    /// - Warning: DO NOT pass the file handle outside the closure
    /// 
    /// - Note: This operation will automatically be executed
    /// on ``FoundationPlusTaskExecutor/io`` executor
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    public func withFileHandle<R>(
        forReadingFrom url: URL,
        operation: (FileHandle) async throws -> R
    ) async throws -> R {
        try await withTaskExecutorPreference(.foundationPlusTaskExecutor.io) {
            let handle = try FileHandle(forReadingFrom: url)
            defer { try? handle.close() }
            return try await operation(handle)
        }
    }


    /// Open a file handle for writing to the file at the specified file path.
    /// - Parameters:
    ///   - path: The file path of the file to open
    ///   - options: Options for opening the file. 
    ///     By default, it will open the file directly and throw an error if the file does not exist
    /// 
    /// - Note: This operation will automatically be executed
    /// on ``FoundationPlusTaskExecutor/io`` executor
    public func openFile(
        forWritingTo path: FilePath,
        options: OpenFileOption = .modifyFile(createIfNeeded: false)
    ) async throws -> FileHandle {
        try await Self.runOnIOQueue {
            try self.makeWritingHandle(from: path, with: options)
        }
    }
    
    
    /// Open a file handle for writing to the file at the specified url.
    /// - Parameters:
    ///   - url: The url of the file to open
    ///   - options: Options for opening the file. 
    ///    By default, it will open the file directly and throw an error if the file does not exist
    /// 
    /// - Note: This operation will automatically be executed
    /// on ``FoundationPlusTaskExecutor/io`` executor
    public func openFile(
        forWritingTo url: URL,
        options: OpenFileOption = .modifyFile(createIfNeeded: false)
    ) async throws -> FileHandle {
        try await Self.runOnIOQueue {
            try self.makeWritingHandle(from: url.assertAsFilePath(), with: options)
        }
    }


    /// Open a file handle for writing to the file at the specified file path, and use
    /// it immediately in the operation closure.
    /// - Parameters:
    ///   - path: The file path of the file to open
    ///   - options: Options for opening the file.
    ///   - operation: The operation to perform with the file handle
    /// 
    /// - Warning: DO NOT pass the file handle outside the closure
    /// 
    /// - Note: This operation will automatically be executed
    /// on ``FoundationPlusTaskExecutor/io`` executor
    public func withFileHandle<R>(
        forWritingTo path: FilePath,
        options: OpenFileOption = .modifyFile(createIfNeeded: false),
        operation: @escaping (FileHandle) throws -> R
    ) async throws -> R {
        try await Self.runOnIOQueue {
            let handle = try self.makeWritingHandle(from: path, with: options)
            defer { try? handle.close() }
            return try operation(handle)
        }
    }


    /// Open a file handle for writing to the file at the specified file path, and use
    /// it immediately in the operation closure.
    /// - Parameters:
    ///   - path: The file path of the file to open
    ///   - options: Options for opening the file.
    ///   - operation: The operation to perform with the file handle
    /// 
    /// - Warning: DO NOT pass the file handle outside the closure
    /// 
    /// - Note: This operation will automatically be executed
    /// on ``FoundationPlusTaskExecutor/io`` executor
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    public func withFileHandle<R>(
        forWritingTo path: FilePath,
        options: OpenFileOption = .modifyFile(createIfNeeded: false),
        operation: (FileHandle) async throws -> R
    ) async throws -> R {
        try await withTaskExecutorPreference(.foundationPlusTaskExecutor.io){
            let handle = try self.makeWritingHandle(from: path, with: options)
            defer { try? handle.close() }
            return try await operation(handle)
        }
    }
    
    
    /// Open a file handle for writing to the file at the specified url, and use
    /// it immediately in the operation closure.
    /// - Parameters:
    ///   - url: The url of the file to open
    ///   - options: Options for opening the file.
    ///   - operation: The operation to perform with the file handle
    /// 
    /// - Warning: DO NOT pass the file handle outside the closure
    ///
    /// - Note: This operation will automatically be executed on
    /// ``FoundationPlusTaskExecutor/io`` executor
    public func withFileHandle<R>(
        forWritingTo url: URL,
        options: OpenFileOption = .modifyFile(createIfNeeded: false),
        operation: @escaping (FileHandle) throws -> R
    ) async throws -> R {
        try await Self.runOnIOQueue {
            let handle = try self.makeWritingHandle(from: url.assertAsFilePath(), with: options)
            defer { try? handle.close() }
            return try operation(handle)
        }
    }


    /// Open a file handle for writing to the file at the specified url, and use
    /// it immediately in the operation closure.
    /// - Parameters:
    ///   - url: The url of the file to open
    ///   - options: Options for opening the file.
    ///   - operation: The operation to perform with the file handle
    /// 
    /// - Warning: DO NOT pass the file handle outside the closure
    ///
    /// - Note: This operation will automatically be executed on
    /// ``FoundationPlusTaskExecutor/io`` executor
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    public func withFileHandle<R>(
        forWritingTo url: URL,
        options: OpenFileOption = .modifyFile(createIfNeeded: false),
        operation: (FileHandle) async throws -> R
    ) async throws -> R {
        try await withTaskExecutorPreference(.foundationPlusTaskExecutor.io) {
            let handle = try self.makeWritingHandle(from: url.assertAsFilePath(), with: options)
            defer { try? handle.close() }
            return try await operation(handle)
        }
    }


    /// Open a file handle for updating the file at the specified file path.
    /// - Parameters:
    ///   - path: The file path of the file to open
    ///   - options: Options for opening the file.
    ///     By default, it will open the file directly and throw an error if the file does not exist
    ///
    /// - Note: This operation will automatically be executed on
    /// ``FoundationPlusTaskExecutor/io`` executor
    public func openFile(
        forUpdating path: FilePath,
        options: OpenFileOption = .modifyFile(createIfNeeded: false)
    ) async throws -> FileHandle {
        try await Self.runOnIOQueue {
            try self.makeUpdatingHandle(from: path, with: options)
        }
    }
    
    
    /// Open a file handle for updating the file at the specified url.
    /// - Parameters:
    ///   - url: The url of the file to open
    ///   - options: Options for opening the file.
    ///     By default, it will open the file directly and throw an error if the file does not exist
    ///
    /// - Note: This operation will automatically be executed on
    /// ``FoundationPlusTaskExecutor/io`` executor
    public func openFile(
        forUpdating url: URL,
        options: OpenFileOption = .modifyFile(createIfNeeded: false)
    ) async throws -> FileHandle {
        try await Self.runOnIOQueue {
            return try self.makeUpdatingHandle(from: url.assertAsFilePath(), with: options)
        }
    }


    /// Open a file handle for updating the file at the specified file path, and use
    /// it immediately in the operation closure.
    /// - Parameters:
    ///   - path: The file path of the file to open
    ///   - options: Options for opening the file.
    ///   - operation: The operation to perform with the file handle
    ///
    /// - Warning: DO NOT pass the file handle outside the closure 
    ///
    /// - Note: This operation will automatically be executed on
    /// ``FoundationPlusTaskExecutor/io`` executor
    public func withFileHandle<R>(
        forUpdating path: FilePath,
        options: OpenFileOption = .modifyFile(createIfNeeded: false),
        operation: @escaping (FileHandle) throws -> R
    ) async throws -> R {
        try await Self.runOnIOQueue {
            let handle = try self.makeUpdatingHandle(from: path, with: options)
            defer { try? handle.close() }
            return try operation(handle)
        }
    }


    /// Open a file handle for updating the file at the specified file path, and use
    /// it immediately in the operation closure.
    /// - Parameters:
    ///   - path: The file path of the file to open
    ///   - options: Options for opening the file.
    ///   - operation: The operation to perform with the file handle
    ///
    /// - Warning: DO NOT pass the file handle outside the closure 
    ///
    /// - Note: This operation will automatically be executed on
    /// ``FoundationPlusTaskExecutor/io`` executor
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    public func withFileHandle<R>(
        forUpdating path: FilePath,
        options: OpenFileOption = .modifyFile(createIfNeeded: false),
        operation: (FileHandle) async throws -> R
    ) async throws -> R {
        try await withTaskExecutorPreference(.foundationPlusTaskExecutor.io) {
            let handle = try self.makeUpdatingHandle(from: path, with: options)
            defer { try? handle.close() }
            return try await operation(handle)
        }
    }
    
    
    /// Open a file handle for updating the file at the specified url, and use
    /// it immediately in the operation closure.
    /// - Parameters:
    ///   - url: The url of the file to open
    ///   - options: Options for opening the file.
    ///   - operation: The operation to perform with the file handle
    ///
    /// - Warning: DO NOT pass the file handle outside the closure 
    ///
    /// - Note: This operation will automatically be executed on
    /// ``FoundationPlusTaskExecutor/io`` executor
    public func withFileHandle<R>(
        forUpdating url: URL,
        options: OpenFileOption = .modifyFile(createIfNeeded: false),
        operation: @escaping (FileHandle) throws -> R
    ) async throws -> R {
        try await Self.runOnIOQueue {
            let handle = try self.makeUpdatingHandle(from: url.assertAsFilePath(), with: options)
            defer { try? handle.close() }
            return try operation(handle)
        }
    }


    /// Open a file handle for updating the file at the specified url, and use
    /// it immediately in the operation closure.
    /// - Parameters:
    ///   - url: The url of the file to open
    ///   - options: Options for opening the file.
    ///   - operation: The operation to perform with the file handle
    ///
    /// - Warning: DO NOT pass the file handle outside the closure 
    ///
    /// - Note: This operation will automatically be executed on
    /// ``FoundationPlusTaskExecutor/io`` executor
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    public func withFileHandle<R>(
        forUpdating url: URL,
        options: OpenFileOption = .modifyFile(createIfNeeded: false),
        operation: (FileHandle) async throws -> R
    ) async throws -> R {
        try await withTaskExecutorPreference(.foundationPlusTaskExecutor.io) {
            let handle = try self.makeUpdatingHandle(from: url.assertAsFilePath(), with: options)
            defer { try? handle.close() }
            return try await operation(handle)
        }
    }
    
}