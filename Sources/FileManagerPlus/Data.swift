//
//  Data.swift
//
//
//  Created by Star_Lord_PHB on 2024/6/12.
//

import Foundation
import ConcurrencyPlus


@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension Data {
    
    /// Read the content of the provided `URL` and return as `Data`
    /// - Parameter url: The `URL` of the resource to be read
    /// - Returns: The content of that `URL`
    ///
    /// - Note: This operation will automatically be executed on seperate threads for IO
    public static func read(contentsOf url: URL) async throws -> Data {
        if #available(macOS 15, iOS 18, watchOS 11, tvOS 18, visionOS 2, *) {
            try await withTaskExecutorPreference(DefaultTaskExecutor.io) {
                try Data(contentsOf: url)
            }
        } else {
            try await Task.launch(on: .io) {
                try Data(contentsOf: url)
            }
        }
    }
    
    
    /// Write the data into the provided `URL`
    /// - Parameters:
    ///   - url: the `URL` that the data will be written into
    ///
    /// - Note: This operation will automatically be executed on seperate threads for IO
    public func write(to url: URL) async throws {
        if #available(macOS 15, iOS 18, watchOS 11, tvOS 18, visionOS 2, *) {
            try await withTaskExecutorPreference(DefaultTaskExecutor.io) {
                try write(to: url)
            }
        } else {
            try await Task.launch(on: .io) {
                try write(to: url)
            }
        }
    }
    
}
