//
//  DateComparisonTest.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/8/16.
//

import Testing
@testable import FoundationPlus


extension DateTest {
    
    @Suite("Test Date Comparison")
    class DateComparisonTest: DateTest {}
    
}


extension DateTest.DateComparisonTest {
    
    @Test(
        "Compare Equals",
        arguments: [
            (
                DateTest.calendar.date(from: .init(year: 2024, month: 3, day: 5, hour: 14, minute: 34, second: 2))!,
                DateTest.calendar.date(from: .init(year: 2024, month: 4, day: 1, hour: 1, minute: 20, second: 12))!,
                .year, true
            ),
            (
                DateTest.calendar.date(from: .init(year: 2023, month: 3, day: 5, hour: 14, minute: 34, second: 2))!,
                DateTest.calendar.date(from: .init(year: 2023, month: 5, day: 5, hour: 15, minute: 32, second: 12))!,
                .day, false
            ),
            (
                DateTest.calendar.date(from: .init(year: 2024, month: 4, day: 5, hour: 14, minute: 34, second: 2))!,
                DateTest.calendar.date(from: .init(year: 2024, month: 3, day: 5, hour: 14, minute: 34, second: 2))!,
                .month, false
            ),
            (
                DateTest.calendar.date(from: .init(year: 2024, month: 4, day: 5, hour: 14, minute: 22, second: 2))!,
                DateTest.calendar.date(from: .init(year: 2024, month: 3, day: 5, hour: 14, minute: 34, second: 2))!,
                .minute, false
            ),
        ] as [(Date, Date, Calendar.Component, Bool)]
    )
    func compare1(
        _ date1: Date,
        _ date2: Date,
        _ compareUnit: Calendar.Component,
        _ expected: Bool
    ) async throws {
        #expect(date1.equals(to: date2, in: compareUnit, using: calendar) == expected)
    }
    
    
    @Test(
        "Compare larger",
        arguments: [
            (
                DateTest.calendar.date(from: .init(year: 2024, month: 3, day: 5, hour: 14, minute: 34, second: 2))!,
                DateTest.calendar.date(from: .init(year: 2024, month: 4, day: 1, hour: 1, minute: 20, second: 12))!,
                .year, false
            ),
            (
                DateTest.calendar.date(from: .init(year: 2023, month: 6, day: 5, hour: 14, minute: 34, second: 2))!,
                DateTest.calendar.date(from: .init(year: 2023, month: 5, day: 5, hour: 15, minute: 32, second: 12))!,
                .day, true
            ),
            (
                DateTest.calendar.date(from: .init(year: 2025, month: 3, day: 5, hour: 14, minute: 34, second: 2))!,
                DateTest.calendar.date(from: .init(year: 2024, month: 3, day: 6, hour: 14, minute: 34, second: 2))!,
                .month, true
            ),
            (
                DateTest.calendar.date(from: .init(year: 2024, month: 3, day: 5, hour: 14, minute: 22, second: 2))!,
                DateTest.calendar.date(from: .init(year: 2024, month: 3, day: 5, hour: 14, minute: 34, second: 2))!,
                .minute, false
            ),
        ] as [(Date, Date, Calendar.Component, Bool)]
    )
    func compare2(
        _ date1: Date,
        _ date2: Date,
        _ compareUnit: Calendar.Component,
        _ expected: Bool
    ) async throws {
        #expect(date1.larger(than: date2, in: compareUnit, using: calendar) == expected)
    }
    
    
    @Test(
        "Compare Smaller",
        arguments: [
            (
                DateTest.calendar.date(from: .init(year: 2024, month: 3, day: 5, hour: 14, minute: 34, second: 2))!,
                DateTest.calendar.date(from: .init(year: 2024, month: 4, day: 1, hour: 1, minute: 20, second: 12))!,
                .year, false
            ),
            (
                DateTest.calendar.date(from: .init(year: 2023, month: 5, day: 5, hour: 15, minute: 32, second: 12))!,
                DateTest.calendar.date(from: .init(year: 2023, month: 6, day: 5, hour: 14, minute: 34, second: 2))!,
                .day, true
            ),
            (
                DateTest.calendar.date(from: .init(year: 2025, month: 3, day: 5, hour: 14, minute: 34, second: 2))!,
                DateTest.calendar.date(from: .init(year: 2024, month: 3, day: 6, hour: 14, minute: 34, second: 2))!,
                .month, false
            ),
            (
                DateTest.calendar.date(from: .init(year: 2024, month: 3, day: 5, hour: 14, minute: 22, second: 2))!,
                DateTest.calendar.date(from: .init(year: 2024, month: 3, day: 5, hour: 14, minute: 34, second: 2))!,
                .minute, true
            ),
        ] as [(Date, Date, Calendar.Component, Bool)]
    )
    func compare3(
        _ date1: Date,
        _ date2: Date,
        _ compareUnit: Calendar.Component,
        _ expected: Bool
    ) async throws {
        #expect(date1.smaller(than: date2, in: compareUnit, using: calendar) == expected)
    }
    
}
