import Testing
import Foundation
@testable import DatePlus


extension DateTest {

    @Suite("Test Date Enumeration")
    class DateEnumerationTest: DateTest {}

}



extension DateTest.DateEnumerationTest {

    @available(macOS 15, iOS 18, tvOS 18, watchOS 11, *)
    @Test(
        "Enumeration by Adding",
        arguments: [
            (
                date(year: 2025, month: 2, day: 25, hour: 10, minute: 30, second: 5),
                .day(2),
                date(year: 2025, month: 2, day: 27, hour: 10, minute: 30, second: 3) ..< date(year: 2025, month: 3, day: 3, hour: 10, minute: 29, second: 5),
                [
                    date(year: 2025, month: 2, day: 27, hour: 10, minute: 30, second: 5),
                    date(year: 2025, month: 3, day: 1, hour: 10, minute: 30, second: 5)
                ],
                calendar()
            ),
            (
                date(year: 2025, month: 2, day: 25, hour: 10, minute: 30, second: 5),
                .day(2),
                date(year: 2025, month: 2, day: 27, hour: 10, minute: 30, second: 10) ..< date(year: 2025, month: 3, day: 3, hour: 10, minute: 29, second: 5),
                [],
                calendar()
            ),
            (
                date(year: 2025, month: 1, day: 31, hour: 10, minute: 30, second: 5),
                .month(1),
                date(year: 2025, month: 1, day: 31, hour: 10, minute: 30, second: 5) ..< date(year: 2025, month: 5, day: 1),
                [
                    date(year: 2025, month: 2, day: 28, hour: 10, minute: 30, second: 5),
                    date(year: 2025, month: 3, day: 31, hour: 10, minute: 30, second: 5),
                    date(year: 2025, month: 4, day: 30, hour: 10, minute: 30, second: 5)
                ],
                calendar()
            )
        ] as [(Date, Calendar.ComponentValue, Range<Date>, [Date], Calendar)]
    )
    func testEnumerationByAdding(
        startingDate: Date, 
        component: Calendar.ComponentValue, 
        range: Range<Date>, 
        expected: [Date],
        calendar: Calendar
    ) async throws {
        
        let sequence = startingDate.nextDates(byAdding: component, in: range, using: calendar)

        try #require(
            Array(sequence.prefix(expected.count + 1)).count == expected.count, 
            "Sequence must not be infinite and must have expected number of elements"
        )

        #expect(Array(sequence) == expected)

    }


    @available(macOS 15, iOS 18, tvOS 18, watchOS 11, *)
    @Test(
        "Enumeration by Matching (Compat version)", .timeLimit(.minutes(1)),
        arguments: [
            (
                date(year: 2025, month: 2, day: 25, hour: 10, minute: 30, second: 5),
                .init(hour: 10, minute: 30),
                date(year: 2025, month: 2, day: 20) ..< date(year: 2025, month: 3, day: 3),
                .nextTimePreservingSmallerComponents, .first, .forward,
                calendar()
            ),
            (
                date(year: 2025, month: 1, day: 25, hour: 10, minute: 30, second: 5),
                .init(day: 31, hour: 10, minute: 30),
                date(year: 2025, month: 1, day: 20) ..< date(year: 2026, month: 1, day: 1),
                .strict, .first, .forward,
                calendar()
            ),
            (
                date(year: 2025, month: 1, day: 25, hour: 10, minute: 30, second: 5),
                .init(day: 31, hour: 10, minute: 30),
                date(year: 2025, month: 1, day: 20) ..< date(year: 2026, month: 1, day: 1),
                .previousTimePreservingSmallerComponents, .first, .forward,
                calendar()
            ),
            (
                date(year: 2025, month: 1, day: 25, hour: 10, minute: 30, second: 5),
                .init(day: 31, hour: 10, minute: 30),
                date(year: 2025, month: 1, day: 31, hour: 11) ..< date(year: 2026, month: 1, day: 1),
                .previousTimePreservingSmallerComponents, .first, .forward,
                calendar()
            ),
        ] as [(Date, DateComponents, Range<Date>, Calendar.MatchingPolicy, Calendar.RepeatedTimePolicy, Calendar.SearchDirection, Calendar)]
    )
    func testEnumerationByMatchingCompat(
        startingDate: Date,
        matchingComponents: DateComponents,
        range: Range<Date>,
        matchingPolicy: Calendar.MatchingPolicy,
        repeatedTimePolicy: Calendar.RepeatedTimePolicy,
        direction: Calendar.SearchDirection,
        calendar: Calendar
    ) async throws {

        let expected = Array(
            calendar.dates(
                byMatching: matchingComponents, 
                startingAt: startingDate, 
                in: range, 
                matchingPolicy: matchingPolicy, 
                repeatedTimePolicy: repeatedTimePolicy, 
                direction: direction
            )
        )

        let sequence = startingDate.nextDates(
            byMatching: matchingComponents, 
            in: range, 
            matchingPolicy: matchingPolicy, 
            repeatedTimePolicy: repeatedTimePolicy, 
            direction: direction, 
            using: calendar
        )

        try #require(
            Array(sequence.prefix(expected.count + 1)).count == expected.count,
            "Sequence must not be infinite and must have expected number of elements"
        )

        #expect(Array(sequence) == expected)

    }

}