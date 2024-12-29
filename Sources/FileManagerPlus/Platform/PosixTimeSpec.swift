import Foundation


extension timespec {

    var date: Date {
        .init(timeIntervalSinceReferenceDate: .init(tv_sec) - Date.timeIntervalBetween1970AndReferenceDate + .init(tv_nsec) / 1_000_000_000)
        // .init(timeIntervalSince1970: TimeInterval(tv_sec) + TimeInterval(tv_nsec) / 1_000_000_000)
    }

    
    static var now: timespec {
        .init(tv_sec: 0, tv_nsec: .init(UTIME_NOW))
    }

    static var omit: timespec {
        .init(tv_sec: 0, tv_nsec: .init(UTIME_OMIT))
    }

}


extension Date {

    var timeSpec: timespec {
        var timeSpec = timespec()
        let interval = timeIntervalSince1970
        timeSpec.tv_sec = time_t(interval)
        timeSpec.tv_nsec = Int(interval.truncatingRemainder(dividingBy: 1) * 1_000_000_000)
        return timeSpec
    }

}