import Foundation


@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension FileManager {
    
    /// Read the content of the file at the provided `URL` and return as `Data`
    /// - Parameter url: The `URL` of the resource to be read
    /// - Returns: The content of the file at the url
    ///
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    public func contents(at url: URL) async throws -> Data {
        try await Self.runOnIOQueue {
            try Data(contentsOf: url)
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
            try content.write(to: url, options: replaceExisting ? [] : .withoutOverwriting)
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
            
            Self.assertOnIOQueue()
            
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
        
    }
    
    
    /// Get entries of the directory at the specified url as an array of urls
    /// - Parameter url: The url of the directory
    /// - Returns: Entries of the directory as an array of urls
    ///
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    public func directoryEntries(
        at url: URL,
        options: DirectoryEnumerationOptions = []
    ) async throws -> [URL] {
        
        try await Self.runOnIOQueue {
            Self.assertOnIOQueue()
            return try self.contentsOfDirectory(
                at: url,
                includingPropertiesForKeys: nil,
                options: options
            )
        }
        
    }
    
}
