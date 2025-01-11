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
    @inlinable
    public var isNotEmpty: Bool { !isEmpty }
    
    
    /// Returns a subsequence containing all but the final elements that meet the given predicate
    /// - Parameter predicate: A closure that takes an element of the sequence as its argument
    ///                        and returns true if the element should be dropped
    ///                        or false if it should be included.
    ///                        Once the predicate returns false it will not be called again
    /// - Returns: The subsequence with the specified final elements not included
    @inlinable
    public func dropLast(while predicate: (Element) throws -> Bool) rethrows -> SubSequence {
        try self[..<_startIndexOfContinuousElementsFromLast(where: predicate)]
    }
    
    
    /// Returns a subsequence containing the final elements that meet the given predicate
    /// - Parameter predicate: A closure that takes an element of the sequence as its argument
    ///                        and returns true if the element should be included
    ///                        or false if it should NOT be included.
    ///                        Once the predicate returns false it will not be called again
    /// - Returns: The subsequence containing the specified final elements
    @inlinable
    public func suffix(while predicate: (Element) throws -> Bool) rethrows -> SubSequence {
        try self[_startIndexOfContinuousElementsFromLast(where: predicate)...]
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


    @inlinable
    public func trimmingSuffix<Suffix: Collection>(_ suffix: Suffix) -> SubSequence 
    where Element: Equatable, Suffix.Element == Element {
        self[..<self._startIndexOfSuffix(suffix)]
    }
    
}



extension Collection {

    @inlinable
    func _startIndexOfContinuousElementsFromLast(
        where predicate: (Element) throws -> Bool
    ) rethrows -> Index {
        
        var startIndex = nil as Index?
        var i = self.startIndex
        
        while i != self.endIndex {

            defer { i = self.index(after: i) }
            
            let element = self[i]
            let conform = try predicate(element)
            
            if conform, startIndex == nil {
                startIndex = i
            } else if !conform, startIndex != nil {
                startIndex = nil
            }
            
        }
        
        return startIndex ?? self.endIndex
        
    }

}



extension Collection where Element: Equatable {

    @inlinable
    func _startIndexOfSuffix<Suffix: Collection>(_ suffix: Suffix) -> Index where Suffix.Element == Element {

        if let index = _suffixSeqStartIndexWithContinuousBuffer(suffix) {
            return index
        }

        let count1 = self.count
        let count2 = suffix.count

        guard count1 >= count2 else { return self.endIndex }

        let suffixStartIndex = self.index(self.startIndex, offsetBy: count1 - count2)
        var i = suffixStartIndex
        var j = suffix.startIndex

        while i != self.endIndex, self[i] == suffix[j] {
            i = self.index(after: i)
            j = suffix.index(after: j)
        }

        return if i != self.endIndex {
            self.endIndex
        } else {
            suffixStartIndex
        }

    }


    @inlinable
    func _suffixSeqStartIndexWithContinuousBuffer<Suffix: Collection>(_ suffix: Suffix) -> Index? where Element == Suffix.Element {

        self.withContiguousStorageIfAvailable { buffer1 in
            suffix.withContiguousStorageIfAvailable { buffer2 in
                
                guard buffer1.count >= buffer2.count else { return self.endIndex }

                var i = buffer1.count - 1
                var j = buffer2.count - 1

                while j >= 0, buffer1[i] == buffer2[j] {
                    i -= 1
                    j -= 1
                }

                return if j >= 0 {
                    endIndex
                } else {
                    self.index(startIndex, offsetBy: buffer1.count - buffer2.count)
                }

            }
        } ?? nil as Index?

    }

}