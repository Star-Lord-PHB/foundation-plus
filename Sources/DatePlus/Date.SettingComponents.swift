import Foundation



extension Calendar {

    /// The search direction when setting date components.
    public enum SetDateComponentSearchDirection: Sendable {
        /// Search forward in time.
        case forward
        /// Search backward in time.
        case backward
        /// Automatically determine the search direction.
        case auto
    }


    /// An error that indicates that no valid date could be found when setting a component for a date.
    public struct SetDateComponentError: LocalizedError {

        /// The component that failed to be set.
        public let component: MeasurableComponent
        /// The value that was attempted to be set.
        public let value: Int
        /// The date for which the component was being set.
        public let date: Date
        /// The matching policy used during the search.
        public let matchPolicy: MatchingPolicy
        /// The repeated time policy used during the search.
        public let repeatedTimePolicy: RepeatedTimePolicy
        /// The search direction used during the search.
        public let direction: SearchDirection
        /// The calendar used during the search.
        public let calendar: Identifier

        public init(
            component: MeasurableComponent,
            value: Int,
            date: Date,
            matchPolicy: MatchingPolicy,
            repeatedTimePolicy: RepeatedTimePolicy,
            direction: SearchDirection,
            calendar: Calendar.Identifier
        ) {
            self.component = component
            self.value = value
            self.date = date
            self.matchPolicy = matchPolicy
            self.repeatedTimePolicy = repeatedTimePolicy
            self.direction = direction
            self.calendar = calendar
        }

        var localizedDescription: String {
            """
            Error: No valid date could be found by setting \(component) to \(value) for \(date) using \(calendar) calendar \
            with match policy \(matchPolicy), repeated time policy \(repeatedTimePolicy) and search direction \(direction).
            """
        }

    }
    
}



extension Calendar {

    /// Try to update a specific component of a date to a specified value, and return the resulting date.
    /// 
    /// - Parameter component: The component to be updated.
    /// - Parameter value: The new value for the component.
    /// - Parameter date: The date to be updated.
    /// - Parameter matchPolicy: The matching policy to use when searching for the new date. Default to `.strict`.
    /// - Parameter repeatedTimePolicy: The repeated time policy to use when searching for the new date. Default to `.first`.
    /// - Parameter direction: The search direction to use when searching for the new date. Default to ``SetDateComponentSearchDirection/auto``.
    /// 
    /// - Returns: The updated date if a valid date could be found
    /// 
    /// - Throws: ``SetDateComponentError`` if no valid date could be found after updating the component.
    /// 
    /// This method is a reimplementation of [`date(bySetting:value:of:)`]. Instead of always searching forward for 
    /// a valid updated date, it allows specifying the search strategy, including matching policy, repeated time policy, 
    /// and search direction. 
    /// 
    /// Under the hood, this uses [`nextDate(after:matching:matchingPolicy:repeatedTimePolicy:direction:)`] to find a 
    /// valid match after updating the component, so the meaning of each parameter is basically the same as in that
    /// method. The only exception is the `direction` parameter, which includes a new ``SetDateComponentSearchDirection/auto`` 
    /// option. With this option, the search direction will be determined automatically based on the new value for
    /// the component. If the new value is greater than the current value of the component, search forward; otherwise, 
    /// search backward.
    /// 
    /// [`date(bySetting:value:of:)`]: https://developer.apple.com/documentation/foundation/calendar/2292915-date
    /// [`nextDate(after:matching:matchingPolicy:repeatedTimePolicy:direction:)`]: https://developer.apple.com/documentation/foundation/calendar/nextdate(after:matching:matchingpolicy:repeatedtimepolicy:direction:)/
    @usableFromInline
    func dateThrowing(
        bySetting component: MeasurableComponent, 
        to value: Int, 
        for date: Date, 
        matchPolicy: MatchingPolicy = .strict, 
        repeatedTimePolicy: RepeatedTimePolicy = .first, 
        direction: SetDateComponentSearchDirection = .auto
    ) throws(SetDateComponentError) -> Date {

        guard self.component(component.rawValue, from: date) != value else { return date }

        var componentsForMatching = component.granularity.smallerNecessaryComponents
        componentsForMatching.insert(component.rawValue)
        
        var dateComponents = self.dateComponents(componentsForMatching, from: date)

        let oldValue = dateComponents.value(for: component)
        if oldValue == value { return date }

        let direction = switch direction {
            case .forward: Calendar.SearchDirection.forward
            case .backward: Calendar.SearchDirection.backward
            case .auto where value > oldValue: Calendar.SearchDirection.forward
            case .auto: Calendar.SearchDirection.backward
        }

        dateComponents.setValue(value, for: component.rawValue)

        let nanosecond = dateComponents.nanosecond ?? 0
        if component != .nanosecond {
            // including nanosecond for matching makes repeatedTimePolicy not working for some reason,
            // exclude it from matching for now if it's not the direct target component to be set.
            dateComponents.nanosecond = nil
        }
        
        guard var date = self.nextDate(
            after: date,
            matching: dateComponents,
            matchingPolicy: matchPolicy,
            repeatedTimePolicy: repeatedTimePolicy,
            direction: direction
        ) else {
            throw Calendar.SetDateComponentError(
                component: component,
                value: value,
                date: date,
                matchPolicy: matchPolicy,
                repeatedTimePolicy: repeatedTimePolicy,
                direction: direction,
                calendar: self.identifier
            )
        }

        if component != .nanosecond {
            // If nanosecond is not the target component to be set, manually restore the original value
            // since it's excluded from matching above.
            date = self.date(byAdding: .nanosecond, value: nanosecond, to: date)!
        }

        return date

    }


