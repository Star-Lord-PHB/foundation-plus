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
            "Sequence must not be infinite"
        )

        #expect(Array(sequence) == expected)

    }

}