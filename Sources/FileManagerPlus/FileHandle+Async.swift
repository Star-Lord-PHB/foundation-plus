//
//  FileHandle.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/7/29.
//

import Foundation



@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension FileHandle {
    
    /// Returns a file handle initialized for reading the file, device, or named socket
    /// at the specified path.
    ///
    /// - Seealso: [`init(forReadingAtPath:)`](https://developer.apple.com/documentation/foundation/filehandle/1408422-init)
    public static func open(forReadingAtPath path: String) async -> FileHandle? {
        await FileManager.runOnIOQueue {
            .init(forReadingAtPath: path)
        }
    }
    
    
    /// Returns a file handle initialized for reading the file, device, or named socket
    /// at the specified URL.
    ///
    /// - Seealso: [`init(forReadingFrom:)`](https://developer.apple.com/documentation/foundation/filehandle/1408422-init)
    public static func open(forReadingFrom url: URL) async throws -> FileHandle {
        try await FileManager.runOnIOQueue {
            try .init(forReadingFrom: url)
        }
    }
    
    
    /// Returns a file handle initialized for writing to the file, device, or named socket
    /// at the specified path.
    ///
    /// - Seealso: [`init(forWritingAtPath:)`](https://developer.apple.com/documentation/foundation/filehandle/1414405-init)
    public static func open(forWritingAtPath path: String) async -> FileHandle? {
        await FileManager.runOnIOQueue {
            .init(forWritingAtPath: path)
        }
    }
    
    
    /// Returns a file handle initialized for writing to the file, device, or named socket
    /// at the specified URL.
    ///
    /// - Seealso: [`init(forWritingTo:)`](https://developer.apple.com/documentation/foundation/filehandle/1416892-init)
    public static func open(forWritingTo url: URL) async throws -> FileHandle {
        try await FileManager.runOnIOQueue {
            try .init(forWritingTo: url)
        }
    }
    
    
    /// Returns a file handle initialized for reading and writing to the file, device, or named socket
    /// at the specified path.
    ///
    /// - Seealso: [`init(forUpdatingAtPath:)`](https://developer.apple.com/documentation/foundation/filehandle/1411131-init)
    public static func open(forUpdatingAtPath path: String) async -> FileHandle? {
        await FileManager.runOnIOQueue {
            .init(forUpdatingAtPath: path)
        }
    }
    
    
    /// Returns a file handle initialized for reading and writing to the file, device, or named socket
    /// at the specified URL.
    ///
    /// - Seealso: [`init(forUpdating:)`]
    public static func open(forUpdating url: URL) async throws -> FileHandle {
        try await FileManager.runOnIOQueue {
            try .init(forUpdating: url)
        }
    }
    
}


@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension FileHandle {
    
    /// The data currently available in the receiver.
    ///
    /// - Seealso: [`availableData`](https://developer.apple.com/documentation/foundation/filehandle/1411463-availabledata)
    public var availableDataAsync: Data {
        get async {
            await FileManager.runOnIOQueue { self.availableData }
        }
    }
    
    
    /// Moves the file pointer to the specified offset within the file.
    ///
    /// - Seealso: [`seek(toOffset:)`](https://developer.apple.com/documentation/foundation/filehandle/3172530-seek)
    public func seekAsync(to offset: UInt64) async throws {
        try await FileManager.runOnIOQueue {
            try self.seek(toOffset: offset)
        }
    }
    
    /// Truncates or extends the file represented by the file handle to a specified offset within the file and puts the file pointer at that position.
    ///
    /// - Seealso: [`truncate(atOffset:)`](https://developer.apple.com/documentation/foundation/filehandle/3172532-truncate)
    public func truncateAsync(at offset: UInt64) async throws {
        try await FileManager.runOnIOQueue {
            try self.truncate(atOffset: offset)
        }
    }
    
    
    /// Causes all in-memory data and attributes of the file represented by the file handle to write to permanent storage.
    ///
    /// - Seealso: [`synchronize()`](https://developer.apple.com/documentation/foundation/filehandle/3172531-synchronize)
    public func synchronizeAsync() async throws {
        try await FileManager.runOnIOQueue {
            try self.synchronize()
        }
    }
    
    
    /// Disallows further access to the represented file or communications channel and signals end of file on communications channels that permit writing.
    ///
    /// - Seealso: [`close()`](https://developer.apple.com/documentation/foundation/filehandle/3172525-close)
    public func closeAsync() async throws {
        try await FileManager.runOnIOQueue {
            try self.close()
        }
    }
    
    
    /// Reads the available data synchronously up to the end of file or maximum number of bytes.
    ///
    /// - Seealso: [`readToEnd()`](https://developer.apple.com/documentation/foundation/filehandle/3516318-readtoend)
    @available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *)
    public func readToEndAsync() async throws -> Data? {
        try await FileManager.runOnIOQueue {
            try self.readToEnd()
        }
    }
    
    
    /// Reads data synchronously up to the specified number of bytes.
    ///
    /// - Seealso: [`read(upToCount:)`](https://developer.apple.com/documentation/foundation/filehandle/3516317-read)
    @available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *)
    public func readAsync(upToCount count: Int) async throws -> Data? {
        try await FileManager.runOnIOQueue {
            try self.read(upToCount: count)
        }
    }
    
    
    /// Places the file pointer at the end of the file referenced by the file handle and returns the new file offset.
    ///
    /// - Seealso: [`seekToEnd()`](https://developer.apple.com/documentation/foundation/filehandle/3516319-seektoend)
    @available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *)
    public func seekToEndAsync() async throws -> UInt64 {
        try await FileManager.runOnIOQueue {
            try self.seekToEnd()
        }
    }
    
    
    /// Writes the specified data synchronously to the file handle.
    ///
    /// - Seealso: [`write(contentsOf:)`](https://developer.apple.com/documentation/foundation/filehandle/3516320-write)
    @available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *)
    public func writeAsync<T: DataProtocol>(contentsOf data: T) async throws {
        try await FileManager.runOnIOQueue {
            try self.write(contentsOf: data)
        }
    }
    
}


