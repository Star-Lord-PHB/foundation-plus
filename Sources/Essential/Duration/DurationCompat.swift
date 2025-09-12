//
//  DurationCompat.swift
//
//
//  Created by Star_Lord_PHB on 2024/6/9.
//

import Foundation


/// A compat version of [`Swift/Duration`] to support older OS versions
///
/// - Warning: This implementation does not guarantee exactly the same behavior as the standard [`Swift/Duration`]
/// - Warning: If your OS version is new enough to use [`Swift/Duration`], don't use this one
/// 
/// [`Swift/Duration`]: (https://developer.apple.com/documentation/Swift/Duration)
@available(iOS, deprecated: 16, message: "use Duration instead")
@available(macOS, deprecated: 13, message: "use Duration instead")
@available(watchOS, deprecated: 9, message: "use Duration instead")
@available(tvOS, deprecated: 16, message: "use Duration instead")
public struct DurationCompat: Sendable {
    
    @usableFromInline
    let high: Int64
    @usableFromInline
    let low: UInt64
    
    /// The composite components of the Duration
    ///
    /// This is intended for facilitating conversions to existing time types.
    /// The attoseconds value will not exceed 1e18 or be lower than -1e18.
    @inlinable
    public var components: (seconds: Int64, attoseconds: Int64) {
        let factor: Double = 10 ** 18
        let (seconds, attoseconds) = self.div(factor.int64Val)
        precondition(seconds.high == 0 || seconds.high == -1)
        precondition(attoseconds.high == 0 || attoseconds.high == -1)
        return (Int64(bitPattern: seconds.low), Int64(bitPattern: attoseconds.low))
    }
    
    
    /// Construct a `DurationCompat` by adding attoseconds to a seconds value.
    ///
    /// This is useful for when an external decomposed components of a `DurationCompat`
    /// has been stored and needs to be reconstituted. Since the values are added
    /// no precondition is expressed for the attoseconds being limited to 1e18.
    ///
    ///       let d1 = DurationCompat(
    ///         secondsComponent: 3,
    ///         attosecondsComponent: 123000000000000000)
    ///       print(d1) // 3.123 seconds
    ///
    ///       let d2 = DurationCompat(
    ///         secondsComponent: 3,
    ///         attosecondsComponent: -123000000000000000)
    ///       print(d2) // 2.877 seconds
    ///
    ///       let d3 = DurationCompat(
    ///         secondsComponent: -3,
    ///         attosecondsComponent: -123000000000000000)
    ///       print(d3) // -3.123 seconds
    ///
    /// - Parameters:
    ///   - secondsComponent: The seconds component portion of the `DurationCompat`
    ///                       value.
    ///   - attosecondsComponent: The attosecond component portion of the
    ///                           `DurationCompat` value.
    public init(secondsComponent: Int64, attosecondsComponent: Int64) {
        
        let factor: Double = 10 ** 18
        
        let a32 = secondsComponent >> 32
        let b = (secondsComponent & 0x00000000FFFFFFFF).uInt64Val
        let c32 = factor.uInt64Val >> 32
        let d = factor.uInt64Val & 0x00000000FFFFFFFF
        
        let a32c32 = a32 * c32.int64Val
        let a32d = a32 * d.int64Val
        let bc32 = b * c32
        let bd = b * d
        
        let comp0 = bd & 0x00000000FFFFFFFF
        let overflow0 = bd >> 32
        
        let comp32Temp = a32d + bc32.int64Val + overflow0.int64Val
        let comp32 = comp32Temp << 32
        let overflow32 = comp32Temp >> 32
        
        let comp64Temp = a32c32 + overflow32
        let comp64 = comp64Temp & 0x00000000FFFFFFFF
        let overflow64 = comp64Temp >> 32
        
        let comp96 = overflow64 << 32
        
        let secondHigh = comp96 + comp64
        let secondLow = UInt64(bitPattern: comp32) + comp0
        
        let attosecondLow = UInt64(bitPattern: attosecondsComponent)
        let attosecondHigh = attosecondsComponent < 0 ? -1.int64Val : 0.int64Val
        
        let (low, hasOverflow) = attosecondLow.addingReportingOverflow(secondLow)
        let high = attosecondHigh + secondHigh + (hasOverflow ? 1 : 0)
        
        self.init(high: high, low: low)
        
    }
    
    @usableFromInline
    init(high: Int64, low: UInt64) {
        self.high = high
        self.low = low
    }
    
}


extension DurationCompat {
    
