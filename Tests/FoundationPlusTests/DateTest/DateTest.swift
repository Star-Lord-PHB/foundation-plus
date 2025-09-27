//
//  DateTest.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/8/16.
//

import Testing
import Foundation


class DateTest {


    static let gmt = TimeZone.gmt
    static let pst = TimeZone(identifier: "America/Los_Angeles")!
    static let en_US = Locale(identifier: "en_US")


    var gmt: TimeZone { Self.gmt }
    var pst: TimeZone { Self.pst }

    var en_US: Locale { Self.en_US }
    

    static func calendar(_ identifier: Calendar.Identifier = .gregorian, in timeZone: TimeZone = gmt, locale: Locale = en_US) -> Calendar {
        var calendar = Calendar(identifier: identifier)
        calendar.timeZone = timeZone
        calendar.locale = locale
        return calendar
    }


    static func gregorianCalendar(in timeZone: TimeZone = gmt, locale: Locale = en_US) -> Calendar {
        calendar(.gregorian, in: timeZone, locale: locale)
    }


    func calendar(_ identifier: Calendar.Identifier = .gregorian, in timeZone: TimeZone = gmt, locale: Locale = en_US) -> Calendar {
        Self.calendar(identifier, in: timeZone, locale: locale)
    }


    func gregorianCalendar(in timeZone: TimeZone = gmt, locale: Locale = en_US) -> Calendar {
        Self.gregorianCalendar(in: timeZone, locale: locale)
    }
    
    
    static func date(
        era: Int? = nil,
        year: Int? = nil,
        month: Int? = nil,
        day: Int? = nil,
        hour: Int? = nil,
        minute: Int? = nil,
        second: Int? = nil,
        nanosecond: Int? = nil,
        weekday: Int? = nil,
        weekdayOrdinal: Int? = nil,
        quarter: Int? = nil,
        weekOfMonth: Int? = nil,
        weekOfYear: Int? = nil,
        yearForWeekOfYear: Int? = nil,
        using calendar: Calendar = calendar()
    ) -> Date {
        calendar.date(
            from: .init(
                calendar: calendar,
                timeZone: calendar.timeZone,
                era: era,
                year: year,
                month: month,
                day: day,
                hour: hour,
                minute: minute,
                second: second,
                nanosecond: nanosecond,
                weekday: weekday,
                weekdayOrdinal: weekdayOrdinal,
                quarter: quarter,
                weekOfMonth: weekOfMonth,
                weekOfYear: weekOfYear,
                yearForWeekOfYear: yearForWeekOfYear
            )
        )!
    }
    
    
    func date(
        era: Int? = nil,
        year: Int? = nil,
        month: Int? = nil,
        day: Int? = nil,
        hour: Int? = nil,
        minute: Int? = nil,
        second: Int? = nil,
        nanosecond: Int? = nil,
        weekday: Int? = nil,
        weekdayOrdinal: Int? = nil,
        quarter: Int? = nil,
        weekOfMonth: Int? = nil,
        weekOfYear: Int? = nil,
        yearForWeekOfYear: Int? = nil,
        using calendar: Calendar = calendar()
    ) -> Date {
        Self.date(
            era: era,
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second,
            nanosecond: nanosecond,
            weekday: weekday,
            weekdayOrdinal: weekdayOrdinal,
            quarter: quarter,
            weekOfMonth: weekOfMonth,
            weekOfYear: weekOfYear,
            yearForWeekOfYear: yearForWeekOfYear,
            using: calendar
        )
    }
    
}
