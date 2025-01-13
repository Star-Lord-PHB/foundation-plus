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
    @inlinable
    public func dropLast(while predicate: (Element) throws -> Bool) rethrows -> SubSequence {
        try self[..<self._startIndexOfContinuousElementsFromLast(where: predicate)]
    }
    
    
    /// Returns a subsequence containing the final elements that meet the given predicate
    /// - Parameter predicate: A closure that takes an element of the sequence as its argument
    ///                        and returns true if the element should be included
    ///                        or false if it should NOT be included.
    ///                        Once the predicate returns false it will not be called again
    /// - Returns: The subsequence containing the specified final elements
    @inlinable
    public func suffix(while predicate: (Element) throws -> Bool) rethrows -> SubSequence {
        try self[self._startIndexOfContinuousElementsFromLast(where: predicate)...]
    }


    /// Returns a subsequence containing all but the final elements that meet the given predicate
    /// - Parameter predicate: A closure that takes an element of the sequence as its argument
    ///                        and returns true if the element should be dropped
    ///                        or false if it should be included.
    ///                        Once the predicate returns false it will not be called again
    /// - Returns: The subsequence with the specified final elements not included
    @inlinable
    public func trimmingSuffix(
        while predicate: (Element) throws -> Bool
    ) rethrows -> SubSequence {
        try dropLast(while: predicate)
    }


    /// Returns a new collection of the same type by removing `suffix` from the end of the collection.
    /// - Parameter suffix: The collection to remove from this collection.
    /// - Returns: A collection containing the elements of the collection that are not removed by `suffix`.
    @inlinable
    public func trimmingSuffix<Suffix: BidirectionalCollection>(_ suffix: Suffix) -> SubSequence 
    where Element: Equatable, Suffix.Element == Element {
        self[..<self._startIndexOfSuffix(suffix)]
    }
    
}



extension BidirectionalCollection {

    @inlinable
    func _startIndexOfContinuousElementsFromLast(where predicate: (Element) throws -> Bool) rethrows -> Index {
        
        let startCount = try self.withContiguousStorageIfAvailable { buffer in
            var i = buffer.count - 1
            while i >= 0, try predicate(buffer[i]) {
                i -= 1
            }
            return i + 1
        }

        if let startCount { 
            return self.index(startIndex, offsetBy: startCount)
        }

        guard !self.isEmpty else { return self.startIndex }

        let startIndex = self.startIndex
        var i = index(before: self.endIndex)

        while i != startIndex, try predicate(self[i]) {
            i = self.index(before: i)
        }

        if i == startIndex {
            if try predicate(self[i]) {
                return startIndex
            } else if self.count == 1 {
                return self.endIndex
            }
        }

        return self.index(after: i)

    }

}



extension BidirectionalCollection where Element: Equatable {

    @inlinable
    func _startIndexOfSuffix<Suffix: BidirectionalCollection>(_ suffix: Suffix) -> Index where Element == Suffix.Element {
        
        if let index = _suffixSeqStartIndexWithContinuousBuffer(suffix) {
            return index
        }

        guard !self.isEmpty, !suffix.isEmpty else { return self.endIndex }

        var i = self.index(before: self.endIndex)
        var j = suffix.index(before: suffix.endIndex)

        while i != self.startIndex, j != suffix.startIndex, self[i] == suffix[j] {
            i = self.index(before: i)
            j = suffix.index(before: j)
        }

        guard j == suffix.startIndex else { return self.endIndex }

        return if self[i] == suffix[j] {
            i
        } else {
            self.endIndex
        }

    }

}