@available(macOS, introduced: 10.15, deprecated: 100000)
@available(iOS, introduced: 13.0, deprecated: 100000)
@available(watchOS, introduced: 6.0, deprecated: 100000)
@available(tvOS, introduced: 13.0, deprecated: 100000)
extension FileHandle {
    
    /// Reads the available data synchronously up to the end of file or maximum number of bytes.
    ///
    /// - Seealso: [`readDataToEndOfFile()`](https://developer.apple.com/documentation/foundation/filehandle/1411490-readdatatoendoffile)
    public func readDataToEndOfFileAsync() async -> Data {
        await FileManager.runOnIOQueue {
            self.readDataToEndOfFile()
        }
    }
    
    
    /// Reads data synchronously up to the specified number of bytes.
    ///
    /// - Seealso: [`readData(ofLength:)`](https://developer.apple.com/documentation/foundation/filehandle/1413916-readdata)
    public func readDataAsync(ofLength length: Int) async -> Data {
        await FileManager.runOnIOQueue {
            self.readData(ofLength: length)
        }
    }
    
    
    /// Writes the specified data synchronously to the file handle.
    ///
    /// - Seealso: [`write(_:)`](https://developer.apple.com/documentation/foundation/filehandle/1410936-write)
    public func writeAsync(_ data: Data) async {
        await FileManager.runOnIOQueue {
            self.write(data)
        }
    }
    
    
    /// Places the file pointer at the end of the file referenced by the file handle and returns the new file offset.
    ///
    /// - Seealso: [`seekToEndOfFile()`](https://developer.apple.com/documentation/foundation/filehandle/1411311-seektoendoffile)
    public func seekToEndOfFileAsync() async -> UInt64 {
        await FileManager.runOnIOQueue {
            self.seekToEndOfFile()
        }
    }
    
    
    /// Moves the file pointer to the specified offset within the file represented by the receiver.
    ///
    /// - Seealso: [`seekAsync(toFileOffset:)`](https://developer.apple.com/documentation/foundation/filehandle/1412135-seek)
    public func seekAsync(toFileOffset offset: UInt64) async {
        await FileManager.runOnIOQueue {
            self.seek(toFileOffset: offset)
        }
    }
    
    
    /// Truncates or extends the file represented by the file handle to a specified offset within the file and puts the file pointer at that position.
    ///
    /// - Seealso: [`truncateFile(atOffset:)`](https://developer.apple.com/documentation/foundation/filehandle/1411716-truncatefile)
    public func truncateFileAsync(atOffset offset: UInt64) async {
        await FileManager.runOnIOQueue {
            self.truncateFile(atOffset: offset)
        }
    }
    
    
    /// Causes all in-memory data and attributes of the file represented by the handle to write to permanent storage.
    ///
    /// - Seealso: [`synchronizeFile()`](https://developer.apple.com/documentation/foundation/filehandle/1411016-synchronizefile)
    public func synchronizeFileAsync() async {
        await FileManager.runOnIOQueue {
            self.synchronizeFile()
        }
    }
    
    
    /// Disallows further access to the represented file or communications channel and signals end of file on communications channels that permit writing.
    ///
    /// - Seealso: [`closeFile()`](https://developer.apple.com/documentation/foundation/filehandle/1413393-closefile)
    public func closeFileAsync() async {
        await FileManager.runOnIOQueue {
            self.closeFile()
        }
    }
    
}
