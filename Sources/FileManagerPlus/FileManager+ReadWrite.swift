import Foundation
import SystemPackage


extension FileManager {

    public func contents(at path: FilePath) throws -> Data {
        try Data(contentsOf: path.toURL())
    }


    public func contents(at url: URL) throws -> Data {
        try Data(contentsOf: url)
    }


    public func write(_ content: Data, to path: FilePath, replaceExisting: Bool = true) throws {
        try content.write(to: path.toURL(), options: replaceExisting ? [] : .withoutOverwriting)
    }


    public func write(_ content: Data, to url: URL, replaceExisting: Bool = true) throws {
        try content.write(to: url, options: replaceExisting ? [] : .withoutOverwriting)
    }


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


    public func contentsOfDirectory(
        at path: FilePath,
        options: DirectoryEnumerationOptions = []
    ) throws -> [FilePath] {
        try self.contentsOfDirectory(at: path.toURL(), includingPropertiesForKeys: nil, options: options)
            .map { try $0.assertAsFilePath() }
    }

}


extension FileManager {

    public final class FilePathdDirectoryEnumerator: Sequence, AsyncSequence, AsyncIteratorProtocol, IteratorProtocol {

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


    public final class URLDirectoryEnumerator: Sequence, IteratorProtocol {

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


@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension FileManager {

    public func contents(at path: FilePath) async throws -> Data {
        try await Self.runOnIOQueue {
            try self.contents(at: path)
        }
    }

    
    /// Read the content of the file at the provided `URL` and return as `Data`
    /// - Parameter url: The `URL` of the resource to be read
    /// - Returns: The content of the file at the url
    ///
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    public func contents(at url: URL) async throws -> Data {
        try await Self.runOnIOQueue {
            try self.contents(at: url)
        }
    }


    public func write(_ content: Data, to path: FilePath, replaceExisting: Bool = true) async throws {
        try await Self.runOnIOQueue {
            try self.write(content, to: path, replaceExisting: replaceExisting)
        }
    }
    
    
    /// Write the provided data into the file at the provided `URL`
    /// - Parameters:
    ///   - content: The content to be written
    ///   - url: The url of the file that the data will be written into
    ///   - replaceExisting: Whether to replace the existing file, default is `true`
    ///
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    public func write(_ content: Data, to url: URL, replaceExisting: Bool = true) async throws {
        try await Self.runOnIOQueue {
            try self.write(content, to: url, replaceExisting: replaceExisting)
        }
    }


    public func append(_ content: Data, to path: FilePath) async throws {
        try await Self.runOnIOQueue {
            try self.append(content, to: path)
        }
    }
    
    
    /// Append the provided data into the file at the provided url
    /// - Parameters:
    ///   - content: The content to be appended into the file
    ///   - url: The url of the file that the content will be appended to
    ///
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    public func append(_ content: Data, to url: URL) async throws {
        try await Self.runOnIOQueue {
            try self.append(content, to: url)
        }
    }


    public func contentsOfDirectory(
        at path: FilePath,
        options: DirectoryEnumerationOptions = []
    ) async throws -> [FilePath] {
        try await Self.runOnIOQueue {
            try self.contentsOfDirectory(at: path, options: options)
        }
    }
    
    
    /// Get entries of the directory at the specified url as an array of urls
    /// - Parameter url: The url of the directory
    /// - Returns: Entries of the directory as an array of urls
    ///
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    public func contentsOfDirectory(
        at url: URL,
        options: DirectoryEnumerationOptions = []
    ) async throws -> [URL] {
        try await Self.runOnIOQueue {
            try self.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: options)
        }
    }
    
}
