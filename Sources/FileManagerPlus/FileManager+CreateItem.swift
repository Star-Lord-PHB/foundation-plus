//
//  Create.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/7/29.
//

import Foundation
import FoundationPlusEssential
import ConcurrencyPlus
import SystemPackage



extension FileManager {

    public func createFile(
        at path: FilePath, 
        replaceExisting: Bool = false, 
        with content: Data? = nil
    ) throws {
        if !replaceExisting && self.fileExists(atPath: path.string) {
            throw CocoaError.fileError(.fileWriteFileExists, path: path)
        }
        guard self.createFile(atPath: path.string, contents: content) else {
            throw CocoaError.fileError(.fileWriteUnknown, path: path)
        }
    }


    public func createFile(
        at url: URL,
        replaceExisting: Bool = false, 
        with content: Data? = nil
    ) throws {
        try self.createFile(at: url.assertAsFilePath(), replaceExisting: replaceExisting, with: content)
    }


    public func createDirectory(
        at path: FilePath, 
        withIntermediateDirectories: Bool = false
    ) throws {
        try self.createDirectory(
            atPath: path.string, 
            withIntermediateDirectories: withIntermediateDirectories
        )
    }


    public func createDirectory(
        at url: URL, 
        withIntermediateDirectories: Bool = false
    ) throws {
        try self.createDirectory(at: url.assertAsFilePath(), withIntermediateDirectories: withIntermediateDirectories)
    }

}



@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension FileManager {

    public func createFile(
        at path: FilePath, 
        replaceExisting: Bool = false, 
        with content: Data? = nil
    ) async throws {
        try await Self.runOnIOQueue {
            try self.createFile(at: path, replaceExisting: replaceExisting, with: content)
        }
    }

    
    /// Create a new file at the specified url
    /// - Parameters:
    ///   - url: the url for the new file
    ///   - replaceExisting: whether to replace the already existed file
    ///   - content: contents that will be written into the new file
    ///
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    public func createFile(
        at url: URL,
        replaceExisting: Bool = false,
        with content: Data? = nil
    ) async throws {
        try await Self.runOnIOQueue {
            try self.createFile(at: url, replaceExisting: replaceExisting, with: content)
        }
    }


    public func createDirectory(
        at path: FilePath,
        withIntermediateDirectories: Bool = false
    ) async throws {
        try await Self.runOnIOQueue {
            try self.createDirectory(at: path, withIntermediateDirectories: withIntermediateDirectories)
        }
    }
    
    
    /// Create a new directory at the specified url
    /// - Parameters:
    ///   - url: The url for the new directory
    ///   - withIntermediateDirectories: Whether to create necessary intermediate directories
    ///   if they does not present. If set to false, the method will also throws if the directory
    ///   already exist
    ///
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    public func createDirectory(
        at url: URL,
        withIntermediateDirectories: Bool = false
    ) async throws {
        
        try await Self.runOnIOQueue {
            try self.createDirectory(at: url, withIntermediateDirectories: withIntermediateDirectories)
        }
        
    }
    
}
