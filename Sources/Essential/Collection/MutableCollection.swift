//
//  MutableCollection.swift
//  
//
//  Created by Star_Lord_PHB on 2024/6/18.
//

import Foundation



extension MutableCollection where Self: RandomAccessCollection {
    
    /// Sorts the collection using the given key path to compare elements.
    /// - Parameter keyPath: the key path of the property for comparison
    @inlinable
    public mutating func sort<T: Comparable>(by keyPath: any KeyPath<Element, T> & Sendable) {
        if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
            sort(using: KeyPathComparator(keyPath))
        } else {
            sort { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
        }
    }
    
}
