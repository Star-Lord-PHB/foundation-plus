//
//  Create.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/7/29.
//

import Foundation
import FoundationPlusEssential
import ConcurrencyPlus


@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension FileManager {
    
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
            Self.assertOnIOQueue()
            if !replaceExisting && self.fileExists(atPath: url.compactPath()) {
                throw CocoaError.fileError(.fileWriteFileExists, url: url)
            }
            guard self.createFile(atPath: url.compactPath(), contents: content) else {
                throw CocoaError.fileError(.fileWriteUnknown, url: url)
            }
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
            dispatchPrecondition(condition: .onQueue(DefaultTaskExecutor.io.queue))
            try self.createDirectory(
                atPath: url.compactPath(),
                withIntermediateDirectories: withIntermediateDirectories
            )
        }
        
    }
    
}
