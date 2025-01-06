import Foundation


extension FileManager {

    public struct FileTimeStamp: Sendable {

        public var seconds: Int64
        public var nanoseconds: UInt64

        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        public var totalNanoseconds: Int128 {
            return .init(seconds) * 1_000_000_000 + .init(nanoseconds)
        }

        @inlinable
        public var date: Date {
    #if os(Windows)
            .init(timeIntervalSinceReferenceDate: .init(seconds) - Date.timeIntervalBetween1601AndReferenceDate + .init(nanoseconds) / 1_000_000_000)
    #else
            .init(timeIntervalSinceReferenceDate: .init(seconds) - Date.timeIntervalBetween1970AndReferenceDate + .init(nanoseconds) / 1_000_000_000)
    #endif
        }


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