    /// Try to update a specific component of a date to a specified value, and return the resulting date if possible.
    /// 
    /// - Parameter component: The component to be updated.
    /// - Parameter value: The new value for the component.
    /// - Parameter date: The date to be updated.
    /// - Parameter matchPolicy: The matching policy to use when searching for the new date. Default to `.strict`.
    /// - Parameter repeatedTimePolicy: The repeated time policy to use when searching for the new date. Default to `.first`.
    /// - Parameter direction: The search direction to use when searching for the new date. Default to ``SetDateComponentSearchDirection/auto``.
    /// 
    /// - Returns: The updated date if a valid date could be found, or `nil` otherwise.
    /// 
    /// This method is a reimplementation of [`date(bySetting:value:of:)`]. Instead of always searching forward for 
    /// a valid updated date, it allows specifying the search strategy, including matching policy, repeated time policy, 
    /// and search direction. 
    /// 
    /// Under the hood, this uses [`nextDate(after:matching:matchingPolicy:repeatedTimePolicy:direction:)`] to find a 
    /// valid match after updating the component, so the meaning of each parameter is basically the same as in that
    /// method. The only exception is the `direction` parameter, which includes a new ``SetDateComponentSearchDirection/auto`` 
    /// option. With this option, the search direction will be determined automatically based on the new value for
    /// the component. If the new value is greater than the current value of the component, search forward; otherwise, 
    /// search backward.
    /// 
    /// [`date(bySetting:value:of:)`]: https://developer.apple.com/documentation/foundation/calendar/2292915-date
    /// [`nextDate(after:matching:matchingPolicy:repeatedTimePolicy:direction:)`]: https://developer.apple.com/documentation/foundation/calendar/nextdate(after:matching:matchingpolicy:repeatedtimepolicy:direction:)/
    @inlinable
    public func date(
        bySetting component: MeasurableComponent, 
        to value: Int, 
        for date: Date, 
        matchPolicy: MatchingPolicy = .strict, 
        repeatedTimePolicy: RepeatedTimePolicy = .first, 
        direction: SetDateComponentSearchDirection = .auto
    ) -> Date? {
        try? self.dateThrowing(
            bySetting: component, to: value, for: date,
            matchPolicy: matchPolicy, 
            repeatedTimePolicy: repeatedTimePolicy, 
            direction: direction
        )
    }


