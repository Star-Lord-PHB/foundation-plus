//
//  Date+QuickAccessor.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/8/15.
//

import Foundation


extension Date {
    
    /// Returns the first moment of the day of the Date.
    @inlinable
    public func startOfDay(using calendar: Calendar = .current) -> Date {
        calendar.startOfDay(for: self)
    }
    
    
    /// Returns the first moment of the week of the Date.
    @inlinable
    public func startOfWeek(using calendar: Calendar = .current) -> Date {
        calendar.dateInterval(of: .weekOfYear, for: self)!.start
    }
    
    
    /// Returns the first moment of the month of the Date.
    @inlinable
    public func startOfMonth(using calendar: Calendar = .current) -> Date {
        calendar.dateInterval(of: .month, for: self)!.start
    }
    
    
    /// Returns the first moment of the specified component of the Date.
    @inlinable
    public func trimming(
        to component: Calendar.MeasurableComponent,
        using calendar: Calendar = .current
    ) -> Date {
        calendar.dateInterval(of: component.rawValue, for: self)!.start
    }
    
    
    /// Returns the starting time and duration of a given component that contains a given date.
    /// - Parameters:
    ///   - component: The component to calculate as ``Foundation/Calendar/MeasurableComponent``
    ///   - calendar: The calendar for the calculation
    /// - Returns: A `DateInterval`
    @inlinable
    public func interval(
        of component: Calendar.MeasurableComponent,
        using calendar: Calendar = .current
    ) -> DateInterval {
        calendar.dateInterval(of: component.rawValue, for: self)!
    }


    /// Returns the ordinality of a component within a larger component for the date.
    /// 
    /// - Parameter smaller: The component to find the ordinality of
    /// - Parameter larger: The component to find the ordinality within
    /// - Parameter calendar: The calendar for the calculation
    /// 
    /// - Returns: The ordinality of the component within the larger component for the date, or nil 
    ///   if either the smaller component is not really smaller or the ordinality cannot be calculated
    /// 
    /// - Seealso: [`ordinality(of:in:for:)`]
    /// 
    /// [`ordinality(of:in:for:)`]: https://developer.apple.com/documentation/foundation/calendar/ordinality(of:in:for:)
    @inlinable
    public func ordinality(
        of smaller: Calendar.Component, 
        in larger: Calendar.Component, 
        using calendar: Calendar = .current
    ) -> Int? {
        calendar.ordinality(of: smaller, in: larger, for: self)
    }
    
    
    /// Computes the next date which matches (or most closely matches) a given set of components.
    /// 
    /// - Parameters:
    ///   - components: The components to match.
    ///   - matchingPolicy: Specifies the technique the search algorithm uses to find results.
    ///     Default value is .nextTime.
    ///   - repeatedTimePolicy: Specifies the behavior when multiple matches are found.
    ///     Default value is .first.
    ///   - direction: Specifies the direction in time to search. Default is .forward.
    ///   - calendar: The calendar for the calculation
    /// 
    /// - Returns: A Date representing the result of the search, or nil if a result could not be found.
    @inlinable
    public func nextDate(
        matching components: DateComponents,
        matchingPolicy: Calendar.MatchingPolicy = .nextTime,
        repeatedTimePolicy: Calendar.RepeatedTimePolicy = .first,
        direction: Calendar.SearchDirection = .forward,
        using calendar: Calendar = .current
    ) -> Date? {
        calendar.nextDate(
            after: self,
            matching: components,
            matchingPolicy: matchingPolicy,
            repeatedTimePolicy: repeatedTimePolicy,
            direction: direction
        )
    }


    /// Return whether the date is within today
    /// 
    /// - Seealso: [`isDateInToday(_:)`]
    /// 
    /// [`isDateInToday(_:)`]: https://developer.apple.com/documentation/foundation/calendar/isdateintoday(_:)
    public func isInToday(using calendar: Calendar = .current) -> Bool {
        calendar.isDateInToday(self)
    }


    /// Return whether the date is within tomorrow
    /// 
    /// - Seealso: [`isDateInTomorrow(_:)`]
    /// 
    /// [`isDateInTomorrow(_:)`]: https://developer.apple.com/documentation/foundation/calendar/isdateintomorrow(_:)
    public func isInTomorrow(using calendar: Calendar = .current) -> Bool {
        calendar.isDateInTomorrow(self)
    }


    /// Return whether the date is within yesterday
    /// 
    /// - Seealso: [`isDateInYesterday(_:)`]
    /// 
    /// [`isDateInYesterday(_:)`]: https://developer.apple.com/documentation/foundation/calendar/isdateinyesterday(_:)
    public func isInYesterday(using calendar: Calendar = .current) -> Bool {
        calendar.isDateInYesterday(self)
    }


    /// Return whether the date is within a weekend
    /// 
    /// - Seealso: [`isDateInWeekend(_:)`]
    /// 
    /// [`isDateInWeekend(_:)`]: https://developer.apple.com/documentation/foundation/calendar/isdateinweekend(_:)
    public func isInWeekend(using calendar: Calendar = .current) -> Bool {
        calendar.isDateInWeekend(self)
    }
    
}
