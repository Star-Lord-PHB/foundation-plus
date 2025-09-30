

extension Optional where Wrapped: ~Copyable {

    /// Get the wrapped value of the optional instance or a default value.
    /// 
    /// - Parameter defaultValue: A default value to return if the optional instance is `nil`.
    /// 
    /// Same as the `??` operator, but in the form of a method.
    /// 
    /// - Seealso: [`??(_:_:)`]
    /// 
    /// [`??(_:_:)`]: https://developer.apple.com/documentation/swift/__(_:_:)-9xjze
    @inlinable
    public consuming func unwrap(or defaultValue: @autoclosure () throws -> Wrapped) rethrows -> Wrapped {
        switch (consume self) {
            case .some(let value): return value
            case .none: return try defaultValue()
        }
    }


    /// Get the wrapped value of the optional instance or a default value produced by a closure.
    /// 
    /// - Parameter defaultValue: A closure that produces a default value if the optional instance is `nil`.
    /// 
    /// Same as the `??` operator, but in the form of a method.
    /// 
    /// - Seealso: [`??(_:_:)`]
    /// 
    /// [`??(_:_:)`]: https://developer.apple.com/documentation/swift/__(_:_:)-9xjze
    @inlinable
    public consuming func unwrap<E: Error>(or defaultValue: () throws(E) -> Wrapped) throws(E) -> Wrapped {
        switch (consume self) {
            case .some(let value): return value
            case .none: return try defaultValue()
        }
    }

}