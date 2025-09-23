import Foundation


extension Date {

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
        calendar.enumerateDates(startingAfter: self, matching: .init(), matchingPolicy: .nextTime, using: { result, exactMatch, stop in })
        return calendar.dates(byAdding: component.rawValue, value: value, startingAt: self, in: range, wrappingComponents: wrappingComponents)
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