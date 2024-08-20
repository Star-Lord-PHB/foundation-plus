import Foundation


/// Execute the provided closure immediately and return the result
///
/// Exactly the same as the following:
/// ```swift
/// let result = {
///     // some task
/// }()
/// ```
@discardableResult
public func execute<R>(_ block: () throws -> R) rethrows -> R {
    return try block()
}


/// Execute the provided closure immediately on the provided actor and return the result
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
@discardableResult
public func execute<R, A: Actor>(isolatedOn actor: isolated A, _ block: () throws -> R) rethrows -> R {
    return try block()
}


/// Execute the provided closure immediately on the provided actor and return the result
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
@discardableResult
public func execute<R, A: Actor>(
    isolatedOn actor: isolated A,
    _ block: @Sendable (isolated A) throws -> R
) rethrows -> R {
    return try block(actor)
}


/// Execute the provided closure immediately and return the result
///
/// Exactly the same as the following:
/// ```swift
/// let result = await {
///     // some async task
/// }()
/// ```
@discardableResult
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public func executeAsync<R>(_ block: () async throws -> R) async rethrows -> R {
    return try await block()
}


/// Execute the provided closure immediately on the provided actor and return the result
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
@discardableResult
public func executeAsync<R: Sendable, A: Actor>(
    isolatedOn actor: isolated A,
    _ block: @Sendable (isolated A) async throws -> R
) async rethrows -> R {
    return try await block(actor)
}


/// Denote that something is not yet implemented and will crash the program
/// if executed at runtime
///
/// Exactly the same as calling [`fatalError(_:file:line:)`], but with a default message
/// `"Not yet implemented"`
///
/// [`fatalError(_:file:line:)`]: https://developer.apple.com/documentation/swift/fatalerror(_:file:line:)
public func TODO(
    _ reason: String = "Not yet implemented",
    file: StaticString = #file,
    line: UInt = #line
) -> Never {
    fatalError(reason, file: file, line: line)
}