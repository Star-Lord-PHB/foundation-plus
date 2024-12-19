//
//  Remove.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/7/31.
//

import Foundation
import SystemPackage


extension FileManager {

    public func removeItem(at path: FilePath) throws {
        try self.removeItem(at: path.toURL())
    }


#if os(macOS) 
    public func trashItem(at path: FilePath) throws -> FilePath? {
        var newUrl: NSURL?
        try self.trashItem(at: path.toURL(), resultingItemURL: &newUrl)
        return (newUrl as URL?)?.toFilePath()
    }
#endif 

}


@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension FileManager {

    public func removeItem(at path: FilePath) async throws {
        try await Self.runOnIOQueue {
            try self.removeItem(at: path)
        }
    }

    
    /// Delete a file / directory at the specified url
    /// - Parameter url: The url of the file / directory to delete
    ///
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    public func removeItem(at url: URL) async throws {
        try await Self.runOnIOQueue {
            try self.removeItem(at: url)
        }
    }
    
    
#if os(macOS)

    @discardableResult
    public func trashItem(at path: FilePath) async throws -> FilePath? {
        try await Self.runOnIOQueue {
            try self.trashItem(at: path)
        }
    }


    /// Move a file / directory at the specified url to trash
    /// - Parameter url: The url of the file / directory to move to trash
    /// - Returns: The url of the file / directory in trash
    @discardableResult
    public func trashItem(at url: URL) async throws -> URL? {
        try await Self.runOnIOQueue {
            try self.trashItem(at: url)
        }
    }
    
#endif
    
}
