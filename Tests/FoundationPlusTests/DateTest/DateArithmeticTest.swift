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
                date(year: 2024, month: 8, day: 1, hour: 14, minute: 32, second: 5),
                .day, 1,
                date(year: 2024, month: 8, day: 2, hour: 14, minute: 32, second: 5),
                calendar()
            ),
            (
                date(year: 2024, month: 8, day: 1, hour: 14, minute: 32, second: 5),
                .day, -1,
                date(year: 2024, month: 7, day: 31, hour: 14, minute: 32, second: 5),
                calendar()
            ),
            (
                date(year: 2024, month: 12, day: 1, hour: 14, minute: 32, second: 5),
                .month, 1,
                date(year: 2025, month: 1, day: 1, hour: 14, minute: 32, second: 5),
                calendar()
            ),
            (
                date(year: 2024, month: 8, day: 1, hour: 23, minute: 50, second: 5),
                .minute, 20,
                date(year: 2024, month: 8, day: 2, hour: 0, minute: 10, second: 5),
                calendar()
            ),
            (   // Test end of month
                date(year: 2024, month: 1, day: 31, hour: 23, minute: 50, second: 5),
                .month, 1,
                date(year: 2024, month: 2, day: 29, hour: 23, minute: 50, second: 5),
                calendar()
            ),
            (   // Test Pacific Standard Time -> Pacific Daylight Time
                date(year: 2025, month: 3, day: 9, hour: 1, minute: 30, second: 5, using: calendar(in: pst)),
                .hour, 1,
                date(year: 2025, month: 3, day: 9, hour: 3, minute: 30, second: 5, using: calendar(in: pst)),
                calendar(in: pst)
            ),
            (   // Test Pacific Daylight Time -> Pacific Standard Time
                date(year: 2025, month: 11, day: 2, hour: 1, minute: 30, second: 5, using: calendar(in: pst)),  // 2025-11-02 01:30:05 (America/Los_Angeles) (the first one in this day)
                .hour, 1,
                .init(timeIntervalSince1970: 1762075805),                                                       // 2025-11-02 01:30:05 (America/Los_Angeles) (the second one in this day)
                calendar(in: pst)
            ),
        ] as [(Date, Calendar.MeasurableComponent, Int, Date, Calendar)]
    )
    func arithmetic1(
        _ date: Date,
        _ unit: Calendar.MeasurableComponent,
        _ value: Int,
        _ expected: Date,
        calendar: Calendar
    ) async throws {
        
        let date = date.adding(unit, by: value, using: calendar)
        #expect(date == expected)
        
    }
    
    
    @Test(
        "Add with Calendar.ComponentValue",
        arguments: [
            (
                date(year: 2024, month: 8, day: 1, hour: 14, minute: 32, second: 5),
                .day(1),
                date(year: 2024, month: 8, day: 2, hour: 14, minute: 32, second: 5),
                calendar()
            ),
            (
                date(year: 2024, month: 8, day: 1, hour: 14, minute: 32, second: 5),
                .day(-1),
                date(year: 2024, month: 7, day: 31, hour: 14, minute: 32, second: 5),
                calendar()
            ),
            (
                date(year: 2024, month: 12, day: 1, hour: 14, minute: 32, second: 5),
                .month(1),
                date(year: 2025, month: 1, day: 1, hour: 14, minute: 32, second: 5),
                calendar()
            ),
            (
                date(year: 2024, month: 8, day: 1, hour: 23, minute: 50, second: 5),
                .minute(20),
                date(year: 2024, month: 8, day: 2, hour: 0, minute: 10, second: 5),
                calendar()
            ),
            (   // Test end of month
                date(year: 2024, month: 1, day: 31, hour: 23, minute: 50, second: 5),
                .month(1),
                date(year: 2024, month: 2, day: 29, hour: 23, minute: 50, second: 5),
                calendar()
            ),
            (   // Test Pacific Standard Time -> Pacific Daylight Time
                date(year: 2025, month: 3, day: 9, hour: 1, minute: 30, second: 5, using: calendar(in: pst)),
                .hour(1),
                date(year: 2025, month: 3, day: 9, hour: 3, minute: 30, second: 5, using: calendar(in: pst)),
                calendar(in: pst)
            ),
            (   // Test Pacific Daylight Time -> Pacific Standard Time
                date(year: 2025, month: 11, day: 2, hour: 1, minute: 30, second: 5, using: calendar(in: pst)),  // 2025-11-02 01:30:05 (America/Los_Angeles) (the first one in this day)
                .hour(1),
                .init(timeIntervalSince1970: 1762075805),                                                       // 2025-11-02 01:30:05 (America/Los_Angeles) (the second one in this day)
                calendar(in: pst)
            ),
        ] as [(Date, Calendar.ComponentValue, Date, Calendar)]
    )
    func arithmetic2(
        _ date: Date,
        _ duration: Calendar.ComponentValue,
        _ expected: Date,
        calendar: Calendar
    ) async throws {
        
        let date = date + duration
        #expect(date == expected)
        
    }
    
    
    @Test(
        "Substract with Calendar.ComponentValue",
        arguments: [
            (
                date(year: 2024, month: 7, day: 31, hour: 14, minute: 32, second: 5),
                .day(1),
                date(year: 2024, month: 8, day: 1, hour: 14, minute: 32, second: 5),
                calendar()
            ),
            (
                date(year: 2024, month: 8, day: 1, hour: 14, minute: 32, second: 5),
                .day(-1),
                date(year: 2024, month: 7, day: 31, hour: 14, minute: 32, second: 5),
                calendar()
            ),
            (
                date(year: 2024, month: 12, day: 1, hour: 14, minute: 32, second: 5),
                .month(1),
                date(year: 2025, month: 1, day: 1, hour: 14, minute: 32, second: 5),
                calendar()
            ),
            (
                date(year: 2024, month: 8, day: 1, hour: 23, minute: 50, second: 5),
                .minute(20),
                date(year: 2024, month: 8, day: 2, hour: 0, minute: 10, second: 5),
                calendar()
            ),
            (   // Test end of month
                date(year: 2024, month: 2, day: 29, hour: 23, minute: 50, second: 5),
                .month(1),
                date(year: 2024, month: 3, day: 31, hour: 23, minute: 50, second: 5),
                calendar()
            ),
            (   // Test Pacific Daylight Time -> Pacific Standard Time
                date(year: 2025, month: 3, day: 9, hour: 1, minute: 30, second: 5, using: calendar(in: pst)),
                .hour(1),
                date(year: 2025, month: 3, day: 9, hour: 3, minute: 30, second: 5, using: calendar(in: pst)),
                calendar(in: pst)
            ),
            (   // Test Pacific Standard Time -> Pacific Daylight Time
                date(year: 2025, month: 11, day: 2, hour: 1, minute: 30, second: 5, using: calendar(in: pst)),  // 2025-11-02 01:30:05 (America/Los_Angeles) (the first one in this day)
                .hour(1),
                .init(timeIntervalSince1970: 1762075805),                                                       // 2025-11-02 01:30:05 (America/Los_Angeles) (the second one in this day)
                calendar(in: pst)
            ),
        ] as [(Date, Calendar.ComponentValue, Date, Calendar)]
    )
    func arithmetic3(
        _ expected: Date,
        _ duration: Calendar.ComponentValue,
        _ date: Date,
        calendar: Calendar
    ) async throws {
        
        let date = date.adding(-duration, using: calendar)
        #expect(date == expected)
        
    }
    
}
