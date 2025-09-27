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

        let sequence = startingDate.nextDatesCompat(
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


    @available(macOS 15, iOS 18, tvOS 18, watchOS 11, *)
    @Test(
        "Enumeration by Adding (Compat version)", .timeLimit(.minutes(1)),
        arguments: [
            (
                date(year: 2025, month: 1, day: 1),
                .init(year: 1, month: 1, day: 1, hour: 100, minute: 1, second: 1),
                date(year: 2025, month: 1, day: 1) ..< date(year: 2040, month: 1, day: 1),
                false,
                calendar()
            ),
            (
                date(year: 2025, month: 1, day: 1),
                .init(month: 1, day: 1),
                date(year: 2025, month: 3, day: 1) ..< date(year: 2025, month: 6, day: 1),
                false,
                calendar()
            ),
            (
                date(year: 2025, month: 2, day: 25, hour: 10, minute: 30, second: 5),
                .init(day: 2, minute: 20),
                date(year: 2025, month: 2, day: 27, hour: 10, minute: 30, second: 3) ..< date(year: 2025, month: 3, day: 3, hour: 10, minute: 29, second: 5),
                false,
                calendar()
            ),
            (
                date(year: 2025, month: 2, day: 25, hour: 10, minute: 30, second: 5),
                .init(day: 2, minute: 20),
                date(year: 2025, month: 2, day: 27, hour: 10, minute: 30, second: 3) ..< date(year: 2025, month: 3, day: 3, hour: 10, minute: 29, second: 5),
                true,
                calendar()
            ),
            (
                date(year: 2025, month: 1, day: 31, hour: 10, minute: 30, second: 5),
                .init(month: 1),
                date(year: 2025, month: 1, day: 31, hour: 10, minute: 30, second: 5) ..< date(year: 2026, month: 1, day: 3),
                false,
                calendar()
            ),
            (
                date(year: 2025, month: 1, day: 31, hour: 10, minute: 30, second: 5),
                .init(month: 1),
                date(year: 2025, month: 1, day: 31, hour: 10, minute: 30, second: 5) ..< date(year: 2025, month: 12, day: 3),
                true,
                calendar()
            ),
            (
                date(year: 2025, month: 3, day: 9, hour: 0, minute: 0, second: 0, using: calendar(in: pst)),
                .init(minute: 30),
                date(year: 2025, month: 3, day: 9, using: calendar(in: pst)) ..< date(year: 2025, month: 3, day: 9, hour: 4, using: calendar(in: pst)),
                false,
                calendar(in: pst)
            ),
            (
                date(year: 2025, month: 11, day: 2, hour: 0, minute: 0, second: 0, using: calendar(in: pst)),
                .init(minute: 30),
                date(year: 2025, month: 11, day: 2, using: calendar(in: pst)) ..< date(year: 2025, month: 11, day: 2, hour: 4, using: calendar(in: pst)),
                false,
                calendar(in: pst)
            ),
        ] as [(Date, DateComponents, Range<Date>, Bool, Calendar)]
    )
    func testEnumerationByAddingCompat(
        startingDate: Date,
        component: DateComponents,
        range: Range<Date>,
        wrappingComponents: Bool,
        calendar: Calendar
    ) async throws {

        let expected = Array(
            calendar.dates(
                byAdding: component, 
                startingAt: startingDate, 
                in: range, 
                wrappingComponents: wrappingComponents
            )
        )

        let sequence = startingDate.nextDatesCompat(
            byAdding: component, 
            in: range, 
            wrappingComponents: wrappingComponents, 
            using: calendar
        )

        try #require(
            Array(sequence.prefix(expected.count + 1)).count == expected.count,
            "Sequence must not be infinite and must have expected number of elements"
        )

        #expect(Array(sequence) == expected)

    }

}