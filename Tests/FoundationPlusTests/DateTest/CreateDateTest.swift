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
            [.year, .month, .day, .hour, .minute, .second, .nanosecond],
            [.yearForWeekOfYear, .weekOfYear, .weekday, .hour, .minute, .second, .nanosecond],
            [.year, .month, .weekOfMonth, .weekday, .hour, .minute, .second, .nanosecond]
            
        ] as [Set<Calendar.Component>]
    )
    func create1(_ usedComponents: Set<Calendar.Component>) async throws {
        
        let expectedDate = Date()
        let components = calendar.dateComponents(usedComponents, from: expectedDate)
        
        let actualDate = Date(components: components, calendar: calendar)
        
        #expect(actualDate == expectedDate)
        
    }
    
    
    @available(macOS 15, iOS 18, tvOS 18, watchOS 11, *)
    @Test(
        "Create Date with DateComponents (new apis)",
        arguments: [
            [.year, .dayOfYear, .hour, .minute, .second, .nanosecond]
        ] as [Set<Calendar.Component>]
    )
    func create2(_ usedComponents: Set<Calendar.Component>) async throws {
        
        let expectedDate = Date()
        let components = calendar.dateComponents(usedComponents, from: expectedDate)
        
        let actualDate = Date(components: components, calendar: calendar)
        
        #expect(actualDate == expectedDate)
        
    }
    
    
    @Test(
        "Create Date with Standard String Format",
        arguments: [
            ("2024-08-15 12:04:34 12345", "YYYY-MM-dd HH:mm:ss SSSSS"),
            ("2024.8_15 23:4", "YYYY.M_dd HH:m")
        ]
    )
    func create3(_ string: String, _ format: String) async throws {
        
        let date = try Date(string, format: format, timeZone: timeZone, locale: locale, calendar: calendar)
        
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = locale
        formatter.calendar = calendar
        formatter.dateFormat = format
        
        let expected = formatter.date(from: string)
        
        #expect(expected == date)
        
    }
    
    
#if !os(Windows)

    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    @Test(
        "Create Date with Date.FormatString",
        arguments: [
            (
                "2024-08-15 12:04:34 12345",
                "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits) \(hour: .twoDigits24()):\(minute: .twoDigits):\(second: .twoDigits) \(secondFraction: .fractional(5))" as Date.FormatString
            ),
            (
                "2024.8_15 23:4",
                "\(year: .defaultDigits).\(month: .narrow)_\(day: .twoDigits) \(hour: .twoDigits24()) \(minute: .defaultDigits)"
            ),
        ] as [(String, Date.FormatString)]
    )
    func create4(_ string: String, _ format: Date.FormatString) async throws {
        
        let date = try Date(string, format: format, timeZone: timeZone, locale: locale, calendar: calendar)
        
        let expected = try Date(
            string,
            strategy: Date.ParseStrategy(
                format: format,
                locale: locale,
                timeZone: timeZone,
                calendar: calendar
            )
        )
        
        #expect(expected == date)
        
    }

#endif
    
}
