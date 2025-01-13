import Foundation


extension FileManager {

    /// A type representing time stamps used in file attributes.
    /// 
    /// - On Windows, the time stamp represent the number of nanoseconds since January 1, 1601.
    /// - On other platforms, the time stamp represent the number of seconds since January 1, 1970.
    /// 
    /// - Note: On Windows, the time stamp has accuracy of 100 nanoseconds. But it is still stored here
    /// using 1 nanosecond precision, meaning that the last 2 digits SHOULD BE 0, but this is not enforced.
    /// If you need to fix this, use the ``FileTimeStamp/platformTrimmed`` property.
    public struct FileTimeStamp: Sendable {

        /// The seconds part of the time stamp.
        public var seconds: Int64
        /// The nanoseconds part of the time stamp.
        public var nanoseconds: UInt64

        /// The total number of nanoseconds since January 1, 1970 (on non-Windows platforms) 
        /// or January 1, 1601 (on Windows).
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        public var totalNanoseconds: Int128 {
            return .init(seconds) * 1_000_000_000 + .init(nanoseconds)
        }

        /// Convert to a `Date` instance.
        public var date: Date {
    #if os(Windows)
            .init(timeIntervalSinceReferenceDate: .init(seconds) - Date.timeIntervalBetween1601AndReferenceDate + .init(nanoseconds) / 1_000_000_000)
    #else
            .init(timeIntervalSinceReferenceDate: .init(seconds) - Date.timeIntervalBetween1970AndReferenceDate + .init(nanoseconds) / 1_000_000_000)
    #endif
        }


        /// If on Windows, this will trim last 2 digits of the nanoseconds part to 0 to match the actual precition.
        /// On other platforms, this will return the same value.
        @inlinable
        public var platformTrimmed: FileManager.FileTimeStamp {
    #if os(Windows)
            .init(seconds: seconds, nanoseconds: nanoseconds / 100 * 100)
    #else
            self
    #endif
        }


        public init(seconds: Int64, nanoseconds: UInt64) {
            self.seconds = seconds + .init(nanoseconds / 1_000_000_000)
            self.nanoseconds = nanoseconds % 1_000_000_000
        }


        /// Return a new instance representing the current time.
        public static var now: FileManager.FileTimeStamp { 
            Date().fileTimeStamp.platformTrimmed
        }

    }

}



extension FileManager.FileTimeStamp: Equatable, Hashable, Comparable {

    public static func < (lhs: Self, rhs: Self) -> Bool {
        if lhs.seconds == rhs.seconds {
            return lhs.nanoseconds < rhs.nanoseconds
        }
        return lhs.seconds < rhs.seconds
    }

}