    @inlinable
    public static func nanoseconds<T>(_ nanoseconds: T) -> DurationCompat where T : BinaryInteger {
        let seconds = nanoseconds.int64Val / (10 ** 9).int64Val
        let attoseconds = (nanoseconds.int64Val % (10 ** 9).int64Val) * (10 ** 9).int64Val
        return DurationCompat(secondsComponent: seconds, attosecondsComponent: attoseconds)
    }
    
    
    @inlinable
    public static func microseconds<T>(_ microseconds: T) -> DurationCompat where T : BinaryInteger {
        .nanoseconds(microseconds.int64Val * 1000)
    }
    
    @inlinable
    public static func microseconds(_ microseconds: Double) -> DurationCompat {
        let seconds = floor(microseconds / (10 ** 6))
        let attoseconds = (microseconds - seconds * (10 ** 6)) * (10 ** 12)
        return DurationCompat(
            secondsComponent: seconds.int64Val,
            attosecondsComponent: attoseconds.int64Val
        )
    }
    
    
    @inlinable
    public static func milliseconds<T>(_ milliseconds: T) -> DurationCompat where T : BinaryInteger {
        .microseconds(milliseconds.int64Val * 1000)
    }
    
    @inlinable
    public static func milliseconds(_ milliseconds: Double) -> DurationCompat {
        .microseconds(milliseconds * 1000)
    }
    
    
    @inlinable
    public static func seconds<T>(_ seconds: T) -> DurationCompat where T : BinaryInteger {
        .milliseconds(seconds.int64Val * 1000)
    }
    
    @inlinable
    public static func seconds(_ seconds: Double) -> DurationCompat {
        .milliseconds(seconds * 1000)
    }
    

    @inlinable
    public static func minutes<T>(_ val: T) -> DurationCompat where T: BinaryInteger {
        .seconds(val * 60)
    }
    
    @inlinable
    public static func minutes(_ val: Double) -> DurationCompat {
        .seconds(val * 60)
    }
    
    
    @inlinable
    public static func hours<T>(_ val: T) -> DurationCompat where T: BinaryInteger {
        .minutes(val * 60)
    }
    
    @inlinable
    public static func hours(_ val: Double) -> DurationCompat {
        .minutes(val * 60)
    }
    
    
    @inlinable
    public static func days<T>(_ val: T) -> DurationCompat where T: BinaryInteger {
        .hours(val * 24)
    }
    
    @inlinable
    public static func days(_ val: Double) -> DurationCompat {
        .hours(val * 24)
    }
    
    
    @inlinable
    public static func weeks<T>(_ val: T) -> DurationCompat where T: BinaryInteger {
        .days(val * 7)
    }
    
    @inlinable
    public static func weeks(_ val: Double) -> DurationCompat {
        .days(val * 7)
    }
    
}


@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension Duration {
    public func toDurationCompat() -> DurationCompat {
        let (seconds, attoseconds) = components
        return DurationCompat(secondsComponent: seconds, attosecondsComponent: attoseconds)
    }
}


@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension DurationCompat {
    public func toDuration() -> Duration {
        let (seconds, attoseconds) = components
        return Duration(secondsComponent: seconds, attosecondsComponent: attoseconds)
    }
}


@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension Duration {
    
    public static func == (lhs: Duration, rhs: DurationCompat) -> Bool {
        lhs.components == rhs.components
    }
    
    public static func == (lhs: DurationCompat, rhs: Duration) -> Bool {
        rhs == lhs
    }
    
    
    public static func < (lhs: Duration, rhs: DurationCompat) -> Bool {
        lhs < rhs.toDuration()
    }
    
    public static func < (lhs: DurationCompat, rhs: Duration) -> Bool {
        lhs.toDuration() < rhs
    }
    
    
    public static func <= (lhs: Duration, rhs: DurationCompat) -> Bool {
        lhs <= rhs.toDuration()
    }
    
    public static func <= (lhs: DurationCompat, rhs: Duration) -> Bool {
        lhs.toDuration() <= rhs
    }
    
    
    public static func > (lhs: Duration, rhs: DurationCompat) -> Bool {
        lhs > rhs.toDuration()
    }
    
    public static func > (lhs: DurationCompat, rhs: Duration) -> Bool {
        lhs.toDuration() > rhs
    }
    
    
    public static func >= (lhs: Duration, rhs: DurationCompat) -> Bool {
        lhs >= rhs.toDuration()
    }
    
    public static func >= (lhs: DurationCompat, rhs: Duration) -> Bool {
        lhs.toDuration() >= rhs
    }
    
}
