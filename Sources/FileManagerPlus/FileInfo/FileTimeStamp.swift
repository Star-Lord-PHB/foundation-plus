import Foundation


public struct FileTimeStamp: Sendable {

    public var seconds: Int64
    public var nanoseconds: UInt64

    public var totalNanoseconds: Int128 {
        return .init(seconds) * 1_000_000_000 + .init(nanoseconds)
    }

    public var date: Date {
#if os(Windows)
        let time = Double(UInt64(dwHighDateTime) << 32 | UInt64(dwLowDateTime)) / 10_000_000
        return .init(timeIntervalSince1970: time - Date.timeIntervalBetween1601AndReferenceDate + Date.timeIntervalBetween1970AndReferenceDate)
#else 
        return .init(timeIntervalSinceReferenceDate: .init(seconds) - Date.timeIntervalBetween1970AndReferenceDate + .init(nanoseconds) / 1_000_000_000)
#endif
    }


    public init(seconds: Int64, nanoseconds: UInt64) {
        self.seconds = seconds + .init(nanoseconds / 1_000_000_000)
        self.nanoseconds = nanoseconds % 1_000_000_000
    }


    public static var now: FileTimeStamp { 
        Date().fileTimeStamp
    }

}



extension FileTimeStamp: Equatable, Hashable, Comparable {

    public static func < (lhs: FileTimeStamp, rhs: FileTimeStamp) -> Bool {
        if lhs.seconds == rhs.seconds {
            return lhs.nanoseconds < rhs.nanoseconds
        }
        return lhs.seconds < rhs.seconds
    }

}