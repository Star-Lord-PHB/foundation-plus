import Foundation


@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension Duration {
    
    /// Construct a Duration given a number of minutes represented as a BinaryInteger
    /// - Returns: A Duration representing the number of minutes
    public static func minutes<T>(_ val: T) -> Duration where T: BinaryInteger {
        .seconds(val * 60)
    }
    
    /// Construct a Duration given a number of minutes represented as a Double
    /// - Returns: A Duration representing the number of minutes
    public static func minutes(_ val: Double) -> Duration {
        .seconds(val * 60)
    }


    /// Construct a Duration given a number of hours represented as a BinaryInteger
    /// - Returns: A Duration representing the number of hours
    public static func hours<T>(_ val: T) -> Duration where T: BinaryInteger {
        .minutes(val * 60)
    }

    /// Construct a Duration given a number of hours represented as a Double
    /// - Returns: A Duration representing the number of hours
    public static func hours(_ val: Double) -> Duration {
        .minutes(val * 60)
    }


    /// Construct a Duration given a number of days represented as a BinaryInteger
    /// - Returns: A Duration representing the number of days
    public static func days<T>(_ val: T) -> Duration where T: BinaryInteger {
        .hours(val * 24)
    }

    /// Construct a Duration given a number of days represented as a Double
    /// - Returns: A Duration representing the number of days
    public static func days(_ val: Double) -> Duration {
        .hours(val * 24)
    }


    /// Construct a Duration given a number of weeks represented as a BinaryInteger
    /// - Returns: A Duration representing the number of weeks
    public static func weeks<T>(_ val: T) -> Duration where T: BinaryInteger {
        .days(val * 7)
    }

    /// Construct a Duration given a number of weeks represented as a Double
    /// - Returns: A Duration representing the number of weeks
    public static func weeks(_ val: Double) -> Duration {
        .days(val * 7)
    }

}
