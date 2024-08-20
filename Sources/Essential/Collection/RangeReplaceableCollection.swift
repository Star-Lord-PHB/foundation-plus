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
    public mutating func trimSuffix(while predicate: (Element) throws -> Bool) rethrows {
        
        guard isNotEmpty else { return }
        
        var start = startIndex
        var foundConforming = false
        
        for (i, element) in zip(self.indices, self) {
            
            let conform = try predicate(element)
            
            if conform, !foundConforming {
                start = i
                foundConforming = true
            } else if !conform, foundConforming {
                foundConforming = false
            }
            
        }
        
        if foundConforming {
            self.removeSubrange(start ... endIndex)
        }
        
    }
    
}



extension RangeReplaceableCollection where Self: BidirectionalCollection {
    
    /// Remove final elements in the collection that meet the given predicate
    /// - Parameter predicate: A closure that takes an element of the sequence as its argument
    ///                        and returns true if the element should be removed
    ///                        or false if it should be kept.
    ///                        Once the predicate returns false it will not be called again
    public mutating func trimSuffix(while predicate: (Element) throws -> Bool) rethrows {
        let count = try reversed().prefix(while: predicate).count
        removeLast(count)
    }
    
}
