//
//  Date+Components.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/8/14.
//

import Foundation


extension Date {
    
    /// Returns the value for one component of a date.
    /// - Parameters:
    ///   - component: The component to get.
    ///   - timeZone: The time zone for calculating the component value
    ///   - calendar: The calendar for the computation
    /// - Returns: The value for the component.
    @inlinable
    public func component(
        _ component: Calendar.Component,
        in timeZone: TimeZone? = nil,
        using calendar: Calendar = .current
    ) -> Int {
        if let timeZone {
            return calendar.dateComponents(in: timeZone, from: self).value(for: component) ?? 0
        } else {
            return calendar.component(component, from: self)
        }
    }
    
    
    /// Returns all the specified date components of a date.
    /// - Parameters:
    ///   - components: The set of components to get.
    ///   - calendar: The calendar for the calculation
    /// - Returns: The values for the required components
    @inlinable
    public func components(
        _ components: Set<Calendar.Component>,
        using calendar: Calendar = .current
    ) -> DateComponents {
        calendar.dateComponents(components, from: self)
    }
    
    
    /// Returns all the date components of a date.
    /// - Parameters:
    ///   - timeZone: The time zone for calculating the component value
    ///   - calendar: The calendar for the calculation
    /// - Returns: The values for the required components
    @inlinable
    public func components(
        in timeZone: TimeZone? = nil,
        using calendar: Calendar = .current
    ) -> DateComponents {
        calendar.dateComponents(in: timeZone ?? calendar.timeZone, from: self)
    }
    
    
    /// Returns the difference from a date to the current date in the specified component
    /// as ``Foundation/Calendar/MeasurableComponent``
    /// - Parameters:
    ///   - date: The **from** date for calculating the difference
    ///   - component: The component to compare as ``Foundation/Calendar/MeasurableComponent``
    ///   - calendar: The calendar for the calculation
    /// - Returns: The difference from the date to the current date
    @inlinable
    public func diffs(
        since date: Date,
        in component: Calendar.MeasurableComponent,
        using calendar: Calendar = .current
    ) -> Int {
        let rawComponent = component.rawValue
        return calendar.dateComponents([rawComponent], from: date, to: self)
            .value(for: rawComponent)!
    }
    
    
    /// Returns the difference from a date to the current date in the specified set of components
    /// as ``Foundation/Calendar/MeasurableComponent``
    /// - Parameters:
    ///   - date: The **from** date for calculating the difference
    ///   - components: The set of components to compare as ``Foundation/Calendar/MeasurableComponent``
    ///   - calendar: The calendar for the calculation
    /// - Returns: The difference from the date to the current date
    @inlinable
    public func diffs(
        since date: Date,
        in components: Set<Calendar.MeasurableComponent>,
        using calendar: Calendar = .current
    ) -> DateComponents {
        calendar.dateComponents(components.rawComponents, from: date, to: self)
    }


    /// Returns the difference from the current date to a date in the specified component
    /// as ``Foundation/Calendar/MeasurableComponent``
    /// - Parameters:
    ///   - date: The **to** date for calculating the difference
    ///   - component: The component to compare as ``Foundation/Calendar/MeasurableComponent``
    ///   - calendar: The calendar for the calculation
    /// - Returns: The difference from the current date to the date
    @inlinable
    public func diffs(
        to date: Date,
        in component: Calendar.MeasurableComponent,
        using calendar: Calendar = .current
    ) -> Int {
        calendar.dateComponents([component.rawValue], from: self, to: date)
            .value(for: component.rawValue)!
    }


    /// Returns the difference from the current date to a date in the specified set of components
    /// as ``Foundation/Calendar/MeasurableComponent``
    /// - Parameters:
    ///  - date: The **to** date for calculating the difference
    ///  - components: The set of components to compare as ``Foundation/Calendar/MeasurableComponent``
    /// - calendar: The calendar for the calculation
    /// - Returns: The difference from the current date to the date
    @inlinable
    public func diffs(
        to date: Date,
        in components: Set<Calendar.MeasurableComponent>,
        using calendar: Calendar = .current
    ) -> DateComponents {
        calendar.dateComponents(components.rawComponents, from: self, to: date)
    }

}



