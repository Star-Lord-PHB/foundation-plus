//
//  FileManager+AsyncLink.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/8/4.
//

import Foundation


@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension FileManager {
    
    /// Returns the url of the item pointed to by a symbolic link.
    /// - Parameters:
    ///   - url: The url of the symbolic link
    ///   - recursive: Whether to resolve the symbolic link recursively until reaching a file
    ///   that is not a symbolic link (default is `true`)
    /// - Returns: The url of the item pointed to by the symbolic link, or the origianl url if
    /// it is not a symbolic link
    public func resolveSymbolicLink(at url: URL, recursive: Bool = true) async throws -> URL {
        
        try await Self.runOnIOQueue {
            
            return if recursive {
                try .init(resolvingAliasFileAt: url)
            } else if try self.fileExists(at: url, resolveSymbolicLink: false) && self.info(.isSymbolicLink, ofItemAt: url, default: false) {
                if #available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *) {
                    try .init(filePath: self.destinationOfSymbolicLink(atPath: url.compactPath()))
                } else {
                    try .init(fileURLWithPath: self.destinationOfSymbolicLink(atPath: url.compactPath()))
                }
            } else {
                url
            }
            
        }
        
    }
    
    
    /// Creates a symbolic link at the specified src URL that points to an item at
    /// the given dest URL.
    /// - Parameters:
    ///   - src: The url of the created symbolic link
    ///   - dest: The destination url that the new symbolic link points to
    ///   - replaceExisting: Whether to replace any file originally existed at the `src` url
    ///   (default is `false`)
    public func createSymbolicLink(
        at src: URL,
        for dest: URL,
        replaceExisting: Bool = false
    ) async throws {
        
        try await Self.runOnIOQueue {
            if replaceExisting && self.fileExists(at: src, resolveSymbolicLink: false) {
                try self.removeItem(at: src)
            }
            try self.createSymbolicLink(at: src, withDestinationURL: dest)
        }
        
    }
    
    
    /// Create a hard link at the `src` url that is linked with the file at `dest` url
    /// - Parameters:
    ///   - src: The url for the created link
    ///   - dest: The url of the item being linked to
    ///   - replaceExisting: Whether to replace any file originally existed at the `src` url
    ///   (default is `false`)
    ///
    /// - Seealso: [`linkItem(at:to:)`](https://developer.apple.com/documentation/foundation/filemanager/1414456-linkitem)
    public func createHardLink(
        at src: URL,
        for dest: URL,
        replaceExisting: Bool = false 
    ) async throws {
        try await Self.runOnIOQueue {
            if replaceExisting && self.fileExists(at: src, resolveSymbolicLink: false) {
                try self.removeItem(at: src)
            }
            try self.linkItem(at: dest, to: src)
        }
    }
    
}
