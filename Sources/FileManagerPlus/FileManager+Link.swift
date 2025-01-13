//
//  FileManager+AsyncLink.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/8/4.
//

import Foundation
import SystemPackage


extension FileManager {

    /// Get the destination of a symbolic link at the specified path.
    /// - Parameters:
    ///   - path: The path of the symbolic link
    ///   - recursive: Whether to resolve the symbolic link recursively until reaching a non-link item
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


    /// Get the destination of a symbolic link at the specified url.
    /// - Parameters:
    ///   - url: The url of the symbolic link
    ///   - recursive: Whether to resolve the symbolic link recursively until reaching a non-link item
    public func destinationOfSymbolicLink(at url: URL, recursive: Bool = true) throws -> URL {
        return try self.destinationOfSymbolicLink(at: url.assertAsFilePath(), recursive: recursive).toURL()
    }


    /// Create a symbolic link at the specified path that points to the item at the destination path.
    /// - Parameters:
    ///   - srcPath: The path of the created symbolic link
    ///   - destPath: The path of the item that the new symbolic link points to
    ///   - replaceExisting: Whether to replace any file originally existed at the `srcPath`, default to false
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


    /// Create a symbolic link at the specified url that points to the item at the destination url.
    /// - Parameters:
    ///   - srcUrl: The url of the created symbolic link
    ///   - destUrl: The url of the item that the new symbolic link points to
    ///   - replaceExisting: Whether to replace any file originally existed at the `srcUrl`, default to false
    public func createSymbolicLink(
        at srcUrl: URL, 
        withDestination destUrl: URL, 
        replaceExisting: Bool = false
    ) throws {
        try self.createSymbolicLink(at: srcUrl.assertAsFilePath(), withDestination: destUrl.assertAsFilePath(), replaceExisting: replaceExisting)
    }


    /// Create a hard link at the specified path that is linked with another item.
    /// - Parameters:
    ///   - srcPath: The path of the original item
    ///   - destPath: The path of the created hard link
    ///   - replaceExisting: Whether to replace any file originally existed at the `destPath`, default to false
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


    /// Create a hard link at the specified url that is linked with another item.
    /// - Parameters:
    ///   - srcUrl: The url of the original item
    ///   - destUrl: The url of the created hard link
    ///   - replaceExisting: Whether to replace any file originally existed at the `destUrl`, default to false
    public func linkItem(
        at srcUrl: URL, 
        to destUrl: URL, 
        replaceExisting: Bool = false
    ) throws {
        try self.linkItem(at: srcUrl.assertAsFilePath(), to: destUrl.assertAsFilePath(), replaceExisting: replaceExisting)
    }

}



extension FileManager {

    /// Get the destination of a symbolic link at the specified path.
    /// - Parameters:
    ///   - path: The path of the symbolic link
    ///   - recursive: Whether to resolve the symbolic link recursively until reaching a non-link item
    /// 
    /// - Note: This operation will automatically be executed on
    /// ``FoundationPlusTaskExecutor/io`` executor
    public func destinationOfSymbolicLink(at path: FilePath, recursive: Bool = true) async throws -> FilePath {
        try await Self.runOnIOQueue {
            try self.destinationOfSymbolicLink(at: path, recursive: recursive)
        }
    }
    
    /// Get the destination of a symbolic link at the specified url.
    /// - Parameters:
    ///   - url: The url of the symbolic link
    ///   - recursive: Whether to resolve the symbolic link recursively until reaching a non-link item
    /// 
    /// - Note: This operation will automatically be executed
    /// on ``FoundationPlusTaskExecutor/io`` executor
    public func destinationOfSymbolicLink(at url: URL, recursive: Bool = true) async throws -> URL {
        try await Self.runOnIOQueue {
            try self.destinationOfSymbolicLink(at: url, recursive: recursive)
        }
    }


    /// Create a symbolic link at the specified path that points to the item at the destination path.
    /// - Parameters:
    ///   - srcPath: The path of the created symbolic link
    ///   - destPath: The path of the item that the new symbolic link points to
    ///   - replaceExisting: Whether to replace any file originally existed at the `srcPath`, default to false
    /// 
    /// - Note: This operation will automatically be executed
    /// on ``FoundationPlusTaskExecutor/io`` executor
    public func createSymbolicLink(at srcPath: FilePath, withDestination destPath: FilePath, replaceExisting: Bool = false) async throws {
        try await Self.runOnIOQueue {
            try self.createSymbolicLink(at: srcPath, withDestination: destPath, replaceExisting: replaceExisting)
        }
    }
    
    
    /// Create a symbolic link at the specified url that points to the item at the destination url.
    /// - Parameters:
    ///   - srcUrl: The url of the created symbolic link
    ///   - destUrl: The url of the item that the new symbolic link points to
    ///   - replaceExisting: Whether to replace any file originally existed at the `srcUrl`, default to false
    /// 
    /// - Note: This operation will automatically be executed
    /// on ``FoundationPlusTaskExecutor/io`` executor
    public func createSymbolicLink(at srcUrl: URL, withDestination destUrl: URL, replaceExisting: Bool = false) async throws {
        try await Self.runOnIOQueue {
            try self.createSymbolicLink(at: srcUrl, withDestination: destUrl, replaceExisting: replaceExisting)
        }
    }


    /// Create a hard link at the specified path that is linked with another item.
    /// - Parameters:
    ///   - srcPath: The path of the original item
    ///   - destPath: The path of the created hard link
    ///   - replaceExisting: Whether to replace any file originally existed at the `destPath`, default to false
    /// 
    /// - Note: This operation will automatically be executed
    /// on ``FoundationPlusTaskExecutor/io`` executor
    public func linkItem(at srcPath: FilePath, to destPath: FilePath, replaceExisting: Bool = false) async throws {
        try await Self.runOnIOQueue {
            try self.linkItem(at: srcPath, to: destPath, replaceExisting: replaceExisting)
        }
    }
    
    
    /// Create a hard link at the specified url that is linked with another item.
    /// - Parameters:
    ///   - srcUrl: The url of the original item
    ///   - destUrl: The url of the created hard link
    ///   - replaceExisting: Whether to replace any file originally existed at the `destUrl`, default to false
    ///
    /// - Note: This operation will automatically be executed
    /// on ``FoundationPlusTaskExecutor/io`` executor
    public func linkItem(at srcUrl: URL, for destUrl: URL, replaceExisting: Bool = false) async throws {
        try await Self.runOnIOQueue {
            try self.linkItem(at: srcUrl, to: destUrl, replaceExisting: replaceExisting)
        }
    }
    
}
