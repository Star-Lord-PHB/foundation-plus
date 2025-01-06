#if !os(Windows)
import Foundation
#if canImport(Glibc)
import GlibcInterop
#endif


#if canImport(Glibc)
let UTIME_NOW = UTIME_NOW_INTEROP
let UTIME_OMIT = UTIME_OMIT_INTEROP
let SUPPORT_BIRTHTIME = GlibcInterop.SUPPORT_BIRTHTIME == 1
#endif 


extension timespec {

    var fileTimeStamp: FileTimeStamp {
        .init(seconds: .init(tv_sec), nanoseconds: .init(tv_nsec))
    }

    
    static var now: timespec {
        .init(tv_sec: 0, tv_nsec: .init(UTIME_NOW))
    }

    static var omit: timespec {
        .init(tv_sec: 0, tv_nsec: .init(UTIME_OMIT))
    }

}


#if canImport(Glibc)
extension statx_timestamp {

    var fileTimeStamp: FileTimeStamp {
        .init(seconds: .init(tv_sec), nanoseconds: .init(tv_nsec))
    }

}
#endif


extension Date {

    var timeSpec: timespec {
        var timeSpec = timespec()
        let interval = timeIntervalSince1970
        timeSpec.tv_sec = time_t(interval)
        timeSpec.tv_nsec = Int(interval.truncatingRemainder(dividingBy: 1) * 1_000_000_000)
        return timeSpec
    }


    var fileTimeStamp: FileTimeStamp {
        let interval = timeIntervalSince1970
        let seconds = Int64(interval)
        let nanoseconds = UInt64(interval.truncatingRemainder(dividingBy: 1) * 1_000_000_000)
        return .init(seconds: seconds, nanoseconds: nanoseconds)
    }

}


extension FileTimeStamp {

    var timeSpec: timespec {
        .init(tv_sec: .init(seconds), tv_nsec: .init(nanoseconds))
    }

#if canImport(Glibc)
    var statxTimeStamp: statx_timestamp {
        .init(tv_sec: .init(seconds), tv_nsec: .init(nanoseconds), __reserved: 0)
    }
#endif

}

#endif