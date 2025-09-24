import Foundation


extension Calendar {

    /// An iterator producing Dates that match (or most closely match) a given set of components
    /// 
    /// This is the iterator for supporting ``Calendar/DateMatchingEnumerationSequence``, which brings the sequence
    /// for matching dates to older OS versions that do not support it.
    /// 
    /// - SeeAlso: ``Calendar/DateMatchingEnumerationSequence``
    /// - SeeAlso: [`dates(byMatching:startingAt:in:matchingPolicy:repeatedTimePolicy:direction:)`]
    /// 
    /// [`dates(byMatching:startingAt:in:matchingPolicy:repeatedTimePolicy:direction:)`]: https://developer.apple.com/documentation/foundation/calendar/dates(bymatching:startingat:in:matchingpolicy:repeatedtimepolicy:direction:)
    public struct DateEnumerationIterator: IteratorProtocol, Sendable {

        public let matchingComponents: DateComponents
        public let matchingPolicy: Calendar.MatchingPolicy
        public let repeatedTimePolicy: Calendar.RepeatedTimePolicy
        public let direction: Calendar.SearchDirection
        public let calendar: Calendar
        public let range: Range<Date>?

        private var currentDate: Date

        public init(
            startingDate: Date,
            range: Range<Date>?,
            matchingComponents: DateComponents, 
            matchingPolicy: Calendar.MatchingPolicy, 
            repeatedTimePolicy: Calendar.RepeatedTimePolicy, 
            direction: Calendar.SearchDirection, 
            calendar: Calendar, 
        ) {
            self.currentDate = startingDate
            self.matchingComponents = matchingComponents
            self.matchingPolicy = matchingPolicy
            self.repeatedTimePolicy = repeatedTimePolicy
            self.direction = direction
            self.calendar = calendar
            self.range = range
        }


        public mutating func next() -> Date? {

            let date = calendar.nextDate(
                after: currentDate, 
                matching: matchingComponents, 
                matchingPolicy: matchingPolicy, 
                repeatedTimePolicy: repeatedTimePolicy, 
                direction: direction
            )

            guard let date else { return nil }

            if let range, !range.contains(date) {
                return nil
            }

            currentDate = date
            return date

        }

    }


    /// A sequence of Dates that match (or most closely match) a given set of components
    /// 
    /// This type is a reimplementation of the sequence returned by the
    /// [`dates(byMatching:startingAt:in:matchingPolicy:repeatedTimePolicy:direction:)`] method of Calendar
    /// for older OS versions that do not support it.
    /// 
    /// - SeeAlso: [`dates(byMatching:startingAt:in:matchingPolicy:repeatedTimePolicy:direction:)`]
    /// 
    /// [`dates(byMatching:startingAt:in:matchingPolicy:repeatedTimePolicy:direction:)`]: https://developer.apple.com/documentation/foundation/calendar/dates(bymatching:startingat:in:matchingpolicy:repeatedtimepolicy:direction:)
    public struct DateMatchingEnumerationSequence: Sequence, Sendable {

        /// The starting date for calculating elements of the sequence.
        public let startingDate: Date
        /// The components to match.
        public let matchingComponents: DateComponents
        /// Strategy of matching when seeing an ambiguous result
        public let matchingPolicy: Calendar.MatchingPolicy
        /// Strategy of matching when seeing a Date that occurs twice on a particular day
        public let repeatedTimePolicy: Calendar.RepeatedTimePolicy
        /// The search direction
        public let direction: Calendar.SearchDirection
        /// The calendar for calculation
        public let calendar: Calendar
        /// The range of dates to allow in the sequence.
        public let range: Range<Date>?

        public init(
            startingDate: Date,
            matchingComponents: DateComponents, 
            range: Range<Date>? = nil,
            matchingPolicy: Calendar.MatchingPolicy, 
            repeatedTimePolicy: Calendar.RepeatedTimePolicy, 
            direction: Calendar.SearchDirection, 
            calendar: Calendar = .current, 
        ) {
            self.startingDate = startingDate
            self.matchingComponents = matchingComponents
            self.matchingPolicy = matchingPolicy
            self.repeatedTimePolicy = repeatedTimePolicy
            self.direction = direction
            self.calendar = calendar
            self.range = range
        }

        @inlinable
        public func makeIterator() -> DateEnumerationIterator {
            .init(
                startingDate: startingDate, 
                range: range,
                matchingComponents: matchingComponents, 
                matchingPolicy: matchingPolicy, 
                repeatedTimePolicy: repeatedTimePolicy, 
                direction: direction, 
                calendar: calendar
            )
        }

    }

}



extension Date {

