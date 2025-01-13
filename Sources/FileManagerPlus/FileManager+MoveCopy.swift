//
//  MoveCopy.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/7/31.
//

import Foundation
import SystemPackage


extension FileManager {

    /// Move an item at specified path to the new location
    /// - Parameters:
    ///   - srcPath: The path of the item to be moved
    ///   - destPath: The path of the new location
    public func moveItem(at srcPath: FilePath, to destPath: FilePath) throws {
        try self.moveItem(atPath: srcPath.string, toPath: destPath.string)
    }   


    /// Move an item at specified url to the new location
    /// - Parameters:
    ///   - srcUrl: The url of the item to be moved
    ///   - destUrl: The url of the new location
    public func moveItem(at srcUrl: URL, to destUrl: URL) throws {
        try self.moveItem(at: srcUrl.assertAsFilePath(), to: destUrl.assertAsFilePath())
    }


    /// Copy an item at specified path to the new location
    /// - Parameters:
    ///   - srcPath: The path of the item to be copied
    ///   - destPath: The path of the new location
    public func copyItem(at srcPath: FilePath, to destPath: FilePath) throws {
        try self.copyItem(atPath: srcPath.string, toPath: destPath.string)
    }


    /// Copy an item at specified url to the new location
    /// - Parameters:
    ///   - srcUrl: The url of the item to be copied
    ///   - destUrl: The url of the new location
    public func copyItem(at srcUrl: URL, to destUrl: URL) throws {
        try self.copyItem(at: srcUrl.assertAsFilePath(), to: destUrl.assertAsFilePath())
    }

}


@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension FileManager {

    /// Move an item at specified path to the new location
    /// - Parameters:
    ///   - srcPath: The path of the item to be moved
    ///   - destPath: The path of the new location
    /// 
    /// - Note: This operation will automatically be executed on
    /// ``FoundationPlusTaskExecutor/io`` executor
    public func moveItem(at srcPath: FilePath, to destPath: FilePath) async throws {
        try await Self.runOnIOQueue {
            try self.moveItem(at: srcPath, to: destPath)
        }
    }

    
    /// Move an item at specified url to the new location
    /// - Parameters:
    ///   - srcUrl: The url of the item to be moved
    ///   - destUrl: The url of the new location
    ///
    /// - Note: This operation will automatically be executed on
    /// ``FoundationPlusTaskExecutor/io`` executor
    public func moveItem(at srcUrl: URL, to destUrl: URL) async throws {
        try await Self.runOnIOQueue {
            try self.moveItem(at: srcUrl, to: destUrl)
        }
    }


    /// Copy an item at specified path to the new location
    /// - Parameters:
    ///   - srcPath: The path of the item to be copied
    ///   - destPath: The path of the new location
    /// 
    /// - Note: This operation will automatically be executed on
    /// ``FoundationPlusTaskExecutor/io`` executor
    public func copyItem(at srcPath: FilePath, to destPath: FilePath) async throws {
        try await Self.runOnIOQueue {
            try self.copyItem(at: srcPath, to: destPath)
        }
    }
    
    
    /// Copy an item at specified url to the new location
    /// - Parameters:
    ///   - srcUrl: The url of the item to be copied
    ///   - destUrl: The url of the new location
    ///
    /// - Note: This operation will automatically be executed on
    /// ``FoundationPlusTaskExecutor/io`` executor
    public func copyItem(at srcUrl: URL, to destUrl: URL) async throws {
        try await Self.runOnIOQueue {
            try self.copyItem(at: srcUrl, to: destUrl)
        }
    }
    
}
