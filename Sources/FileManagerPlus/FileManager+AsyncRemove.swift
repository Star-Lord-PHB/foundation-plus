//
//  Remove.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/7/31.
//

import Foundation


@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension FileManager {
    
    /// Delete a file / directory at the specified url
    /// - Parameter url: The url of the file / directory to delete
    ///
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    public func remove(at url: URL) async throws {
        
        try await Self.runOnIOQueue {
            Self.assertOnIOQueue()
            try self.removeItem(at: url)
        }
        
    }
    
    
    /// Move a file / directory at the specified url to trash
    /// - Parameter url: The url of the file / directory to move to trash
    /// - Returns: The url of the file / directory in trash
    @discardableResult
    public func moveToTrash(at url: URL) async throws -> URL? {
        
        try await Self.runOnIOQueue {
            Self.assertOnIOQueue()
            var newUrl: NSURL?
            try self.trashItem(at: url, resultingItemURL: &newUrl)
            return newUrl as URL?
        }
        
    }
    
}
