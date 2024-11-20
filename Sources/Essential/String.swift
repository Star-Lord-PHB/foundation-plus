//
//  String.swift
//
//
//  Created by Star_Lord_PHB on 2024/6/15.
//

import Foundation


extension String {
    
    
    /// Whether the string is empty or contains only white space characters
    /// - Complexity: O(n) where n is the length of the string
    public var isBlank: Bool {
        self.first(where: { !$0.isWhitespace }) == nil
    }
    
    /// Whether the string is not empty and contains at least one character
    /// that is not white space character
    /// - Complexity: O(n) where n is the length of the string
    public var isNotBlank: Bool { !isBlank }
    
    
    /// Returns a new String containing all but the final characters that are
    /// within the given character set
    /// - Parameter characterSet: A character set that define what characters should be excluded
    /// - Returns: The new String with the specified final characters not included
    public func trimmingSuffix(in characterSet: CharacterSet) -> String {
        let scalars = self.unicodeScalars.trimmingSuffix { scalar in
            characterSet.contains(scalar)
        }
        return String(scalars)
    }
    
    
    /// Returns a new String containing all but the starting characters that are
    /// within the given character set 
    /// - Parameter characterSet: A character set that define what characters should be excluded
    /// - Returns: The new String with the specified starting characters not included
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    public func trimmingPrefix(in characterSet: CharacterSet) -> String {
        let scalars = self.unicodeScalars.trimmingPrefix { scalar in
            characterSet.contains(scalar)
        }
        return String(scalars)
    }
    
}
