//
//  DateTest.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/8/16.
//

import Testing
import Foundation


class DateTest {
    
    static let calendar: Calendar = .autoupdatingCurrent
    static let timeZone: TimeZone = .autoupdatingCurrent
    static let locale: Locale = .autoupdatingCurrent
    
    var calendar: Calendar { Self.calendar }
    var timeZone: TimeZone { Self.timeZone }
    var locale: Locale { Self.locale }
    
    
    static func date(
        calendar: Calendar = calendar,
        timeZone: TimeZone = timeZone,
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
        yearForWeekOfYear: Int? = nil
    ) -> Date {
        calendar.date(
            from: .init(
                calendar: calendar,
                timeZone: timeZone,
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
        calendar: Calendar = calendar,
        timeZone: TimeZone = timeZone,
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
        yearForWeekOfYear: Int? = nil
    ) -> Date {
        Self.date(
            calendar: calendar,
            timeZone: timeZone,
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
    }
    
}
