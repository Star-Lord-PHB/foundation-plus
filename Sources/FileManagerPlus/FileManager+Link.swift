//
//  FileManager+AsyncLink.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/8/4.
//

import Foundation
import SystemPackage


extension FileManager {

    public func destinationOfSymbolicLink(at path: FilePath, recursive: Bool = true) throws -> FilePath {
        
        if !recursive {
            return try .init(self.destinationOfSymbolicLink(atPath: path.string))
        }

        var pathStr = path.string
        while true {
            pathStr = try .init(self.destinationOfSymbolicLink(atPath: pathStr))
            do {
                if try self.attributesOfItem(atPath: pathStr)[.type] as? FileAttributeType != .typeSymbolicLink {
                    break
                }
            } catch let error as NSError where error.code == CocoaError.fileReadNoSuchFile.rawValue {
                break
            }
        }

        return .init(pathStr)

    }


    public func destinationOfSymbolicLink(at url: URL, recursive: Bool = true) throws -> URL {
        return try self.destinationOfSymbolicLink(at: url.assertAsFilePath(), recursive: recursive).toURL()
    }


    public func createSymbolicLink(
        at srcPath: FilePath, 
        withDestination destPath: FilePath, 
        replaceExisting: Bool = false
    ) throws {
        if replaceExisting && self.fileExists(atPath: srcPath.string) {
            try self.removeItem(atPath: srcPath.string)
        }
        try self.createSymbolicLink(atPath: srcPath.string, withDestinationPath: destPath.string)
    }


    public func createSymbolicLink(
        at srcUrl: URL, 
        withDestination destUrl: URL, 
        replaceExisting: Bool = false
    ) throws {
        try self.createSymbolicLink(at: srcUrl.assertAsFilePath(), withDestination: destUrl.assertAsFilePath(), replaceExisting: replaceExisting)
    }


    public func linkItem(
        at srcPath: FilePath, 
        to destPath: FilePath, 
        replaceExisting: Bool = false
    ) throws {
        if replaceExisting && self.fileExists(atPath: destPath.string) {
            try self.removeItem(atPath: destPath.string)
        }
        try self.linkItem(atPath: srcPath.string, toPath: destPath.string)
    }


    public func linkItem(
        at srcUrl: URL, 
        to destUrl: URL, 
        replaceExisting: Bool = false
    ) throws {
        try self.linkItem(at: srcUrl.assertAsFilePath(), to: destUrl.assertAsFilePath(), replaceExisting: replaceExisting)
    }

}


@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension FileManager {

    public func destinationOfSymbolicLink(at path: FilePath, recursive: Bool = true) async throws -> FilePath {
        try await Self.runOnIOQueue {
            try self.destinationOfSymbolicLink(at: path, recursive: recursive)
        }
    }
    
    /// Returns the url of the item pointed to by a symbolic link.
    /// - Parameters:
    ///   - url: The url of the symbolic link
    ///   - recursive: Whether to resolve the symbolic link recursively until reaching a file
    ///   that is not a symbolic link (default is `true`)
    /// - Returns: The url of the item pointed to by the symbolic link, or the origianl url if
    /// it is not a symbolic link
    public func destinationOfSymbolicLink(at url: URL, recursive: Bool = true) async throws -> URL {
        try await Self.runOnIOQueue {
            try self.destinationOfSymbolicLink(at: url, recursive: recursive)
        }
    }


    public func createSymbolicLink(at srcPath: FilePath, withDestination destPath: FilePath, replaceExisting: Bool = false) async throws {
        try await Self.runOnIOQueue {
            try self.createSymbolicLink(at: srcPath, withDestination: destPath, replaceExisting: replaceExisting)
        }
    }
    
    
    /// Creates a symbolic link at the specified src URL that points to an item at
    /// the given dest URL.
    /// - Parameters:
    ///   - src: The url of the created symbolic link
    ///   - dest: The destination url that the new symbolic link points to
    ///   - replaceExisting: Whether to replace any file originally existed at the `src` url
    ///   (default is `false`)
    public func createSymbolicLink(at srcUrl: URL, withDestination destUrl: URL, replaceExisting: Bool = false) async throws {
        try await Self.runOnIOQueue {
            try self.createSymbolicLink(at: srcUrl, withDestination: destUrl, replaceExisting: replaceExisting)
        }
    }


    public func linkItem(at srcPath: FilePath, to destPath: FilePath, replaceExisting: Bool = false) async throws {
        try await Self.runOnIOQueue {
            try self.linkItem(at: srcPath, to: destPath, replaceExisting: replaceExisting)
        }
    }
    
    
    /// Create a hard link at the `src` url that is linked with the file at `dest` url
    /// - Parameters:
    ///   - src: The url for the created link
    ///   - dest: The url of the item being linked to
    ///   - replaceExisting: Whether to replace any file originally existed at the `src` url
    ///   (default is `false`)
    ///
    /// - Seealso: [`linkItem(at:to:)`](https://developer.apple.com/documentation/foundation/filemanager/1414456-linkitem)
    public func createHardLink(at srcUrl: URL, for destUrl: URL, replaceExisting: Bool = false) async throws {
        try await Self.runOnIOQueue {
            try self.linkItem(at: srcUrl, to: destUrl, replaceExisting: replaceExisting)
        }
    }
    
}
