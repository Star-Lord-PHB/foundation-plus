//
//  MoveCopy.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/7/31.
//

import Foundation
import SystemPackage


extension FileManager {

    public func moveItem(at srcPath: FilePath, to destPath: FilePath) throws {
        try self.moveItem(atPath: srcPath.string, toPath: destPath.string)
    }   


    public func moveItem(at srcUrl: URL, to destUrl: URL) throws {
        try self.moveItem(at: srcUrl.assertAsFilePath(), to: destUrl.assertAsFilePath())
    }


    public func copyItem(at srcPath: FilePath, to destPath: FilePath) throws {
        try self.copyItem(atPath: srcPath.string, toPath: destPath.string)
    }


    public func copyItem(at srcUrl: URL, to destUrl: URL) throws {
        try self.copyItem(at: srcUrl.assertAsFilePath(), to: destUrl.assertAsFilePath())
    }

}


@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension FileManager {

    public func moveItem(at srcPath: FilePath, to destPath: FilePath) async throws {
        try await Self.runOnIOQueue {
            try self.moveItem(at: srcPath, to: destPath)
        }
    }

    
    /// Move a file / directory at `src` to the new location at `dest`
    /// - Parameters:
    ///   - src: The url of the file / directory to be moved
    ///   - dest: The url of the new location
    ///
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    public func moveItem(at srcUrl: URL, to destUrl: URL) async throws {
        try await Self.runOnIOQueue {
            try self.moveItem(at: srcUrl, to: destUrl)
        }
    }


    public func copyItem(at srcPath: FilePath, to destPath: FilePath) async throws {
        try await Self.runOnIOQueue {
            try self.copyItem(at: srcPath, to: destPath)
        }
    }
    
    
    /// Copy a file / directory at `src` to the new location at `dest`
    /// - Parameters:
    ///   - src: The url of the file / directory to be copied
    ///   - dest: The url of the new location
    ///
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    public func copyItem(at srcUrl: URL, to destUrl: URL) async throws {
        try await Self.runOnIOQueue {
            try self.copyItem(at: srcUrl, to: destUrl)
        }
    }
    
}
