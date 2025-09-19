import Foundation


/// Execute the provided closure immediately on the provided actor and return the result
@inlinable
@discardableResult
public func execute<R, E: Error>(
    isolatedOn actor: isolated (any Actor)? = #isolation, 
    _ block: () throws(E) -> sending R
) throws(E) -> sending R {
    return try block()
}


/// Execute the provided closure immediately on the provided actor and return the result
@inlinable
@discardableResult
public func execute<R, E: Error>(
    isolatedOn actor: isolated (any Actor)? = #isolation,
    _ block: @Sendable (_: isolated (any Actor)?) async throws(E) -> sending R
) async throws(E) -> sending R {
    return try await block(actor)
}


/// Denote that something is not yet implemented and will crash the program
/// if executed at runtime
///
/// Exactly the same as calling [`fatalError(_:file:line:)`], but with a default message
/// `"Not yet implemented"`
///
/// [`fatalError(_:file:line:)`]: https://developer.apple.com/documentation/swift/fatalerror(_:file:line:)
@inlinable
public func TODO(
    _ reason: @autoclosure () -> String = "Not yet implemented",
    file: StaticString = #file,
    line: UInt = #line
) -> Never {
    fatalError(reason(), file: file, line: line)
}
