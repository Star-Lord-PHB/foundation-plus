//
//  DateQuickAccessorTest.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/8/16.
//

import Testing
@testable import FoundationPlus


extension DateTest {
    
    @Suite("Test Date Quick Accessors")
    class DateQuickAccessorTest: DateTest {}
    
}


extension DateTest.DateQuickAccessorTest {
    
    @Test(
        "Start of Day",
        arguments: [
            (
                date(year: 2024, month: 6, day: 3, hour: 10, minute: 34, second: 23),
                date(year: 2024, month: 6, day: 3)
            ),
            (
                date(year: 2024, month: 6, day: 3, hour: 0, minute: 0, second: 10, nanosecond: 100000),
                date(year: 2024, month: 6, day: 3)
            ),
            (
                date(year: 2024, month: 6, day: 3, hour: 23, minute: 59, second: 59),
                date(year: 2024, month: 6, day: 3)
            ),
        ]
    )
    func accessor1(_ date: Date, _ expected: Date) async throws {
        let startOfDay = date.startOfDay(using: calendar)
        #expect(startOfDay == expected)
    }
    
    
    @Test(
        "Start of Week",
        arguments: [
            date(year: 2024, month: 6, day: 3, hour: 10, minute: 34, second: 23),
            date(year: 2024, month: 6, day: 1, hour: 0, minute: 0, second: 10, nanosecond: 100000),
            date(year: 2024, month: 1, day: 1, hour: 23, minute: 59, second: 59),
        ]
    )
    func accessor2(_ date: Date) async throws {
        
        let startOfWeek = date.startOfWeek(using: calendar)
        let dayDiff = calendar.dateComponents([.day], from: startOfWeek, to: date).day!
        
        #expect(calendar.component(.weekday, from: startOfWeek) == calendar.firstWeekday)
        #expect(dayDiff >= 0 && dayDiff < 7)

    }
    
    
    @Test(
        "Start of Month",
        arguments: [
            date(year: 2024, month: 6, day: 3, hour: 10, minute: 34, second: 23),
            date(year: 2024, month: 6, day: 1, hour: 0, minute: 0, second: 10, nanosecond: 100000),
            date(year: 2024, month: 5, day: 31, hour: 23, minute: 59, second: 59),
        ]
    )
    func accessor3(_ date: Date) async throws {
        
        let startOfMonth = date.startOfMonth(using: calendar)
        
        #expect(calendar.component(.year, from: startOfMonth) == calendar.component(.year, from: date))
        #expect(calendar.component(.month, from: startOfMonth) == calendar.component(.month, from: date))
        #expect(calendar.component(.day, from: startOfMonth) == 1)
        #expect(calendar.component(.hour, from: startOfMonth) == 0)
        #expect(calendar.component(.minute, from: startOfMonth) == 0)
        #expect(calendar.component(.second, from: startOfMonth) == 0)
        #expect(calendar.component(.nanosecond, from: startOfMonth) == 0)
        
    }
    
    
    @Test(
        "Trimming",
        arguments: [
            (
                Self.date(year: 2024, month: 6, day: 3, hour: 10, minute: 34, second: 23),
                .day,
                Self.date(year: 2024, month: 6, day: 3)
            ),
            (
                Self.date(year: 2024, month: 6, day: 3, hour: 0, minute: 0, second: 10, nanosecond: 100000),
                .month,
                Self.date(year: 2024, month: 6)
            ),
            (
                Self.date(year: 2024, month: 6, day: 3, hour: 23, minute: 59, second: 59),
                .hour,
                Self.date(year: 2024, month: 6, day: 3, hour: 23)
            ),
        ] as [(Date, Calendar.MeasurableComponent, Date)]
    )
    func accessor4(_ date: Date, _ trimmingUnit: Calendar.MeasurableComponent, _ expected: Date) async throws {
        #expect(date.trimming(to: trimmingUnit, using: calendar) == expected)
    }
    
    
    @Test(
        "DateInterval",
        arguments: [
            (date(year: 2024, month: 2, day: 1), .month),
            (date(year: 2023, month: 2, day: 10), .month),
            (date(year: 2024, month: 1, day: 1), .year)
        ] as [(Date, Calendar.MeasurableComponent)]
    )
    func accessor5(_ date: Date, _ component: Calendar.MeasurableComponent) async throws {
        let interval = date.interval(of: component, using: calendar)
        #expect(interval == calendar.dateInterval(of: component.component, for: date))
    }
    
}
