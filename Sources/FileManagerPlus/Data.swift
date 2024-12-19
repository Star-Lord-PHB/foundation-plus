//
//  Data.swift
//
//
//  Created by Star_Lord_PHB on 2024/6/12.
//

import Foundation
import ConcurrencyPlus
import SystemPackage


@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension Data {

    public static func read(contentAt path: FilePath) async throws -> Data {
        try await self.read(contentsOf: path.toURL())
    }

    
    /// Read the content of the provided `URL` and return as `Data`
    /// - Parameter url: The `URL` of the resource to be read
    /// - Returns: The content of that `URL`
    ///
    /// - Note: This operation will automatically be executed on seperate threads for IO
    public static func read(contentsOf url: URL) async throws -> Data {
        try await FileManager.runOnIOQueue {
            try Data(contentsOf: url)
        }
    }


    public func write(to path: FilePath) async throws {
        try await write(to: path.toURL())
    }
    
    
    /// Write the data into the provided `URL`
    /// - Parameters:
    ///   - url: the `URL` that the data will be written into
    ///
    /// - Note: This operation will automatically be executed on seperate threads for IO
    public func write(to url: URL) async throws {
        try await FileManager.runOnIOQueue {
            try write(to: url)
        }
    }
    
}
