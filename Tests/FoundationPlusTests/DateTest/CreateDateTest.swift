//
//  CreateDateTest.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/8/15.
//

import Testing
@testable import FoundationPlus


extension DateTest {
    
    @Suite("Test Creating Date")
    final class CreateDateTest: DateTest {}
    
}


extension DateTest.CreateDateTest {

    @Test(
        "Create Date with DateComponents",
        arguments: [
            (
                .init(year: 2025, month: 1, day: 2, hour: 8, minute: 1, second: 45, nanosecond: 300), 
                calendar()
            ),
            (
                .init(year: 2025, month: 1, day: 32, hour: 8, minute: 1, second: 70, nanosecond: 300), 
                calendar()
            ),
            (
                .init(hour: 8, minute: 1, second: 45, nanosecond: 300, weekday: 1, weekOfYear: 10, yearForWeekOfYear: 2025), 
                calendar()
            ),
            (
                .init(year: 2025, month: 5, hour: 8, minute: 1, second: 45, nanosecond: 300, weekday: 1, weekOfMonth: 7), 
                calendar()
            ),
            (
                .init(year: 2025, month: 2, day: 29), 
                calendar()
            ),
            (
                .init(year: 2025, month: 3, day: 9, hour: 2, minute: 30, second: 0), 
                calendar(in: pst)
            ),
        ] as [(DateComponents, Calendar)]
    )
    func createComponents1(_ components: DateComponents, calendar: Calendar) async throws {
        
        let expected = calendar.date(from: components)
        let actualDate = Date(components: components, calendar: calendar)
        #expect(actualDate == expected)
        
    }


    @available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
    @Test(
        "Create Date with DateComponents (new apis)",
        arguments: [
            (
                .init(year: 2025, hour: 8, minute: 1, second: 45, nanosecond: 300, dayOfYear: 145),
                calendar()
            ),
            (
                .init(year: 2024, hour: 8, minute: 1, second: 45, nanosecond: 300, dayOfYear: 368),
                calendar()
            ),
            (
                .init(year: 2024, month: 2, day: 29, hour: 8, minute: 1, second: 45, nanosecond: 300, dayOfYear: 100),
                calendar()
            ),
        ] as [(DateComponents, Calendar)]
    )
    func createComponents2(_ components: DateComponents, calendar: Calendar) async throws {
        
        let expected = calendar.date(from: components)
        let actualDate = Date(components: components, calendar: calendar)
        #expect(actualDate == expected)
        
    }
    
    
    @Test(
        "Create Date with Standard String Format",
        arguments: [
            ("2024-08-15 12:04:34 12345", "YYYY-MM-dd HH:mm:ss SSSSS", calendar()),
            ("2024.8_15 23:4", "YYYY.M_dd HH:m", calendar())
        ]
    )
    func createParse1(_ string: String, _ format: String, calendar: Calendar) async throws {
        
        let date = try Date(string, formatString: format, timeZone: calendar.timeZone, locale: calendar.locale, calendar: calendar)
        
        let formatter = DateFormatter()
        formatter.timeZone = calendar.timeZone
        formatter.locale = calendar.locale
        formatter.calendar = calendar
        formatter.dateFormat = format
        
        let expected = formatter.date(from: string)
        
        #expect(expected == date)
        
    }
    
    
#if !os(Windows)    // for some reason, the FormatString arguments fail to compile on Windows

    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    @Test(
        "Create Date with Date.FormatString",
        arguments: [
            (
                "2024-08-15 12:04:34 12345",
                "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits) \(hour: .twoDigits24()):\(minute: .twoDigits):\(second: .twoDigits) \(secondFraction: .fractional(5))",
                calendar()
            ),
            (
                "2024.8_15 23:4",
                "\(year: .defaultDigits).\(month: .narrow)_\(day: .twoDigits) \(hour: .twoDigits24()) \(minute: .defaultDigits)",
                calendar()
            ),
        ] as [(String, Date.FormatString, Calendar)]
    )
    func createParse2(_ string: String, _ format: Date.FormatString, calendar: Calendar) async throws {

        let date = try Date(string, format: format, timeZone: calendar.timeZone, locale: calendar.locale, calendar: calendar)

        let expected = try Date(
            string,
            strategy: Date.ParseStrategy(
                format: format,
                locale: calendar.locale,
                timeZone: calendar.timeZone,
                calendar: calendar
            )
        )
        
        #expect(expected == date)
        
    }

#endif
    
}



extension DateComponents {

    @available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
    init(
        year: Int? = nil, 
        month: Int? = nil, 
        day: Int? = nil, 
        hour: Int? = nil, 
        minute: Int? = nil, 
        second: Int? = nil, 
        nanosecond: Int? = nil, 
        weekday: Int? = nil, 
        weekOfYear: Int? = nil, 
        yearForWeekOfYear: Int? = nil, 
        weekOfMonth: Int? = nil, 
        dayOfYear: Int
    ) {
        self.init(
            year: year, 
            month: month, 
            day: day, 
            hour: hour, 
            minute: minute, 
            second: second, 
            nanosecond: nanosecond, 
            weekday: weekday, 
            weekOfMonth: weekOfMonth, 
            weekOfYear: weekOfYear, 
            yearForWeekOfYear: yearForWeekOfYear
        )
        self.dayOfYear = dayOfYear
    }

}