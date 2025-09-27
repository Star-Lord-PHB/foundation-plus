//
//  DateComponentsTest.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/8/16.
//

import Testing
@testable import FoundationPlus


extension DateTest {
    
    @Suite("Test Getting / Setting Date Components")
    final class DateComponentsTest: DateTest {}
    
}



extension DateTest.DateComponentsTest {
    
    @Test(
        "Getting Component",
        arguments: [
            (
                date(year: 2024, month: 8, day: 10),
                .month, 8, calendar()
            ),
            (
                date(year: 2024, hour: 10, minute: 23),
                .minute, 23, calendar()
            ),
            (
                date(year: 2024, hour: 10, minute: 23),
                .hour, 10, calendar()
            ),
            (
                date(year: 2024, month: 6, day: 3),
                .weekday, 2, calendar()
            ),
        ] as [(Date, Calendar.Component, Int, Calendar)]
    )
    func component1(_ date: Date, _ component: Calendar.Component, _ expected: Int, calendar: Calendar) async throws {
        #expect(date.component(component, in: calendar.timeZone, using: calendar) == expected)
    }
    
    
    @Test(
        "Setting Component",
        arguments: [
            // exact match possible
            (
                date(year: 2024, month: 8, day: 10, hour: 10, minute: 32, second: 12, nanosecond: 1000),
                .hour(1), .strict, .auto, .first,
                date(year: 2024, month: 8, day: 10, hour: 1, minute: 32, second: 12, nanosecond: 1000),
                calendar()
            ),
            (
                date(year: 2024, month: 8, day: 10, hour: 10, minute: 32, second: 12),
                .day(20), .strict, .auto, .first,
                date(year: 2024, month: 8, day: 20, hour: 10, minute: 32, second: 12),
                calendar()
            ),
            (
                date(year: 2024, month: 8, day: 10, hour: 10, minute: 32, second: 12),
                .hour(1), .strict, .forward, .first,
                date(year: 2024, month: 8, day: 11, hour: 1, minute: 32, second: 12),
                calendar()
            ),
            (
                date(year: 2024, month: 1, day: 10, hour: 10, minute: 32, second: 12),
                .day(20), .strict, .backward, .first,
                date(year: 2023, month: 12, day: 20, hour: 10, minute: 32, second: 12),
                calendar()
            ),
            // setting impossible value (should always fail reguardless of matching policy)
            (   // 70 hour is not possible
                date(year: 2024, month: 8, day: 10, hour: 10, minute: 32, second: 12),
                .hour(70), .strict, .auto, .first,
                nil,
                calendar()
            ),
            (   // 70 hour is not possible
                date(year: 2024, month: 8, day: 10, hour: 10, minute: 32, second: 12),
                .hour(70), .nextTime, .auto, .first,
                nil,
                calendar()
            ),
            (   // 70 hour is not possible
                date(year: 2024, month: 8, day: 10, hour: 10, minute: 32, second: 12),
                .day(50), .nextTimePreservingSmallerComponents, .auto, .first,
                nil,
                calendar()
            ),
            (   // 0 month is not possible
                date(year: 2024, month: 8, day: 10, hour: 10, minute: 32, second: 12),
                .month(0), .previousTimePreservingSmallerComponents, .auto, .first,
                nil,
                calendar()
            ),
            // special cases for February when setting the day
            (
                date(year: 2025, month: 2, day: 10, hour: 10, minute: 32, second: 12),
                .day(29), .strict, .auto, .first,
                date(year: 2025, month: 3, day: 29, hour: 10, minute: 32, second: 12),
                calendar()
            ),
            (
                date(year: 2025, month: 2, day: 10, hour: 10, minute: 32, second: 12),
                .day(29), .strict, .backward, .first,
                date(year: 2025, month: 1, day: 29, hour: 10, minute: 32, second: 12),
                calendar()
            ),
            (
                date(year: 2025, month: 2, day: 10, hour: 10, minute: 32, second: 12),
                .day(29), .nextTime, .auto, .first,
                date(year: 2025, month: 3, day: 1, hour: 0, minute: 0, second: 0),
                calendar()
            ),
            (
                date(year: 2025, month: 2, day: 10, hour: 10, minute: 32, second: 12),
                .day(29), .nextTimePreservingSmallerComponents, .auto, .first,
                date(year: 2025, month: 3, day: 1, hour: 10, minute: 32, second: 12),
                calendar()
            ),
            (
                date(year: 2025, month: 2, day: 10, hour: 10, minute: 32, second: 12),
                .day(29), .previousTimePreservingSmallerComponents, .auto, .first,
                date(year: 2025, month: 2, day: 28, hour: 10, minute: 32, second: 12),
                calendar()
            ),
            (
                date(year: 2025, month: 2, day: 10, hour: 10, minute: 32, second: 12),
                .day(29), .strict, .auto, .first,
                date(year: 2025, month: 3, day: 29, hour: 10, minute: 32, second: 12),
                calendar()
            ),
            // special cases for February when setting the month
            (
                date(year: 2025, month: 1, day: 29, hour: 10, minute: 32, second: 12),
                .month(2), .strict, .auto, .first,
                date(year: 2028, month: 2, day: 29, hour: 10, minute: 32, second: 12),
                calendar()
            ),
            (
                date(year: 2025, month: 1, day: 29, hour: 10, minute: 32, second: 12),
                .month(2), .strict, .backward, .first,
                date(year: 2024, month: 2, day: 29, hour: 10, minute: 32, second: 12),
                calendar()
            ),
            (
                date(year: 2025, month: 1, day: 30, hour: 10, minute: 32, second: 12),
                .month(2), .strict, .auto, .first,
                nil,
                calendar()
            ),
            (
                date(year: 2025, month: 1, day: 29, hour: 10, minute: 32, second: 12),
                .month(2), .nextTime, .auto, .first,
                date(year: 2025, month: 3, day: 1, hour: 0, minute: 0, second: 0),
                calendar()
            ),
            (
                date(year: 2025, month: 1, day: 29, hour: 10, minute: 32, second: 12),
                .month(2), .nextTimePreservingSmallerComponents, .auto, .first,
                date(year: 2025, month: 3, day: 1, hour: 10, minute: 32, second: 12),
                calendar()
            ),
            (
                date(year: 2025, month: 1, day: 29, hour: 10, minute: 32, second: 12),
                .month(2), .previousTimePreservingSmallerComponents, .auto, .first,
                date(year: 2025, month: 2, day: 28, hour: 10, minute: 32, second: 12),
                calendar()
            ),
            // Special cases for Pacific Daylight Time -> Pacific Standard Time
            (
                date(year: 2025, month: 11, day: 2, hour: 2, minute: 30, second: 5, using: calendar(in: pst)),
                .hour(1), .strict, .auto, .last,
                date(year: 2025, month: 11, day: 2, hour: 1, minute: 30, second: 5, using: calendar(in: pst)),  // 2025-11-02 01:30:05 (America/Los_Angeles) (the first one in this day)
                calendar(in: pst)
            ),
            (
                date(year: 2025, month: 11, day: 2, hour: 2, minute: 30, second: 5, using: calendar(in: pst)),
                .hour(1), .strict, .auto, .first,
                .init(timeIntervalSince1970: 1762075805),   // 2025-11-02 01:30:05 (America/Los_Angeles) (the second one in this day)
                calendar(in: pst)
            ),
            (
                date(year: 2025, month: 11, day: 1, hour: 1, minute: 30, second: 5, using: calendar(in: pst)),
                .day(2), .strict, .auto, .first,
                date(year: 2025, month: 11, day: 2, hour: 1, minute: 30, second: 5, using: calendar(in: pst)),  // 2025-11-02 01:30:05 (America/Los_Angeles) (the first one in this day)
                calendar(in: pst)
            ),
            (
                date(year: 2025, month: 11, day: 1, hour: 1, minute: 30, second: 5, using: calendar(in: pst)),
                .day(2), .strict, .auto, .last,
                .init(timeIntervalSince1970: 1762075805),   // 2025-11-02 01:30:05 (America/Los_Angeles) (the second one in this day)
                calendar(in: pst)
            ),
            // Special cases for Pacific Standard Time -> Pacific Daylight Time
            (
                date(year: 2025, month: 3, day: 9, hour: 1, minute: 30, second: 5, using: calendar(in: pst)),
                .hour(2), .strict, .auto, .first,
                date(year: 2025, month: 3, day: 10, hour: 2, minute: 30, second: 5, using: calendar(in: pst)),
                calendar(in: pst)
            ),
            (
                date(year: 2025, month: 3, day: 9, hour: 1, minute: 30, second: 5, using: calendar(in: pst)),
                .hour(2), .nextTime, .auto, .first,
                date(year: 2025, month: 3, day: 9, hour: 3, minute: 0, second: 0, using: calendar(in: pst)),
                calendar(in: pst)
            ),
            (
                date(year: 2025, month: 3, day: 9, hour: 1, minute: 30, second: 5, using: calendar(in: pst)),
                .hour(2), .nextTimePreservingSmallerComponents, .auto, .first,
                date(year: 2025, month: 3, day: 9, hour: 3, minute: 30, second: 5, using: calendar(in: pst)),
                calendar(in: pst)
            ),
            (
                date(year: 2025, month: 3, day: 9, hour: 0, minute: 30, second: 5, using: calendar(in: pst)),
                .hour(2), .previousTimePreservingSmallerComponents, .auto, .first,
                date(year: 2025, month: 3, day: 9, hour: 1, minute: 30, second: 5, using: calendar(in: pst)),
                calendar(in: pst)
            ),
            (
                date(year: 2025, month: 3, day: 8, hour: 2, minute: 30, second: 5, using: calendar(in: pst)),
                .day(9), .strict, .auto, .first,
                date(year: 2025, month: 4, day: 9, hour: 2, minute: 30, second: 5, using: calendar(in: pst)),
                calendar(in: pst)
            ),
        ] as [(Date, Calendar.ComponentValue, Calendar.MatchingPolicy, Calendar.SetDateComponentSearchDirection, Calendar.RepeatedTimePolicy, Date?, Calendar)]
    )
    func component2(
        _ date: Date,
        _ value: Calendar.ComponentValue,
        _ policy: Calendar.MatchingPolicy,
        _ direction: Calendar.SetDateComponentSearchDirection,
        _ repeated: Calendar.RepeatedTimePolicy,
        _ expected: Date?,
        calendar: Calendar
    ) async throws {
        #expect(date.setting(value, matchPolicy: policy, repeatedTimePolicy: repeated, direction: direction, using: calendar) == expected)
    }
    
}
