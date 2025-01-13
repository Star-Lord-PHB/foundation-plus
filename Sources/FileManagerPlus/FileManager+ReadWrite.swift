import Foundation
import SystemPackage


extension FileManager {

    /// Read the content of the file at the specified path 
    public func contents(at path: FilePath) throws -> Data {
        try Data(contentsOf: path.toURL())
    }


    /// Read the content of the file at the specified url
    public func contents(at url: URL) throws -> Data {
        try Data(contentsOf: url)
    }


    /// Write data into the file at the specified path
    /// - Parameters:
    ///   - content: The data to be written into the file
    ///   - path: The path of the file that the data will be written into
    ///   - replaceExisting: Whether to replace existing file, default to `true`
    public func write(_ content: Data, to path: FilePath, replaceExisting: Bool = true) throws {
        try content.write(to: path.toURL(), options: replaceExisting ? [] : .withoutOverwriting)
    }


    /// Write data into the file at the specified url
    /// - Parameters:
    ///   - content: The data to be written into the file
    ///   - url: The url of the file that the data will be written into
    ///   - replaceExisting: Whether to replace existing file, default to `true`
    public func write(_ content: Data, to url: URL, replaceExisting: Bool = true) throws {
        try content.write(to: url, options: replaceExisting ? [] : .withoutOverwriting)
    }


    /// Append data into the file at the specified path
    /// - Parameters:
    ///   - content: The data to be appended into the file
    ///   - path: The path of the file that the data will be appended to
    public func append(_ content: Data, to path: FilePath) throws {
        let handle = try FileHandle(forWritingTo: path)
        defer { try? handle.close() }
        if #available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *) {
            try handle.seekToEnd()
            try handle.write(contentsOf: content)
        } else {
            handle.seekToEndOfFile()
            handle.write(content)
        }
    }


    /// Append data into the file at the specified url
    /// - Parameters:
    ///   - content: The data to be appended into the file
    ///   - url: The url of the file that the data will be appended to
    public func append(_ content: Data, to url: URL) throws {
        let handle = try FileHandle(forWritingTo: url)
        defer { try? handle.close() }
        if #available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *) {
            try handle.seekToEnd()
            try handle.write(contentsOf: content)
        } else {
            handle.seekToEndOfFile()
            handle.write(content)
        }
    }


    /// Get entries of the directory at the specified path as an array of FilePaths
    /// - Parameters:
    ///   - path: The path of the directory
    ///   - options: Options for enumerating the directory 
    public func contentsOfDirectory(
        at path: FilePath,
        options: DirectoryEnumerationOptions = []
    ) throws -> [FilePath] {
        try self.contentsOfDirectory(at: path.toURL(), includingPropertiesForKeys: nil, options: options)
            .map { try $0.assertAsFilePath() }
    }

}



extension FileManager {

    // MARK: TODO
    final class FilePathdDirectoryEnumerator: Sequence, AsyncSequence, AsyncIteratorProtocol, IteratorProtocol {

        public typealias AsyncIterator = FilePathdDirectoryEnumerator 

        private let enumerator: FileManager.DirectoryEnumerator

        public var level: Int { enumerator.level }
#if canImport(Darwin)
        public var isEnumeratingDirectoryPostOrder: Bool { enumerator.isEnumeratingDirectoryPostOrder }
#endif

        init(enumerator: FileManager.DirectoryEnumerator) {
            self.enumerator = enumerator
        }

        public func makeAsyncIterator() -> FileManager.FilePathdDirectoryEnumerator { self }

        public func next() -> FilePath? {
            enumerator.nextObject().flatMap { $0 as? URL }.flatMap { $0.toFilePath() }
        }

        public func next() async throws -> FilePath? {
            enumerator.nextObject().flatMap { $0 as? URL }.flatMap { $0.toFilePath() }
        }

        public func skipDescendants() {
            enumerator.skipDescendants()
        }

        public func skipDescendents() {
            enumerator.skipDescendants()
        }

    }


    // MARK: TODO
    final class URLDirectoryEnumerator: Sequence, IteratorProtocol {

        private let enumerator: FileManager.DirectoryEnumerator