extension Date {
    
    /// A subscript that is same as calling ``Foundation/Date/component(_:in:using:)`` for
    /// getting value of a certain component
    @inlinable
    public subscript(
        _ component: Calendar.Component,
        in timeZone: TimeZone? = nil,
        using calendar: Calendar = .current
    ) -> Int {
        self.component(component, in: timeZone, using: calendar)
    }
    
    
    @inlinable
    public func era(in timeZone: TimeZone? = nil, using calendar: Calendar = .current) -> Int {
        self.component(.era, in: timeZone, using: calendar)
    }
    
    @inlinable
    public func year(in timeZone: TimeZone? = nil, using calendar: Calendar = .current) -> Int {
        self.component(.year, in: timeZone, using: calendar)
    }

    @inlinable
    public func month(in timeZone: TimeZone? = nil, using calendar: Calendar = .current) -> Int {
        self.component(.month, in: timeZone, using: calendar)
    }

    @inlinable
    public func day(in timeZone: TimeZone? = nil, using calendar: Calendar = .current) -> Int {
        self.component(.day, in: timeZone, using: calendar)
    }
    
    @inlinable
    public func hour(in timeZone: TimeZone? = nil, using calendar: Calendar = .current) -> Int {
        self.component(.hour, in: timeZone, using: calendar)
    }

    @inlinable
    public func minute(in timeZone: TimeZone? = nil, using calendar: Calendar = .current) -> Int {
        self.component(.minute, in: timeZone, using: calendar)
    }

    @inlinable
    public func second(in timeZone: TimeZone? = nil, using calendar: Calendar = .current) -> Int {
        self.component(.second, in: timeZone, using: calendar)
    }

    @inlinable
    public func weekday(in timeZone: TimeZone? = nil, using calendar: Calendar = .current) -> Int {
        self.component(.weekday, in: timeZone, using: calendar)
    }

    @inlinable
    public func weekdayOrdinal(in timeZone: TimeZone? = nil, using calendar: Calendar = .current) -> Int {
        self.component(.weekdayOrdinal, in: timeZone, using: calendar)
    }

    @inlinable
    public func quarter(in timeZone: TimeZone? = nil, using calendar: Calendar = .current) -> Int {
        self.component(.quarter, in: timeZone, using: calendar)
    }

    @inlinable
    public func weekOfMonth(in timeZone: TimeZone? = nil, using calendar: Calendar = .current) -> Int {
        self.component(.weekOfMonth, in: timeZone, using: calendar)
    }

    @inlinable
    public func weekOfYear(in timeZone: TimeZone? = nil, using calendar: Calendar = .current) -> Int {
        self.component(.weekOfYear, in: timeZone, using: calendar)
    }
    
    @inlinable
    public func yearForWeekOfYear(in timeZone: TimeZone? = nil, using calendar: Calendar = .current) -> Int {
        self.component(.yearForWeekOfYear, in: timeZone, using: calendar)
    }
    
    @inlinable
    public func nanosecond(in timeZone: TimeZone? = nil, using calendar: Calendar = .current) -> Int {
        self.component(.nanosecond, in: timeZone, using: calendar)
    }
    
    @inlinable
    @available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
    public func isLeapMonth(in timeZone: TimeZone? = nil, using calendar: Calendar = .current) -> Bool {
        self.component(.isLeapMonth, in: timeZone, using: calendar) == 1
    }
    
    @inlinable
    @available(macOS 15, iOS 18, tvOS 18, watchOS 11, *)
    public func dayOfYear(in timeZone: TimeZone? = nil, using calendar: Calendar = .current) -> Int {
        self.component(.dayOfYear, in: timeZone, using: calendar)
    }
    
}