    /// Try to update a specific component of a date to a specified value, and return the resulting date if possible.
    /// 
    /// - Parameter value: The new value for the component.
    /// - Parameter date: The date to be updated.
    /// - Parameter matchPolicy: The matching policy to use when searching for the new date. Default to `.strict`.
    /// - Parameter repeatedTimePolicy: The repeated time policy to use when searching for the new date. Default to `.first`.
    /// - Parameter direction: The search direction to use when searching for the new date. Default to ``SetDateComponentSearchDirection/auto``.
    /// 
    /// - Returns: The updated date if a valid date could be found, or `nil` otherwise.
    /// 
    /// This method is a reimplementation of [`date(bySetting:value:of:)`]. Instead of always searching forward for 
    /// a valid updated date, it allows specifying the search strategy, including matching policy, repeated time policy, 
    /// and search direction. 
    /// 
    /// Under the hood, this uses [`nextDate(after:matching:matchingPolicy:repeatedTimePolicy:direction:)`] to find a 
    /// valid match after updating the component, so the meaning of each parameter is basically the same as in that
    /// method. The only exception is the `direction` parameter, which includes a new ``SetDateComponentSearchDirection/auto`` 
    /// option. With this option, the search direction will be determined automatically based on the new value for
    /// the component. If the new value is greater than the current value of the component, search forward; otherwise, 
    /// search backward.
    /// 
    /// [`date(bySetting:value:of:)`]: https://developer.apple.com/documentation/foundation/calendar/2292915-date
    /// [`nextDate(after:matching:matchingPolicy:repeatedTimePolicy:direction:)`]: https://developer.apple.com/documentation/foundation/calendar/nextdate(after:matching:matchingpolicy:repeatedtimepolicy:direction:)/
    @inlinable
    public func date(
        bySetting value: ComponentValue,
        for date: Date,
        matchPolicy: MatchingPolicy = .strict,
        repeatedTimePolicy: RepeatedTimePolicy = .first,
        direction: SetDateComponentSearchDirection = .auto
    ) -> Date? {
        self.date(
            bySetting: value.unit, to: value.value, for: date,
            matchPolicy: matchPolicy,
            repeatedTimePolicy: repeatedTimePolicy,
            direction: direction
        )
    }

}



extension Date {
    
    
    /// Try to update a specific component of the date to a specified value
    /// 
    /// - Parameter component: The component to be updated.
    /// - Parameter value: The new value for the component.
    /// - Parameter matchPolicy: The matching policy to use when searching for the new date. Default to `.strict`.
    /// - Parameter repeatedTimePolicy: The repeated time policy to use when searching for the new date. Default to `.first`.
    /// - Parameter direction: The search direction to use when searching for the new date. Default to ``SetDateComponentSearchDirection/auto``.
    /// - Parameter calendar: The calendar used for the calculation. Default to `.current`.
    /// 
    /// - Throws: ``Calendar/SetDateComponentError`` if no valid date could be found after updating the component.
    /// 
    /// - Seealso: ``Calendar/date(bySetting:to:for:matchPolicy:repeatedTimePolicy:direction:)``
    @inlinable
    public mutating func set(
        _ component: Calendar.MeasurableComponent,
        to value: Int,
        matchPolicy: Calendar.MatchingPolicy = .strict,
        repeatedTimePolicy: Calendar.RepeatedTimePolicy = .first, 
        direction: Calendar.SetDateComponentSearchDirection = .auto,
        using calendar: Calendar = .current
    ) throws(Calendar.SetDateComponentError) {
        self = try calendar.dateThrowing(
            bySetting: component, to: value, for: self,
            matchPolicy: matchPolicy, 
            repeatedTimePolicy: repeatedTimePolicy, 
            direction: direction
        )
    }


