//
//  LazySequence.swift
//  
//
//  Created by Star_Lord_PHB on 2024/6/25.
//


extension LazySequence {
    
    /// Returns a LazyMapSequence over this sequence containing the results of mapping the
    /// given key path over the sequence’s elements
    /// - Parameter keyPath: key path of property of the element to map to
    /// - Returns: an Array containing the mapped elements
    func map<T>(to keyPath: KeyPath<Base.Element, T>) -> LazyMapSequence<Base, T> {
        self.map { $0[keyPath: keyPath] }
    }
    
}
