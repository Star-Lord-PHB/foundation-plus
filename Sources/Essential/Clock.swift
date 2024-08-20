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
    /// ```swift
    /// let (result, time) = ContinuousClock().measureExpr {
    ///     // some task
    /// }
    /// ```
    public func measureExpr<R>(_ work: () throws -> R) rethrows -> (result: R, time: Duration) {
        var result: R?
        let time = try measure {
            result = try work()
        }
        return (result.unsafelyUnwrapped, time)
    }
    
    
    /// Measure the elapsed time to execute a closure and return the result
    ///
    /// ```swift
    /// let (result, time) = await ContinuousClock().measureExpr {
    ///     // some async task
    /// }
    /// ```
    public func measureExpr<R>(
        _ work: () async throws -> R
    ) async rethrows -> (result: R, time: Duration) {
        var result: R?
        let time = try await measure {
            result = try await work()
        }
        return (result.unsafelyUnwrapped, time)
    }
    
    
    /// Measure the elapsed time to execute a closure and return the result
    ///
    /// - Parameter clockType: the type of clock to use for measuring, default is ``ClockType/continuous``
    /// - Parameter work: the task that needs to be measured
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
    public static func measureExpr<R>(
        withClock clockType: ClockType = .continuous,
        _ work: () throws -> R
    ) rethrows -> (result: R, time: Swift.Duration) {
        var result: R?
        let time = switch clockType {
            case .continuous:
                try ContinuousClock().measure {
                    result = try work()
                }
            case .suspending:
                try SuspendingClock().measure {
                    result = try work()
                }
        }
        return (result.unsafelyUnwrapped, time)
    }
    
    
    /// Measure the elapsed time to execute a closure and return the result
    ///
    /// - Parameter clockType: the type of clock to use for measuring, default is ``ClockType/continuous``
    /// - Parameter work: the task that needs to be measured
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
    public static func measureExpr<R>(
        withClock clockType: ClockType = .continuous,
        _ work: () async throws -> R
    ) async rethrows -> (result: R, time: Swift.Duration) {
        var result: R?
        let time = switch clockType {
            case .continuous:
                try await ContinuousClock().measure {
                    result = try await work()
                }
            case .suspending:
                try await SuspendingClock().measure {
                    result = try await work()
                }
        }
        return (result.unsafelyUnwrapped, time)
    }
    
}


public enum ClockType {
    case continuous, suspending
}


@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension ContinuousClock {
    
    /// Measure the elapsed time to execute a closure and return the result
    ///
    /// ```swift
    /// let (result, time) = ContinuousClock.measureExpr {
    ///     // some task
    /// }
    /// ```
    public static func measureExpr<R>(_ work: () throws -> R) rethrows -> (result: R, time: Duration) {
        try ContinuousClock().measureExpr(work)
    }
    
    
    /// Measure the elapsed time to execute a closure and return the result
    ///
    /// ```swift
    /// let (result, time) = await ContinuousClock.measureExpr {
    ///     // some async task
    /// }
    /// ```
    public static func measureExpr<R>(
        _ work: () async throws -> R
    ) async rethrows -> (result: R, time: Duration) {
        try await ContinuousClock().measureExpr(work)
    }
    
}



@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension SuspendingClock {
    
    /// Measure the elapsed time to execute a closure and return the result
    ///
    /// ```swift
    /// let (result, time) = SuspendingClock.measureExpr {
    ///     // some task
    /// }
    /// ```
    public static func measureExpr<R>(_ work: () throws -> R) rethrows -> (result: R, time: Duration) {
        try SuspendingClock().measureExpr(work)
    }
    
    
    /// Measure the elapsed time to execute a closure and return the result
    ///
    /// ```swift
    /// let (result, time) = await SuspendingClock.measureExpr {
    ///     // some async task
    /// }
    /// ```
    public static func measureExpr<R>(
        _ work: () async throws -> R
    ) async rethrows -> (result: R, time: Duration) {
        try await SuspendingClock().measureExpr(work)
    }
    
}