    /// Returns a sequence of Dates, calculated by adding certain value to a component of a starting Date. 
    /// 
    /// This method is a reimplementation of the [`dates(byAdding:value:startingAt:in:wrappingComponents:)`] method of Calendar 
    /// for older OS versions that do not support it.
    /// 
    /// - Parameter component: A component to add or subtract.
    /// - Parameter value: The value of the specified component to add or subtract. Default to 1. 
    /// - Parameter range: The range of dates to allow in the result.
    /// - Parameter wrappingComponents: Whether the component should be wrap around to zero/one on overflow without 
    ///   causing higher components to be incremented. Default to false.
    /// - Parameter calendar: The calendar to use for the calculations. Default to the current calendar.
    /// 
    /// - SeeAlso: [`dates(byAdding:value:startingAt:in:wrappingComponents:)`]
    /// 
    /// [`dates(byAdding:value:startingAt:in:wrappingComponents:)`]: https://developer.apple.com/documentation/foundation/calendar/dates(byadding:value:startingat:in:wrappingcomponents:)/
    @available(macOS, deprecated: 15, message: "Use nextDates(byMatching:in:matchingPolicy:repeatedTimePolicy:direction:using:) instead")
    @available(iOS, deprecated: 18, message: "Use nextDates(byMatching:in:matchingPolicy:repeatedTimePolicy:direction:using:) instead")
    @available(tvOS, deprecated: 18, message: "Use nextDates(byMatching:in:matchingPolicy:repeatedTimePolicy:direction:using:) instead")
    @available(watchOS, deprecated: 11, message: "Use nextDates(byMatching:in:matchingPolicy:repeatedTimePolicy:direction:using:) instead")
    @inlinable
    public func nextDatesCompat(
        byMatching components: DateComponents,
        in range: Range<Date>? = nil,
        matchingPolicy: Calendar.MatchingPolicy = .nextTime,
        repeatedTimePolicy: Calendar.RepeatedTimePolicy = .first,
        direction: Calendar.SearchDirection = .forward,
        using calendar: Calendar = .current
    ) -> some Sendable & Sequence<Date> {
        Calendar.DateMatchingEnumerationSequence(
            startingDate: self, 
            matchingComponents: components, 
            range: range,
            matchingPolicy: matchingPolicy, 
            repeatedTimePolicy: repeatedTimePolicy, 
            direction: direction, 
            calendar: calendar
        )
    }


    /// Returns a sequence of Dates, calculated by adding certain value to a component of a starting Date. 
    /// 
    /// This method will directly forward the call to the [`dates(byAdding:value:startingAt:in:wrappingComponents:)`] method of Calendar.
    /// 
    /// - Parameter component: A component to add or subtract.
    /// - Parameter value: The value of the specified component to add or subtract. Default to 1. 
    /// - Parameter range: The range of dates to allow in the result.
    /// - Parameter wrappingComponents: Whether the component should be wrap around to zero/one on overflow without 
    ///   causing higher components to be incremented. Default to false.
    /// - Parameter calendar: The calendar to use for the calculations. Default to the current calendar.
    /// 
    /// - SeeAlso: [`dates(byAdding:value:startingAt:in:wrappingComponents:)`]
    /// 
    /// [`dates(byAdding:value:startingAt:in:wrappingComponents:)`]: https://developer.apple.com/documentation/foundation/calendar/dates(byadding:value:startingat:in:wrappingcomponents:)/
    @available(macOS 15, iOS 18, tvOS 18, watchOS 11, *)
    @inlinable
    public func nextDates(
        byAdding component: Calendar.MeasurableComponent, 
        value: Int = 1, 
        in range: Range<Date>? = nil, 
        wrappingComponents: Bool = false, 
        using calendar: Calendar = .current
    ) -> some Sendable & Sequence<Date> {
        calendar.dates(byAdding: component.rawValue, value: value, startingAt: self, in: range, wrappingComponents: wrappingComponents)
    }


    /// Returns a sequence of Dates, calculated by adding certain value to a component of a starting Date. 
    /// 
    /// This method will directly forward the call to the [`dates(byAdding:value:startingAt:in:wrappingComponents:)`] method of Calendar.
    /// 
    /// - Parameter component: The value and component to add or subtract.
    /// - Parameter range: The range of dates to allow in the result.
    /// - Parameter wrappingComponents: Whether the component should be wrap around to zero/one on overflow without 
    ///   causing higher components to be incremented. Default to false.
    /// - Parameter calendar: The calendar to use for the calculations. Default to the current calendar.
    /// 
    /// - SeeAlso: [`dates(byAdding:value:startingAt:in:wrappingComponents:)`]
    /// 
    /// [`dates(byAdding:value:startingAt:in:wrappingComponents:)`]: https://developer.apple.com/documentation/foundation/calendar/dates(byadding:value:startingat:in:wrappingcomponents:)/
    @available(macOS 15, iOS 18, tvOS 18, watchOS 11, *)
    @inlinable
    public func nextDates(
        byAdding component: Calendar.ComponentValue, 
        in range: Range<Date>? = nil, 
        wrappingComponents: Bool = false, 
        using calendar: Calendar = .current
    ) -> some Sendable & Sequence<Date> {
        calendar.dates(byAdding: component.unit.rawValue, value: component.value, startingAt: self, in: range, wrappingComponents: wrappingComponents)
    }

