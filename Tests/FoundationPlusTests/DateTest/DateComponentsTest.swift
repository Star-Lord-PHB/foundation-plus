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
                Self.calendar.date(from: .init(year: 2024, month: 8, day: 10))!,
                .month, 8
            ),
            (
                Self.calendar.date(from: .init(year: 2024, hour: 10, minute: 23))!,
                .minute, 23
            ),
            (
                Self.calendar.date(from: .init(year: 2024, hour: 10, minute: 23))!,
                .hour, 10
            ),
            (
                Self.calendar.date(from: .init(year: 2024, month: 6, day: 3))!,
                .weekday, nil
            ),
        ] as [(Date, Calendar.Component, Int?)]
    )
    func component1(_ date: Date, _ component: Calendar.Component, _ expected: Int?) async throws {
        let expected = expected ?? calendar.component(component, from: date)
        #expect(date.component(component, in: timeZone, using: calendar) == expected)
    }
    
    
    @Test(
        "Setting Component",
        arguments: [
            (
                date(year: 2024, month: 8, day: 10, hour: 10, minute: 32, second: 12),
                .hour(1), .strict,
                date(year: 2024, month: 8, day: 11, hour: 1, minute: 32, second: 12)
            ),
            (
                date(year: 2023, month: 2, day: 10, hour: 10, minute: 32, second: 12),
                .day(29), .nextTimePreservingSmallerComponents,
                date(year: 2023, month: 3, day: 1, hour: 10, minute: 32, second: 12)
            ),
            (
                date(year: 2024, month: 2, day: 10, hour: 10, minute: 32, second: 12),
                .day(29), .strict,
                date(year: 2024, month: 2, day: 29, hour: 10, minute: 32, second: 12)
            ),
            (
                date(year: 2024, month: 8, day: 18, hour: 13, minute: 5, second: 34),
                .weekday(1), .strict,
                date(year: 2024, month: 8, day: 18, hour: 13, minute: 5, second: 34)
            ),
            (
                date(year: 2024, month: 8, day: 18, hour: 13, minute: 5, second: 34),
                .weekday(2), .strict,
                date(year: 2024, month: 8, day: 19, hour: 13, minute: 5, second: 34)
            ),
        ] as [(Date, Calendar.ComponentValue, Calendar.MatchingPolicy, Date)]
    )
    func component2(
        _ date: Date,
        _ value: Calendar.ComponentValue,
        _ policy: Calendar.MatchingPolicy,
        _ expected: Date
    ) async throws {
        #expect(date.setting(value, matchPolicy: policy, in: timeZone, using: calendar) == expected)
    }
    
}