    /// Try to update a specific component of the date to a specified value and return the resulting date if possible.
    /// 
    /// - Parameter component: The component to be updated.
    /// - Parameter value: The new value for the component.
    /// - Parameter matchPolicy: The matching policy to use when searching for the new date. Default to `.strict`.
    /// - Parameter repeatedTimePolicy: The repeated time policy to use when searching for the new date. Default to `.first`.
    /// - Parameter direction: The search direction to use when searching for the new date. Default to ``SetDateComponentSearchDirection/auto``.
    /// - Parameter calendar: The calendar used for the calculation. Default to `.current`.
    /// 
    /// - Returns: The updated date if a valid date could be found, or `nil` otherwise.
    /// 
    /// - Seealso: ``Calendar/date(bySetting:to:for:matchPolicy:repeatedTimePolicy:direction:)``
    @inlinable
    public func setting(
        _ component: Calendar.MeasurableComponent,
        to value: Int,
        matchPolicy: Calendar.MatchingPolicy = .strict,
        repeatedTimePolicy: Calendar.RepeatedTimePolicy = .first, 
        direction: Calendar.SetDateComponentSearchDirection = .auto,
        using calendar: Calendar = .current
    ) -> Date? {
        try? calendar.dateThrowing(
            bySetting: component, to: value, for: self,
            matchPolicy: matchPolicy, 
            repeatedTimePolicy: repeatedTimePolicy, 
            direction: direction
        )
    }
    
    
    /// Try to update a specific component of the date to a specified value
    /// 
    /// - Parameter value: The new value for the component.
    /// - Parameter matchPolicy: The matching policy to use when searching for the new date. Default to `.strict`.
    /// - Parameter repeatedTimePolicy: The repeated time policy to use when searching for the new date. Default to `.first`.
    /// - Parameter direction: The search direction to use when searching for the new date. Default to ``SetDateComponentSearchDirection/auto``.
    /// - Parameter calendar: The calendar used for the calculation. Default to `.current`.
    /// 
    /// - Throws: ``Calendar/SetDateComponentError`` if no valid date could be found after updating the component.
    /// 
    /// - Seealso: ``Calendar/date(bySetting:to:for:matchPolicy:repeatedTimePolicy:direction:)``
    @inlinable
    public mutating func set(
        _ value: Calendar.ComponentValue,
        matchPolicy: Calendar.MatchingPolicy = .strict,
        repeatedTimePolicy: Calendar.RepeatedTimePolicy = .first, 
        direction: Calendar.SetDateComponentSearchDirection = .auto,
        using calendar: Calendar = .current
    ) throws(Calendar.SetDateComponentError) {
        try self.set(value.unit, to: value.value, matchPolicy: matchPolicy, repeatedTimePolicy: repeatedTimePolicy, direction: direction, using: calendar)
    }
    
    
    /// Try to update a specific component of the date to a specified value and return the resulting date if possible.
    /// 
    /// - Parameter component: The component to be updated.
    /// - Parameter value: The new value for the component.
    /// - Parameter matchPolicy: The matching policy to use when searching for the new date. Default to `.strict`.
    /// - Parameter repeatedTimePolicy: The repeated time policy to use when searching for the new date. Default to `.first`.
    /// - Parameter direction: The search direction to use when searching for the new date. Default to ``SetDateComponentSearchDirection/auto``.
    /// - Parameter calendar: The calendar used for the calculation. Default to `.current`.
    /// 
    /// - Returns: The updated date if a valid date could be found, or `nil` otherwise.
    /// 
    /// - Seealso: ``Calendar/date(bySetting:to:for:matchPolicy:repeatedTimePolicy:direction:)``
    @inlinable
    public func setting(
        _ value: Calendar.ComponentValue,
        matchPolicy: Calendar.MatchingPolicy = .strict,
        repeatedTimePolicy: Calendar.RepeatedTimePolicy = .first, 
        direction: Calendar.SetDateComponentSearchDirection = .auto,
        using calendar: Calendar = .current
    ) -> Date? {
        self.setting(value.unit, to: value.value, matchPolicy: matchPolicy, repeatedTimePolicy: repeatedTimePolicy, direction: direction, using: calendar)
    }

}