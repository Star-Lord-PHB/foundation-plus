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
    final class DateQuickAccessorTest: DateTest {}
    
}


extension DateTest.DateQuickAccessorTest {
    
    @Test(
        "Start of Day",
        arguments: [
            (
                date(year: 2024, month: 6, day: 3, hour: 10, minute: 34, second: 23),
                date(year: 2024, month: 6, day: 3),
                calendar()
            ),
            (
                date(year: 2024, month: 6, day: 3, hour: 0, minute: 0, second: 10, nanosecond: 100000),
                date(year: 2024, month: 6, day: 3),
                calendar()
            ),
            (
                date(year: 2024, month: 6, day: 3, hour: 23, minute: 59, second: 59),
                date(year: 2024, month: 6, day: 3),
                calendar()
            ),
        ]
    )
    func accessor1(_ date: Date, _ expected: Date, calendar: Calendar) async throws {
        let startOfDay = date.startOfDay(using: calendar)
        #expect(startOfDay == expected)
    }
    
    
    @Test(
        "Start of Week",
        arguments: [
            (
                date(year: 2024, month: 6, day: 3, hour: 10, minute: 34, second: 23), 
                calendar()
            ),
            (
                date(year: 2024, month: 6, day: 1, hour: 0, minute: 0, second: 10, nanosecond: 100000), 
                calendar()
            ),
            (
                date(year: 2024, month: 1, day: 1, hour: 23, minute: 59, second: 59), 
                calendar()
            ),
        ]
    )
    func accessor2(_ date: Date, calendar: Calendar) async throws {
        
        let startOfWeek = date.startOfWeek(using: calendar)
        let dayDiff = calendar.dateComponents([.day], from: startOfWeek, to: date).day!
        
        #expect(calendar.component(.weekday, from: startOfWeek) == calendar.firstWeekday)
        #expect(dayDiff >= 0 && dayDiff < 7)

    }
    
    
    @Test(
        "Start of Month",
        arguments: [
            (
                date(year: 2024, month: 6, day: 3, hour: 10, minute: 34, second: 23), 
                calendar()
            ),
            (
                date(year: 2024, month: 6, day: 1, hour: 0, minute: 0, second: 10, nanosecond: 100000), 
                calendar()
            ),
            (
                date(year: 2024, month: 5, day: 31, hour: 23, minute: 59, second: 59), 
                calendar()
            ),
        ]
    )
    func accessor3(_ date: Date, calendar: Calendar) async throws {
        
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
                Self.date(year: 2024, month: 6, day: 3),
                calendar()
            ),
            (
                Self.date(year: 2024, month: 6, day: 3, hour: 0, minute: 0, second: 10, nanosecond: 100000),
                .month,
                Self.date(year: 2024, month: 6),
                calendar()
            ),
            (
                Self.date(year: 2024, month: 6, day: 3, hour: 23, minute: 59, second: 59),
                .hour,
                Self.date(year: 2024, month: 6, day: 3, hour: 23),
                calendar()
            ),
        ] as [(Date, Calendar.MeasurableComponent, Date, Calendar)]
    )
    func accessor4(_ date: Date, _ trimmingUnit: Calendar.MeasurableComponent, _ expected: Date, _ calendar: Calendar) async throws {
        #expect(date.trimming(to: trimmingUnit, using: calendar) == expected)
    }
    
    
    @Test(
        "DateInterval",
        arguments: [
            (
                date(year: 2024, month: 2, day: 1), 
                .month, calendar()
            ),
            (
                date(year: 2023, month: 2, day: 10), 
                .month, calendar()
            ),
            (
                date(year: 2024, month: 1, day: 1), 
                .year, calendar()
            ),
        ] as [(Date, Calendar.MeasurableComponent, Calendar)]
    )
    func accessor5(_ date: Date, _ component: Calendar.MeasurableComponent, _ calendar: Calendar) async throws {
        let interval = date.interval(of: component, using: calendar)
        #expect(interval == calendar.dateInterval(of: component.rawValue, for: date))
    }


    @Test(
        "Next Day",
        arguments: [
            (
                date(year: 2024, month: 6, day: 3, hour: 10, minute: 34, second: 23),
                date(year: 2024, month: 6, day: 4),
                .init(year: 2024, month: 6, day: 4),
                .strict, .first, .forward, calendar()
            ),
            (
                date(year: 2025, month: 2, day: 1, hour: 10, minute: 34, second: 23),
                date(year: 2025, month: 3, day: 29, hour: 10),
                .init(year: 2025, day: 29, hour: 10),
                .strict, .first, .forward, calendar()
            ),
            (
                date(year: 2025, month: 2, day: 1, hour: 10, minute: 34, second: 23),
                date(year: 2025, month: 3, day: 1),
                .init(month: 2, day: 29, hour: 10),
                .nextTime, .first, .forward, calendar()
            ),
            (
                date(hour: 10, minute: 34, second: 23, weekday: 2, weekOfYear: 10, yearForWeekOfYear:2025),
                date(weekday: 1, weekOfYear: 11, yearForWeekOfYear:2025),
                .init(weekday: 1),
                .strict, .first, .forward, calendar()
            ),
            (
                date(hour: 10, minute: 34, second: 23, weekday: 2, weekOfYear: 10, yearForWeekOfYear:2025),
                date(weekday: 3, weekOfYear: 9, yearForWeekOfYear:2025),
                .init(weekday: 3),
                .strict, .first, .backward, calendar()
            ),
        ] as [(Date, Date, DateComponents, Calendar.MatchingPolicy, Calendar.RepeatedTimePolicy, Calendar.SearchDirection, Calendar)]
    )
    func accessor6(
        _ date: Date,
        _ expected: Date,
        _ match: DateComponents,
        _ matchPolicy: Calendar.MatchingPolicy,
        _ repeatedTimePolicy: Calendar.RepeatedTimePolicy,
        _ direction: Calendar.SearchDirection,
        calendar: Calendar
    ) async throws {

        let next = date.nextDate(
            matching: match, 
            matchingPolicy: matchPolicy, 
            repeatedTimePolicy: repeatedTimePolicy, 
            direction: direction, 
            using: calendar
        )

        #expect(next == expected)

    }
    
}