        public var level: Int { enumerator.level }
#if canImport(Darwin)
        public var isEnumeratingDirectoryPostOrder: Bool { enumerator.isEnumeratingDirectoryPostOrder }
#endif

        init(enumerator: FileManager.DirectoryEnumerator) {
            self.enumerator = enumerator
        }

        public func next() -> URL? {
            enumerator.nextObject() as? URL
        }

        public func skipDescendants() {
            enumerator.skipDescendants()
        }

        public func skipDescendents() {
            enumerator.skipDescendants()
        }

    }

}



extension FileManager {

    /// Read the content of the file at the specified path 
    /// 
    /// - Note: This operation will automatically be executed on
    /// ``FoundationPlusTaskExecutor/io`` executor
    public func contents(at path: FilePath) async throws -> Data {
        try await Self.runOnIOQueue {
            try self.contents(at: path)
        }
    }

    
    /// Read the content of the file at the specified url
    ///
    /// - Note: This operation will automatically be executed on
    /// ``FoundationPlusTaskExecutor/io`` executor
    public func contents(at url: URL) async throws -> Data {
        try await Self.runOnIOQueue {
            try self.contents(at: url)
        }
    }


    /// Write data into the file at the specified path
    /// - Parameters:
    ///   - content: The data to be written into the file
    ///   - path: The path of the file that the data will be written into
    ///   - replaceExisting: Whether to replace existing file, default to `true`
    /// 
    /// - Note: This operation will automatically be executed on
    /// ``FoundationPlusTaskExecutor/io`` executor
    public func write(_ content: Data, to path: FilePath, replaceExisting: Bool = true) async throws {
        try await Self.runOnIOQueue {
            try self.write(content, to: path, replaceExisting: replaceExisting)
        }
    }
    
    
    /// Write data into the file at the specified url
    /// - Parameters:
    ///   - content: The data to be written into the file
    ///   - url: The url of the file that the data will be written into
    ///   - replaceExisting: Whether to replace existing file, default to `true`
    /// 
    /// - Note: This operation will automatically be executed on
    /// ``FoundationPlusTaskExecutor/io`` executor
    public func write(_ content: Data, to url: URL, replaceExisting: Bool = true) async throws {
        try await Self.runOnIOQueue {
            try self.write(content, to: url, replaceExisting: replaceExisting)
        }
    }


    /// Append data into the file at the specified path
    /// - Parameters:
    ///   - content: The data to be appended into the file
    ///   - path: The path of the file that the data will be appended to
    /// 
    /// - Note: This operation will automatically be executed on
    /// ``FoundationPlusTaskExecutor/io`` executor
    public func append(_ content: Data, to path: FilePath) async throws {
        try await Self.runOnIOQueue {
            try self.append(content, to: path)
        }
    }
    
    
    /// Append data into the file at the specified url
    /// - Parameters:
    ///   - content: The data to be appended into the file
    ///   - url: The url of the file that the data will be appended to
    ///
    /// - Note: This operation will automatically be executed on
    /// ``FoundationPlusTaskExecutor/io`` executor
    public func append(_ content: Data, to url: URL) async throws {
        try await Self.runOnIOQueue {
            try self.append(content, to: url)
        }
    }


    /// Get entries of the directory at the specified path as an array of FilePaths
    /// - Parameters:
    ///   - path: The path of the directory
    ///   - options: Options for enumerating the directory 
    /// 
    /// - Note: This operation will automatically be executed on
    /// ``FoundationPlusTaskExecutor/io`` executor
    public func contentsOfDirectory(
        at path: FilePath,
        options: DirectoryEnumerationOptions = []
    ) async throws -> [FilePath] {
        try await Self.runOnIOQueue {
            try self.contentsOfDirectory(at: path, options: options)
        }
    }
    
    
    /// Get entries of the directory at the specified path as an array of FilePaths
    /// - Parameters:
    ///   - path: The path of the directory
    ///   - options: Options for enumerating the directory 
    ///
    /// - Note: This operation will automatically be executed on
    /// ``FoundationPlusTaskExecutor/io`` executor
    public func contentsOfDirectory(
        at url: URL,
        options: DirectoryEnumerationOptions = []
    ) async throws -> [URL] {
        try await Self.runOnIOQueue {
            try self.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: options)
        }
    }
    
}
