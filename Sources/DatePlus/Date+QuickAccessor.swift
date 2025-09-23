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
    
}
