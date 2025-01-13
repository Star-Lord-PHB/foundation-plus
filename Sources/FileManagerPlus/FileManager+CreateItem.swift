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

    /// Create a new file at the specified file path
    /// - Parameters:
    ///   - path: the file path for the new file
    ///   - content: contents that will be written into the new file
    ///   - replaceExisting: whether to replace the already existed file
    public func createFile(
        at path: FilePath, 
        with content: Data? = nil,
        replaceExisting: Bool = false
    ) throws {
        if !replaceExisting && self.fileExists(atPath: path.string) {
            throw CocoaError.fileError(.fileWriteFileExists, path: path)
        }
        guard self.createFile(atPath: path.string, contents: content) else {
            throw CocoaError.fileError(.fileWriteUnknown, path: path)
        }
    }


    /// Create a new file at the specified url
    /// - Parameters:
    ///   - url: the url for the new file
    ///   - content: contents that will be written into the new file
    ///   - replaceExisting: whether to replace the already existed file
    public func createFile(
        at url: URL,
        with content: Data? = nil,
        replaceExisting: Bool = false
    ) throws {
        try self.createFile(at: url.assertAsFilePath(), with: content, replaceExisting: replaceExisting)
    }


    /// Create a new directory at the specified file path
    /// - Parameters:
    ///   - path: The file path for the new directory
    ///   - withIntermediateDirectories: Whether to create necessary intermediate directories
    ///   if they does not present. If set to false, the method will also throws if the directory
    ///   already exist
    public func createDirectory(
        at path: FilePath, 
        withIntermediateDirectories: Bool = false
    ) throws {
        try self.createDirectory(
            atPath: path.string, 
            withIntermediateDirectories: withIntermediateDirectories
        )
    }


    /// Create a new directory at the specified url
    /// - Parameters:
    ///   - url: The url for the new directory
    ///   - withIntermediateDirectories: Whether to create necessary intermediate directories
    ///   if they does not present. If set to false, the method will also throws if the directory
    ///   already exist
    public func createDirectory(
        at url: URL, 
        withIntermediateDirectories: Bool = false
    ) throws {
        try self.createDirectory(at: url.assertAsFilePath(), withIntermediateDirectories: withIntermediateDirectories)
    }

}



@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension FileManager {

    /// Create a new file at the specified file path
    /// - Parameters:
    ///   - path: the file path for the new file
    ///   - content: contents that will be written into the new file
    ///   - replaceExisting: whether to replace the already existed file
    ///
    /// - Note: This operation will automatically be executed on
    /// ``FoundationPlusTaskExecutor/io`` executor
    public func createFile(
        at path: FilePath, 
        with content: Data? = nil,
        replaceExisting: Bool = false
    ) async throws {
        try await Self.runOnIOQueue {
            try self.createFile(at: path, with: content, replaceExisting: replaceExisting)
        }
    }

    
    /// Create a new file at the specified url
    /// - Parameters:
    ///   - url: the url for the new file
    ///   - replaceExisting: whether to replace the already existed file
    ///   - content: contents that will be written into the new file
    ///
    /// - Note: This operation will automatically be executed on
    /// ``FoundationPlusTaskExecutor/io`` executor
    public func createFile(
        at url: URL,
        with content: Data? = nil,
        replaceExisting: Bool = false
    ) async throws {
        try await Self.runOnIOQueue {
            try self.createFile(at: url, with: content, replaceExisting: replaceExisting)
        }
    }


    /// Create a new directory at the specified file path
    /// - Parameters:
    ///   - path: The file path for the new directory
    ///   - withIntermediateDirectories: Whether to create necessary intermediate directories
    ///   if they does not present. If set to false, the method will also throws if the directory
    ///   already exist
    ///
    /// - Note: This operation will automatically be executed on
    /// ``FoundationPlusTaskExecutor/io`` executor
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
    /// ``FoundationPlusTaskExecutor/io`` executor
    public func createDirectory(
        at url: URL,
        withIntermediateDirectories: Bool = false
    ) async throws {
        
        try await Self.runOnIOQueue {
            try self.createDirectory(at: url, withIntermediateDirectories: withIntermediateDirectories)
        }
        
    }
    
}
