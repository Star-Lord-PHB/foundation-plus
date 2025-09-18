//
//  Clock.swift
//  
//
//  Created by Star_Lord_PHB on 2024/6/25.
//



@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension Clock {
    
    /// Measure the elapsed time to execute a closure and return the result
    /// 
    /// - Parameter work: the code block that needs to be measured
    /// - Returns: the result of the task and the elapsed time
    ///
    /// ```swift
    /// let (result, time) = ContinuousClock().measureExpr {
    ///     // some task
    /// }
    /// ```
    @inlinable
    public func measureExpr<R, E: Error>(_ work: () throws(E) -> R) throws(E) -> (result: R, time: Duration) {
        do {
            var result: R?
            let time = try measure {
                result = try work()
            }
            return (result.unsafelyUnwrapped, time)
        } catch let error as E {
            throw error
        } catch {
            fatalError("Expect error to be of type \(E.self), but got \(error)")
        }
    }
    
    
    /// Measure the elapsed time to execute a closure and return the result
    /// 
    /// - Parameter isolation: the actor isolation context, default to the current context
    /// - Parameter work: the code block that needs to be measured
    /// - Returns: the result of the task and the elapsed time
    ///
    /// ```swift
    /// let (result, time) = await ContinuousClock().measureExpr {
    ///     // some async task
    /// }
    /// ```
    @inlinable
    public func measureExpr<R, E: Error>(
        isolation: isolated (any Actor)? = #isolation,
        _ work: () async throws(E) -> R
    ) async throws(E) -> (result: R, time: Duration) {
        do {
            var result: R?
            let time = try await measure {
                result = try await work()
            }
            return (result.unsafelyUnwrapped, time)
        } catch let error as E {
            throw error
        } catch {
            fatalError("Expect error to be of type \(E.self), but got \(error)")
        }
    }
    
    
    /// Measure the elapsed time to execute a closure and return the result
    ///
    /// - Parameter clockType: the type of clock to use for measuring, default is ``ClockType/continuous``
    /// - Parameter work: the code block that needs to be measured
    /// - Returns: the result of the task and the elapsed time
    ///
    /// It choose clock to use base on the `clockType` parameter:
    /// * ``ClockType/continuous``: use [`ContinuousClock`]
    /// * ``ClockType/suspending``: use [`SuspendingClock`]
    ///
    /// ```swift
    /// let (result, time) = Clock.measureExpr {
    ///     // some task
    /// }
    /// ```
    /// ```swift
    /// let (result, time) = Clock.measureExpr(withClock: .suspending) {
    ///     // some task
    /// }
    /// ```
    ///
    /// [`ContinuousClock`]: https://developer.apple.com/documentation/swift/continuousclock
    /// [`SuspendingClock`]: https://developer.apple.com/documentation/swift/suspendingclock
    @inlinable
    public static func measureExpr<R, E: Error>(
        withClock clockType: ClockType = .continuous,
        _ work: () throws(E) -> R
    ) throws(E) -> (result: R, time: Swift.Duration) {
        switch clockType {
            case .continuous:
                try ContinuousClock.continuous.measureExpr(work)
            case .suspending:
                try SuspendingClock.suspending.measureExpr(work)
        }
    }
    
    
    /// Measure the elapsed time to execute a closure and return the result
    ///
    /// - Parameter clockType: the type of clock to use for measuring, default is ``ClockType/continuous``
    /// - Parameter isolation: the actor isolation context, default to the current context
    /// - Parameter work: the code block that needs to be measured
    /// - Returns: the result of the task and the elapsed time
    ///
    /// It choose clock to use base on the `clockType` parameter:
    /// * ``ClockType/continuous``: use [`ContinuousClock`]
    /// * ``ClockType/suspending``: use [`SuspendingClock`]
    ///
    /// ```swift
    /// let (result, time) = await Clock.measureExpr {
    ///     // some async task
    /// }
    /// ```
    /// ```swift
    /// let (result, time) = await Clock.measureExpr(withClock: .suspending) {
    ///     // some async task
    /// }
    /// ```
    ///
    /// [`ContinuousClock`]: https://developer.apple.com/documentation/swift/continuousclock
    /// [`SuspendingClock`]: https://developer.apple.com/documentation/swift/suspendingclock
    @inlinable
    public static func measureExpr<R, E: Error>(
        withClock clockType: ClockType = .continuous,
        isolation: isolated (any Actor)? = #isolation,
        _ work: () async throws(E) -> R
    ) async throws(E) -> (result: R, time: Swift.Duration) {
        switch clockType {
            case .continuous:
                try await ContinuousClock.continuous.measureExpr(work)
            case .suspending:
                try await SuspendingClock.suspending.measureExpr(work)
        }
    }
    
}


public enum ClockType {
    case continuous, suspending
}


@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension ContinuousClock {
    
    /// Measure the elapsed time to execute a closure and return the result
    ///
    /// - Parameter work: the code block that needs to be measured
    /// - Returns: the result of the task and the elapsed time
    ///
    /// ```swift
    /// let (result, time) = ContinuousClock.measureExpr {
    ///     // some task
    /// }
    /// ```
    @inlinable
    public static func measureExpr<R, E: Error>(_ work: () throws(E) -> R) throws(E) -> (result: R, time: Duration) {
        try ContinuousClock.continuous.measureExpr(work)
    }
    
    
    /// Measure the elapsed time to execute a closure and return the result
    /// 
    /// - Parameter isolation: the actor isolation context, default to the current context
    /// - Parameter work: the code block that needs to be measured
    /// - Returns: the result of the task and the elapsed time
    ///
    /// ```swift
    /// let (result, time) = await ContinuousClock.measureExpr {
    ///     // some async task
    /// }
    /// ```
    @inlinable
    public static func measureExpr<R, E: Error>(
        isolation: isolated (any Actor)? = #isolation,
        _ work: () async throws(E) -> R
    ) async throws(E) -> (result: R, time: Duration) {
        try await ContinuousClock.continuous.measureExpr(work)
    }
    
}



@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension SuspendingClock {
    
    /// Measure the elapsed time to execute a closure and return the result
    ///
    /// - Parameter work: the code block that needs to be measured
    /// - Returns: the result of the task and the elapsed time
    ///
    /// ```swift
    /// let (result, time) = SuspendingClock.measureExpr {
    ///     // some task
    /// }
    /// ```
    @inlinable
    public static func measureExpr<R, E: Error>(_ work: () throws(E) -> R) throws(E) -> (result: R, time: Duration) {
        try SuspendingClock.suspending.measureExpr(work)
    }
    
    
    /// Measure the elapsed time to execute a closure and return the result
    /// 
    /// - Parameter isolation: the actor isolation context, default to the current context
    /// - Parameter work: the code block that needs to be measured
    /// - Returns: the result of the task and the elapsed time
    ///
    /// ```swift
    /// let (result, time) = await SuspendingClock.measureExpr {
    ///     // some async task
    /// }
    /// ```
    @inlinable
    public static func measureExpr<R, E: Error>(
        isolation: isolated (any Actor)? = #isolation,
        _ work: () async throws(E) -> R
    ) async throws(E) -> (result: R, time: Duration) {
        try await SuspendingClock.suspending.measureExpr(work)
    }
    
}
