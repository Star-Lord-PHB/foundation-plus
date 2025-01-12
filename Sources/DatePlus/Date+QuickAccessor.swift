//
//  Date+QuickAccessor.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/8/15.
//

import Foundation


extension Date {
    
    /// Returns the first moment of the day of the Date.
    public func startOfDay(using calendar: Calendar = .autoupdatingCurrent) -> Date {
        calendar.startOfDay(for: self)
    }
    
    
    /// Returns the first moment of the week of the Date.
    public func startOfWeek(using calendar: Calendar = .autoupdatingCurrent) -> Date {
        calendar.date(
            from: calendar.dateComponents(
                [.yearForWeekOfYear, .weekOfYear],
                from: self
            )
        )!
    }
    
    
    /// Returns the first moment of the month of the Date.
    public func startOfMonth(using calendar: Calendar = .autoupdatingCurrent) -> Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: self))!
    }
    
    
    /// Returns the first moment of the specified component of the Date.
    public func trimming(
        to component: Calendar.MeasurableComponent,
        using calendar: Calendar = .autoupdatingCurrent
    ) -> Date {
        calendar.dateInterval(of: component.component, for: self)!.start
    }
    
    
    /// Returns the starting time and duration of a given component that contains a given date.
    /// - Parameters:
    ///   - component: The component to calculate as ``Foundation/Calendar/MeasurableComponent``
    ///   - calendar: The calendar for the calculation
    /// - Returns: A `DateInterval`
    public func interval(
        of component: Calendar.MeasurableComponent,
        using calendar: Calendar = .autoupdatingCurrent
    ) -> DateInterval {
        calendar.dateInterval(of: component.component, for: self)!
    }
    
    
    /// Computes the next date which matches (or most closely matches) a given set of components.
    /// - Parameters:
    ///   - components: The components to search for.
    ///   - matchingPolicy: Specifies the technique the search algorithm uses to find results.
    ///   Default value is .nextTime.
    ///   - repeatedTimePolicy: Specifies the behavior when multiple matches are found.
    ///   Default value is .first.
    ///   - direction: Specifies the direction in time to search. Default is .forward.
    ///   - calendar: The calendar for the calculation
    /// - Returns: A Date representing the result of the search, or nil if a result could not be found.
    public func nextDate(
        matching components: DateComponents,
        matchingPolicy: Calendar.MatchingPolicy = .nextTime,
        repeatedTimePolicy: Calendar.RepeatedTimePolicy = .first,
        direction: Calendar.SearchDirection = .forward,
        using calendar: Calendar = .autoupdatingCurrent
    ) -> Date? {
        calendar.nextDate(
            after: self,
            matching: components,
            matchingPolicy: matchingPolicy,
            repeatedTimePolicy: repeatedTimePolicy,
            direction: direction
        )
    }
    
    
    /// Computes the next date which matches (or most closely matches) the specified component and
    /// its smaller components.
    /// - Parameters:
    ///   - component: The component to search for.
    ///   - value: The value of the component to search for.
    ///   - matchingPolicy: Specifies the technique the search algorithm uses to find results.
    ///   Default value is .nextTime.
    ///   - repeatedTimePolicy: Specifies the behavior when multiple matches are found.
    ///   Default value is .first.
    ///   - direction: Specifies the direction in time to search. Default is .forward.
    ///   - calendar: The calendar for the calculation
    /// - Returns: A Date representing the result of the search, or nil if a result could not be found.
    public func nextDate(
        matchingUpTo component: Calendar.MeasurableComponent,
        value: Int,
        matchingPolicy: Calendar.MatchingPolicy = .nextTime,
        repeatedTimePolicy: Calendar.RepeatedTimePolicy = .first,
        direction: Calendar.SearchDirection = .forward,
        using calendar: Calendar = .autoupdatingCurrent
    ) -> Date? {
        
        var components = calendar.dateComponents(component.granularity.smallerNecessaryComponents, from: self)
        components.setValue(value, for: component.component)
        
        return calendar.nextDate(
            after: self,
            matching: components,
            matchingPolicy: matchingPolicy,
            repeatedTimePolicy: repeatedTimePolicy,
            direction: direction
        )
        
    }
    
    
    /// Computes the next date which matches (or most closely matches) the specified component and
    /// its smaller components.
    /// - Parameters:
    ///   - component: The component to search for.
    ///   - matchingPolicy: Specifies the technique the search algorithm uses to find results.
    ///   Default value is .nextTime.
    ///   - repeatedTimePolicy: Specifies the behavior when multiple matches are found.
    ///   Default value is .first.
    ///   - direction: Specifies the direction in time to search. Default is .forward.
    ///   - calendar: The calendar for the calculation
    /// - Returns: A Date representing the result of the search, or nil if a result could not be found.
    public func nextDate(
        matchingUpTo component: Calendar.ComponentValue,
        matchingPolicy: Calendar.MatchingPolicy = .nextTime,
        repeatedTimePolicy: Calendar.RepeatedTimePolicy = .first,
        direction: Calendar.SearchDirection = .forward,
        using calendar: Calendar = .autoupdatingCurrent
    ) -> Date? {
        self.nextDate(
            matchingUpTo: component.unit,
            value: component.value,
            matchingPolicy: matchingPolicy,
            repeatedTimePolicy: repeatedTimePolicy,
            direction: direction,
            using: calendar
        )
    }
    
}
