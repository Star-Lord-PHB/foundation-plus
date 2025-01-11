import Foundation


extension Sequence {
    
    /// Convert the sequence into an Array containing the same elements
    /// - Returns: the converted array
    @inlinable
    public func toArray() -> [Element] {
        return Array(self)
    }
    
    
    /// Returns the elements of the collection, sorted using the given key path to compare elements.
    /// - Parameter keyPath: the key path of the property for comparison
    /// - Returns: An array of the elements sorted
    @inlinable
    public func sorted<T:Comparable>(by keyPath: any KeyPath<Element, T> & Sendable) -> [Element] {
        return if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
            sorted(using: KeyPathComparator(keyPath))
        } else {
            sorted { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
        }
    }
    
    
    /// Returns the minimum element in the collection, using the given key path for comparison
    /// - Parameter keyPath: key path of the property for comparison
    /// - Returns: The sequence’s minimum element, according to the `keyPath`.
    ///            If the sequence has no elements, returns nil.
    @inlinable
    @warn_unqualified_access
    public func min<T:Comparable>(by keyPath: KeyPath<Element, T>) -> Element? {
        return self.min { e1, e2 in e1[keyPath: keyPath] < e2[keyPath: keyPath] }
    }
    
    
    /// Returns the maximum element in the collection, using the given key path for comparison
    /// - Parameter keyPath: key path of the property for comparison
    /// - Returns: The sequence’s maximum element, according to the `keyPath`.
    ///            If the sequence has no elements, returns nil.
    @inlinable
    @warn_unqualified_access
    public func max<T:Comparable>(by keyPath: KeyPath<Element, T>) -> Element? {
        return self.max { e1, e2 in e1[keyPath: keyPath] < e2[keyPath: keyPath] }
    }
    
    
    /// Returns the sum of all the elements in the collection
    /// - Returns: the sum of all elements
    @inlinable
    public func sum() -> Element where Element: AdditiveArithmetic {
        return reduce(.zero, +)
    }
    
}


extension Sequence where Element: Hashable {
    
    /// Convert the sequence into a Set containing the same elements
    /// - Returns: the converted 
    @inlinable
    public func toSet() -> Set<Element> {
        return Set(self)
    }
    
}
