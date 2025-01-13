//
//  Remove.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/7/31.
//

import Foundation
import SystemPackage


extension FileManager {

    /// Remove the item at the specified path
    public func removeItem(at path: FilePath) throws {
        try self.removeItem(at: path.toURL())
    }


#if canImport(Darwin) 

    /// Move the item at the specified path to trash
    /// - Returns: The path of the item in trash
    @discardableResult
    public func trashItem(at path: FilePath) throws -> FilePath? {
        var newUrl: NSURL?
        try self.trashItem(at: path.toURL(), resultingItemURL: &newUrl)
        return (newUrl as URL?)?.toFilePath()
    }


    /// Move the item at the specified url to trash
    /// - Returns: The url of the item in trash
    @discardableResult
    public func trashItem(at url: URL) throws -> URL? {
        var newUrl: NSURL?
        try self.trashItem(at: url, resultingItemURL: &newUrl)
        return newUrl as URL?
    }

#endif 

}



extension FileManager {

    /// Remove the item at the specified path
    /// 
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    public func removeItem(at path: FilePath) async throws {
        try await Self.runOnIOQueue {
            try self.removeItem(at: path)
        }
    }

    
    /// Remove the item at the specified url
    /// 
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    public func removeItem(at url: URL) async throws {
        try await Self.runOnIOQueue {
            try self.removeItem(at: url)
        }
    }
    
    
#if canImport(Darwin) 

    /// Move the item at the specified path to trash
    /// - Returns: The path of the item in trash
    @discardableResult
    public func trashItem(at path: FilePath) async throws -> FilePath? {
        try await Self.runOnIOQueue {
            try self.trashItem(at: path)
        }
    }


    /// Move the item at the specified url to trash
    /// - Returns: The url of the item in trash
    @discardableResult
    public func trashItem(at url: URL) async throws -> URL? {
        try await Self.runOnIOQueue {
            try self.trashItem(at: url)
        }
    }
    
#endif
    
}
