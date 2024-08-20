//
//  BidirectionalCollection.swift
//
//
//  Created by Star_Lord_PHB on 2024/6/18.
//

import Foundation



extension BidirectionalCollection {
    
    /// Returns a subsequence containing all but the final elements that meet the given predicate
    /// - Parameter predicate: A closure that takes an element of the sequence as its argument
    ///                        and returns true if the element should be dropped
    ///                        or false if it should be included.
    ///                        Once the predicate returns false it will not be called again
    /// - Returns: The subsequence with the specified final elements not included
    public func dropLast(while predicate: (Element) throws -> Bool) rethrows -> SubSequence {
        let count = try self.reversed().prefix(while: predicate).count
        return self.dropLast(count)
    }
    
    
    /// Returns a subsequence containing the final elements that meet the given predicate
    /// - Parameter predicate: A closure that takes an element of the sequence as its argument
    ///                        and returns true if the element should be included
    ///                        or false if it should NOT be included.
    ///                        Once the predicate returns false it will not be called again
    /// - Returns: The subsequence containing the specified final elements
    public func suffix(while predicate: (Element) throws -> Bool) rethrows -> SubSequence {
        let count = try self.reversed().prefix(while: predicate).count
        return self.suffix(count)
    }
    
}
