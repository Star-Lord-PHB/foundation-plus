//
//  Collection.swift
//
//
//  Created by Star_Lord_PHB on 2024/6/18.
//

import Foundation


extension Collection {
    
    /// A Boolean value indicating whether the collection is NOT empty.
    ///
    /// It is basically the inverse of ``Collection/isEmpty``
    ///
    /// - Complexity: O(1)
    public var isNotEmpty: Bool { !isEmpty }
    
    
    /// Returns a subsequence containing all but the final elements that meet the given predicate
    /// - Parameter predicate: A closure that takes an element of the sequence as its argument
    ///                        and returns true if the element should be dropped
    ///                        or false if it should be included.
    ///                        Once the predicate returns false it will not be called again
    /// - Returns: The subsequence with the specified final elements not included
    public func dropLast(while predicate: (Element) throws -> Bool) rethrows -> SubSequence {
        try self.dropLast(self.countContinuousElementsFromLast(where: predicate))
    }
    
    
    /// Returns a subsequence containing the final elements that meet the given predicate
    /// - Parameter predicate: A closure that takes an element of the sequence as its argument
    ///                        and returns true if the element should be included
    ///                        or false if it should NOT be included.
    ///                        Once the predicate returns false it will not be called again
    /// - Returns: The subsequence containing the specified final elements
    public func suffix(while predicate: (Element) throws -> Bool) rethrows -> SubSequence {
        try self.suffix(self.countContinuousElementsFromLast(where: predicate))
    }
    
    
    private func countContinuousElementsFromLast(
        where predicate: (Element) throws -> Bool
    ) rethrows -> Int {
        
        var count = 0
        var foundConforming = false
        
        for element in self {
            
            let conform = try predicate(element)
            
            if conform, !foundConforming {
                count = 1
                foundConforming = true
            } else if conform, foundConforming {
                count += 1
            } else if !conform, foundConforming {
                foundConforming = false
            }
            
        }
        
        return foundConforming ? count : 0
        
    }
    
    
    /// Returns a subsequence containing all but the final elements that meet the given predicate
    /// - Parameter predicate: A closure that takes an element of the sequence as its argument
    ///                        and returns true if the element should be dropped
    ///                        or false if it should be included.
    ///                        Once the predicate returns false it will not be called again
    /// - Returns: The subsequence with the specified final elements not included
    public func trimmingSuffix(
        while predicate: (Element) throws -> Bool
    ) rethrows -> SubSequence {
        try dropLast(while: predicate)
    }
    
}

