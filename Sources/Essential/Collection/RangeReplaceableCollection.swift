//
//  RangeReplaceableCollection.swift
//
//
//  Created by Star_Lord_PHB on 2024/6/18.
//

import Foundation


extension RangeReplaceableCollection {
    
    /// Remove final elements in the collection that meet the given predicate
    /// - Parameter predicate: A closure that takes an element of the sequence as its argument
    ///                        and returns true if the element should be removed
    ///                        or false if it should be kept.
    ///                        Once the predicate returns false it will not be called again
    @inlinable
    public mutating func trimSuffix(while predicate: (Element) throws -> Bool) rethrows {
        let startIndex = try self._startIndexOfContinuousElementsFromLast(where: predicate)
        self.removeSubrange(startIndex...)
    }


    @inlinable
    public mutating func trimSuffix<Suffix: Collection>(_ suffix: Suffix) 
    where Element: Equatable, Element == Suffix.Element {
        self.removeSubrange(_startIndexOfSuffix(suffix)...)
    }
    
}



extension RangeReplaceableCollection where Self: BidirectionalCollection {
    
    /// Remove final elements in the collection that meet the given predicate
    /// - Parameter predicate: A closure that takes an element of the sequence as its argument
    ///                        and returns true if the element should be removed
    ///                        or false if it should be kept.
    ///                        Once the predicate returns false it will not be called again
    public mutating func trimSuffix(while predicate: (Element) throws -> Bool) rethrows {
        let startIndex = try self._startIndexOfContinuousElementsFromLast(where: predicate)
        self.removeSubrange(startIndex...)
    }


    public mutating func trimSuffix<Suffix: Collection>(_ suffix: Suffix) 
    where Element: Equatable, Element == Suffix.Element {
        self.removeSubrange(_startIndexOfSuffix(suffix)...)
    }
    
}