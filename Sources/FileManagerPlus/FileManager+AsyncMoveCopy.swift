//
//  MoveCopy.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/7/31.
//

import Foundation


@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension FileManager {
    
    /// Move a file / directory at `src` to the new location at `dest`
    /// - Parameters:
    ///   - src: The url of the file / directory to be moved
    ///   - dest: The url of the new location
    ///
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    public func move(_ src: URL, to dest: URL) async throws {
        
        try await Self.runOnIOQueue {
            Self.assertOnIOQueue()
            try self.moveItem(at: src, to: dest)
        }
        
    }
    
    
    /// Copy a file / directory at `src` to the new location at `dest`
    /// - Parameters:
    ///   - src: The url of the file / directory to be copied
    ///   - dest: The url of the new location
    ///
    /// - Note: This operation will automatically be executed on
    /// ``DefaultTaskExecutor/io`` executor
    public func copy(_ src: URL, to dest: URL) async throws {
        
        try await Self.runOnIOQueue {
            Self.assertOnIOQueue()
            try self.copyItem(at: src, to: dest)
        }
        
    }
    
}
