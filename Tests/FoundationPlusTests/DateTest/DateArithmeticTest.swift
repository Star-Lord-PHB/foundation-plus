//
//  DateArithmeticTest.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/8/16.
//

import Testing
@testable import FoundationPlus


extension DateTest {
    
    @Suite("Test Date Arithmetic")
    final class DateArithmeticTest: DateTest {}
    
}


extension DateTest.DateArithmeticTest {
    
    @Test(
        "Add with Component and Value",
        arguments: [
            (
                DateTest.calendar.date(from: .init(year: 2024, month: 8, day: 1, hour: 14, minute: 32, second: 5))!,
                .day, 1,
                DateTest.calendar.date(from: .init(year: 2024, month: 8, day: 2, hour: 14, minute: 32, second: 5))!
            ),
            (
                DateTest.calendar.date(from: .init(year: 2024, month: 12, day: 1, hour: 14, minute: 32, second: 5))!,
                .month, 1,
                DateTest.calendar.date(from: .init(year: 2025, month: 1, day: 1, hour: 14, minute: 32, second: 5))!
            ),
            (
                DateTest.calendar.date(from: .init(year: 2024, month: 8, day: 1, hour: 23, minute: 50, second: 5))!,
                .minute, 20,
                DateTest.calendar.date(from: .init(year: 2024, month: 8, day: 2, hour: 0, minute: 10, second: 5))!
            ),
        ] as [(Date, Calendar.MeasurableComponent, Int, Date)]
    )
    func arithmetic1(
        _ date: Date,
        _ unit: Calendar.MeasurableComponent,
        _ value: Int,
        _ expected: Date
    ) async throws {
        
        let date = date.adding(unit, by: value, using: calendar)
        #expect(date == expected)
        
    }
    
    
    @Test(
        "Add with Calendar.ComponentValue",
        arguments: [
            (
                DateTest.calendar.date(from: .init(year: 2024, month: 8, day: 1, hour: 14, minute: 32, second: 5))!,
                .day(1),
                DateTest.calendar.date(from: .init(year: 2024, month: 8, day: 2, hour: 14, minute: 32, second: 5))!
            ),
            (
                DateTest.calendar.date(from: .init(year: 2024, month: 12, day: 1, hour: 14, minute: 32, second: 5))!,
                .month(1),
                DateTest.calendar.date(from: .init(year: 2025, month: 1, day: 1, hour: 14, minute: 32, second: 5))!
            ),
            (
                DateTest.calendar.date(from: .init(year: 2024, month: 8, day: 1, hour: 23, minute: 50, second: 5))!,
                .minute(20),
                DateTest.calendar.date(from: .init(year: 2024, month: 8, day: 2, hour: 0, minute: 10, second: 5))!
            ),
        ] as [(Date, Calendar.ComponentValue, Date)]
    )
    func arithmetic2(
        _ date: Date,
        _ duration: Calendar.ComponentValue,
        _ expected: Date
    ) async throws {
        
        let date = date + duration
        #expect(date == expected)
        
    }
    
    
    @Test(
        "Substract with Calendar.ComponentValue",
        arguments: [
            (
                DateTest.calendar.date(from: .init(year: 2024, month: 8, day: 1, hour: 14, minute: 32, second: 5))!,
                .day(1),
                DateTest.calendar.date(from: .init(year: 2024, month: 8, day: 2, hour: 14, minute: 32, second: 5))!
            ),
            (
                DateTest.calendar.date(from: .init(year: 2024, month: 12, day: 1, hour: 14, minute: 32, second: 5))!,
                .month(1),
                DateTest.calendar.date(from: .init(year: 2025, month: 1, day: 1, hour: 14, minute: 32, second: 5))!
            ),
            (
                DateTest.calendar.date(from: .init(year: 2024, month: 8, day: 1, hour: 23, minute: 50, second: 5))!,
                .minute(20),
                DateTest.calendar.date(from: .init(year: 2024, month: 8, day: 2, hour: 0, minute: 10, second: 5))!
            ),
        ] as [(Date, Calendar.ComponentValue, Date)]
    )
    func arithmetic3(
        _ expected: Date,
        _ duration: Calendar.ComponentValue,
        _ date: Date
    ) async throws {
        
        let date = date - duration
        #expect(date == expected)
        
    }
    
}
