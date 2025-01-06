#if os(Windows)

import WinSDK
import Foundation


extension FILETIME {

    var date: Date {
        let time = Double(UInt64(dwHighDateTime) << 32 | UInt64(dwLowDateTime)) / 10_000_000
        // let interval = 11_644_473_600 as Double
        return .init(timeIntervalSince1970: time - Date.timeIntervalBetween1601AndReferenceDate + Date.timeIntervalBetween1970AndReferenceDate)
    }

    var fileTimeStamp: FileManager.FileTimeStamp {
        let time = UInt64(dwHighDateTime) << 32 | UInt64(dwLowDateTime)
        return .init(seconds: .init(time / 10_000_000), nanoseconds: .init(time % 10_000_000) * 100)
    }

}


extension Date {

    static let timeIntervalBetween1601AndReferenceDate: TimeInterval = 12622780800

    var timeIntervalSince1601: TimeInterval {
        self.timeIntervalSinceReferenceDate + Self.timeIntervalBetween1601AndReferenceDate
    }

    var windowsFileTime: FILETIME? {
        var ft = FILETIME()
        guard let windowsTicks = UInt64(exactly: timeIntervalSince1601 * 10_000_000) else { return nil }
        ft.dwLowDateTime = DWORD(windowsTicks & 0xFFFFFFFF)
        ft.dwHighDateTime = DWORD(windowsTicks >> 32)
        return ft
    }

    var fileTimeStamp: FileManager.FileTimeStamp {
        let interval = timeIntervalSince1601
        let seconds = Int64(interval)
        let nanoseconds = UInt64(interval.truncatingRemainder(dividingBy: 1) * 1_000_000_000)
        return .init(seconds: seconds, nanoseconds: nanoseconds)
    }
    
}


extension FileManager.FileTimeStamp {

    var windowsFileTime: FILETIME? {
        var ft = FILETIME()
        guard let seconds = UInt64(exactly: seconds) else { return nil }
        let time = seconds * 10_000_000 + nanoseconds / 100
        ft.dwLowDateTime = DWORD(time & 0xFFFFFFFF)
        ft.dwHighDateTime = DWORD(time >> 32)
        return ft
    }

}

#endif