    /// Returns a sequence of Dates, calculated by adding a `DateComponents` to a starting Date. 
    /// 
    /// This method will directly forward the call to the [`dates(byAdding:startingAt:in:wrappingComponents:)`] method 
    /// of Calendar. Following is the docs of that method.
    /// 
    /// If a range is supplied, the sequence terminates if the next result is not contained in the range. The starting 
    /// point does not need to be contained in the range, but if the first result is outside of the range then the 
    /// result will be an empty sequence.
    /// 
    /// - Parameter components: The components to add or subtract.
    /// - Parameter range: The range of dates to allow in the result.
    /// - Parameter wrappingComponents: Whether the component should be wrap around to zero/one on overflow without 
    ///   causing higher components to be incremented. Default to false.
    /// - Parameter calendar: The calendar to use for the calculations. Default to the current calendar.
    /// 
    /// [`dates(byAdding:startingAt:in:wrappingComponents:)`]: https://developer.apple.com/documentation/foundation/calendar/dates(byadding:startingat:in:wrappingcomponents:)
    @available(macOS 15, iOS 18, tvOS 18, watchOS 11, *)
    @inlinable
    public func nextDates(
        byAdding components: DateComponents, 
        in range: Range<Date>? = nil, 
        wrappingComponents: Bool = false, 
        using calendar: Calendar = .current
    ) -> some Sendable & Sequence<Date> {
        calendar.dates(byAdding: components, startingAt: self, in: range, wrappingComponents: wrappingComponents)
    }


    /// Returns a sequence of Dates that match (or most closely match) a given set of components
    /// 
    /// This method will directly forward the call to the [`dates(byMatching:startingAt:in:matchingPolicy:repeatedTimePolicy:direction:)`]
    /// method of Calendar. Following is the docs of that method.
    /// 
    /// - Parameter components: The DateComponents to use as input to the search algorithm.
    /// - Parameter range: The range of dates to allow in the result.
    /// - Parameter matchingPolicy: Strategy of matching when seeing an ambiguous result. Default to .nextTime.
    /// - Parameter repeatedTimePolicy: Strategy of matching when seeing a Date that occurs twice on a particular day. 
    ///   Default to .first.
    /// - Parameter direction: The search direction. Default to .forward.
    /// - Parameter calendar: The calendar to use for the calculations. The default value is the current calendar.
    /// 
    /// - SeeAlso: [`dates(byMatching:startingAt:in:matchingPolicy:repeatedTimePolicy:direction:)`]
    /// 
    /// [`dates(byMatching:startingAt:in:matchingPolicy:repeatedTimePolicy:direction:)`]: https://developer.apple.com/documentation/foundation/calendar/dates(bymatching:startingat:in:matchingpolicy:repeatedtimepolicy:direction:)
    @available(macOS 15, iOS 18, tvOS 18, watchOS 11, *)
    @inlinable
    public func nextDates(
        byMatching components: DateComponents,
        in range: Range<Date>? = nil,
        matchingPolicy: Calendar.MatchingPolicy = .nextTime,
        repeatedTimePolicy: Calendar.RepeatedTimePolicy = .first,
        direction: Calendar.SearchDirection = .forward,
        using calendar: Calendar = .current
    ) -> some Sendable & Sequence<Date> {
        calendar.dates(byMatching: components, startingAt: self, in: range, matchingPolicy: matchingPolicy, repeatedTimePolicy: repeatedTimePolicy, direction: direction)
    }

}



extension Date {

    /// Compute a sequence of dates that match (or most closely match) a given set of components 
    /// starting from this date and invoke the given closure for each of the matched dates. 
    /// 
    /// - Parameter components: The components to match
    /// - Parameter matchingPolicy: Strategy of matching when seeing an ambiguous result, 
    ///   default to .nextTime.
    /// - Parameter repeatedTimePolicy: Strategy of matching when seeing a Date that occurs twice on a particular day. 
    ///   Default to .first.
    /// - Parameter direction: The search direction, default to .forward.
    /// - Parameter calendar: The calendar for the calculations, default to .current.
    /// - Parameter handler: A closure that is invoked for each of the matched dates. 
    /// 
    /// This method will directly forward the call to the [`enumerateDates(startingAfter:matching:matchingPolicy:repeatedTimePolicy:direction:using:)`]
    /// method of Calendar. 
    /// 
    /// - Seealso: [`enumerateDates(startingAfter:matching:matchingPolicy:repeatedTimePolicy:direction:using:)`]
    /// 
    /// [`enumerateDates(startingAfter:matching:matchingPolicy:repeatedTimePolicy:direction:using:)`]: https://developer.apple.com/documentation/foundation/calendar/enumeratedates(startingafter:matching:matchingpolicy:repeatedtimepolicy:direction:using:)
    @inlinable
    public func enumerate(
        matching components: DateComponents,
        matchingPolicy: Calendar.MatchingPolicy,
        repeatedTimePolicy: Calendar.RepeatedTimePolicy = .first,
        direction: Calendar.SearchDirection = .forward,
        using calendar: Calendar = .current,
        onResult handler: (Date?, Bool, inout Bool) -> Void
    ) {
        calendar.enumerateDates(
            startingAfter: self, 
            matching: components, 
            matchingPolicy: matchingPolicy, 
            repeatedTimePolicy: repeatedTimePolicy,
            direction: direction, 
            using: handler
        )
    }

}