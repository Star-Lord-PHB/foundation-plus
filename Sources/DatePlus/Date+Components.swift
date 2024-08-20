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
    public func component(
        _ component: Calendar.Component,
        in timeZone: TimeZone? = nil,
        using calendar: Calendar = .autoupdatingCurrent
    ) -> Int {
        var calendar = calendar
        if let timeZone {
            calendar.timeZone = timeZone
        }
        return calendar.component(component, from: self)
    }
    
    
    /// Returns all the specified date components of a date.
    /// - Parameters:
    ///   - components: The set of components to get.
    ///   - timeZone: The time zone for calculating the component value
    ///   - calendar: The calendar for the calculation
    /// - Returns: The values for the required components
    public func components(
        _ components: Set<Calendar.Component>,
        in timeZone: TimeZone? = nil,
        using calendar: Calendar = .autoupdatingCurrent
    ) -> DateComponents {
        var calendar = calendar
        if let timeZone {
            calendar.timeZone = timeZone
        }
        return calendar.dateComponents(components, from: self)
    }
    
    
    /// Returns all the date components of a date.
    /// - Parameters:
    ///   - timeZone: The time zone for calculating the component value
    ///   - calendar: The calendar for the calculation
    /// - Returns: The values for the required components
    public func allComponents(
        in timeZone: TimeZone? = nil,
        using calendar: Calendar = .autoupdatingCurrent
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
    public func diffs(
        since date: Date,
        in component: Calendar.MeasurableComponent,
        using calendar: Calendar = .autoupdatingCurrent
    ) -> Int {
        calendar.dateComponents([component.component], from: date, to: self)
            .value(for: component.component)!
    }
    
    
    /// Returns the difference from a date to the current date in the specified set of components
    /// as ``Foundation/Calendar/MeasurableComponent``
    /// - Parameters:
    ///   - date: The **from** date for calculating the difference
    ///   - components: The set of components to compare as ``Foundation/Calendar/MeasurableComponent``
    ///   - calendar: The calendar for the calculation
    /// - Returns: The difference from the date to the current date
    public func diffs(
        since date: Date,
        in components: Set<Calendar.MeasurableComponent>,
        using calendar: Calendar = .autoupdatingCurrent
    ) -> DateComponents {
        calendar.dateComponents(Set(components.map { $0.component }), from: date, to: self)
    }
    
}


extension Date {
    
    /// Set a specific component to the current date, and trying to keep lower components the same.
    /// - Parameters:
    ///   - component: The component to set
    ///   - value: The new value for the component
    ///   - matchPolicy: Specifies the technique the search algorithm uses to find results.
    ///   Default value is .strict.
    ///   - timeZone: The time zone for setting the component value
    ///   - calendar: The calendar for the calculation
    ///
    /// - Seealso: [`date(bySetting:value:of:)`](https://developer.apple.com/documentation/foundation/calendar/2292915-date)
    public mutating func set(
        _ component: Calendar.MeasurableComponent,
        to value: Int,
        matchPolicy: Calendar.MatchingPolicy = .strict,
        in timeZone: TimeZone? = nil,
        using calendar: Calendar = .autoupdatingCurrent
    ) {
        self = self.setting(component, to: value, matchPolicy: matchPolicy, in: timeZone, using: calendar)
    }
    
    
    /// Returns a new Date representing the date calculated by setting a specific component to
    /// the current date, and trying to keep lower components the same.
    /// - Parameters:
    ///   - component: The component to set
    ///   - value: The new value for the component
    ///   - matchPolicy: Specifies the technique the search algorithm uses to find results.
    ///   Default value is .strict.
    ///   - timeZone: The time zone for setting the component value
    ///   - calendar: The calendar for the calculation
    ///
    /// - Seealso: [`date(bySetting:value:of:)`](https://developer.apple.com/documentation/foundation/calendar/2292915-date)
    public func setting(
        _ component: Calendar.MeasurableComponent,
        to value: Int,
        matchPolicy: Calendar.MatchingPolicy = .strict,
        in timeZone: TimeZone? = nil,
        using calendar: Calendar = .autoupdatingCurrent
    ) -> Date {
        
        var calendar = calendar
        if let timeZone {
            calendar.timeZone = timeZone
        }
        
        guard calendar.component(component.component, from: self) != value else { return self }
        
        var dateComponents = calendar.dateComponents(
            component.granularity.smallerNecessaryComponents,
            from: self
        )
        dateComponents.setValue(value, for: component.component)
        
        return calendar.nextDate(
            after: self,
            matching: dateComponents,
            matchingPolicy: matchPolicy
        )!
        
    }
    
    
    /// Set a specific component to the current date, and trying to keep lower components the same.
    /// - Parameters:
    ///   - value: The new value as a ``Foundation/Calendar/ComponentValue``
    ///   - matchPolicy: Specifies the technique the search algorithm uses to find results.
    ///   Default value is .strict.
    ///   - timeZone: The time zone for setting the component value
    ///   - calendar: The calendar for the calculation
    ///
    /// - Seealso: [`date(bySetting:value:of:)`](https://developer.apple.com/documentation/foundation/calendar/2292915-date)
    public mutating func set(
        _ value: Calendar.ComponentValue,
        matchPolicy: Calendar.MatchingPolicy = .strict,
        in timeZone: TimeZone? = nil,
        using calendar: Calendar = .autoupdatingCurrent
    ) {
        self.set(value.unit, to: value.value, matchPolicy: matchPolicy, in: timeZone, using: calendar)
    }
    
    
    /// Returns a new Date representing the date calculated by setting a specific component to
    /// the current date, and trying to keep lower components the same.
    /// - Parameters:
    ///   - value: The new value as a ``Foundation/Calendar/ComponentValue``
    ///   - matchPolicy: Specifies the technique the search algorithm uses to find results.
    ///   Default value is .strict.
    ///   - timeZone: The time zone for setting the component value
    ///   - calendar: The calendar for the calculation
    ///
    /// - Seealso: [`date(bySetting:value:of:)`](https://developer.apple.com/documentation/foundation/calendar/2292915-date)
    public func setting(
        _ value: Calendar.ComponentValue,
        matchPolicy: Calendar.MatchingPolicy = .strict,
        in timeZone: TimeZone? = nil,
        using calendar: Calendar = .autoupdatingCurrent
    ) -> Date {
        self.setting(value.unit, to: value.value, matchPolicy: matchPolicy, in: timeZone, using: calendar)
    }
    
}



extension Date {
    
    /// A subscript that is same as calling ``Foundation/Date/component(_:in:using:)`` for
    /// getting and ``set(_:to:matchPolicy:in:using:)`` for setting
    ///
    /// - Attention: When doing setting, the `matchPolicy` will alwasy be [`.strict`]
    /// - Attention: Setting with `.calendar`, `.timeZone` and `.isLeapMonth` will have no effect
    ///
    /// [`.strict`]: https://developer.apple.com/documentation/foundation/calendar/matchingpolicy/strict
    public subscript(
        _ component: Calendar.Component,
        in timeZone: TimeZone? = nil,
        using calendar: Calendar = .autoupdatingCurrent
    ) -> Int {
        get {
            self.component(component, in: timeZone, using: calendar)
        }
        set {
            guard let measurableComponent = component.toMeasurable() else { return }
            self.set(measurableComponent, to: newValue, in: timeZone, using: calendar)
        }
    }
    
    
    public func era(in timeZone: TimeZone? = nil, using calendar: Calendar = .autoupdatingCurrent) -> Int {
        self.component(.era, in: timeZone, using: calendar)
    }
    
    public func year(in timeZone: TimeZone? = nil, using calendar: Calendar = .autoupdatingCurrent) -> Int {
        self.component(.year, in: timeZone, using: calendar)
    }
    
    public func month(in timeZone: TimeZone? = nil, using calendar: Calendar = .autoupdatingCurrent) -> Int {
        self.component(.month, in: timeZone, using: calendar)
    }
    
    public func day(in timeZone: TimeZone? = nil, using calendar: Calendar = .autoupdatingCurrent) -> Int {
        self.component(.day, in: timeZone, using: calendar)
    }
    
    public func hour(in timeZone: TimeZone? = nil, using calendar: Calendar = .autoupdatingCurrent) -> Int {
        self.component(.hour, in: timeZone, using: calendar)
    }
    
    public func minute(in timeZone: TimeZone? = nil, using calendar: Calendar = .autoupdatingCurrent) -> Int {
        self.component(.minute, in: timeZone, using: calendar)
    }
    
    public func second(in timeZone: TimeZone? = nil, using calendar: Calendar = .autoupdatingCurrent) -> Int {
        self.component(.second, in: timeZone, using: calendar)
    }
    
    public func weekday(in timeZone: TimeZone? = nil, using calendar: Calendar = .autoupdatingCurrent) -> Int {
        self.component(.weekday, in: timeZone, using: calendar)
    }
    
    public func weekdayOrdinal(in timeZone: TimeZone? = nil, using calendar: Calendar = .autoupdatingCurrent) -> Int {
        self.component(.weekdayOrdinal, in: timeZone, using: calendar)
    }
    
    public func quarter(in timeZone: TimeZone? = nil, using calendar: Calendar = .autoupdatingCurrent) -> Int {
        self.component(.quarter, in: timeZone, using: calendar)
    }
    
    public func weekOfMonth(in timeZone: TimeZone? = nil, using calendar: Calendar = .autoupdatingCurrent) -> Int {
        self.component(.weekOfMonth, in: timeZone, using: calendar)
    }
    
    public func weekOfYear(in timeZone: TimeZone? = nil, using calendar: Calendar = .autoupdatingCurrent) -> Int {
        self.component(.weekOfYear, in: timeZone, using: calendar)
    }
    
    public func yearForWeekOfYear(in timeZone: TimeZone? = nil, using calendar: Calendar = .autoupdatingCurrent) -> Int {
        self.component(.yearForWeekOfYear, in: timeZone, using: calendar)
    }
    
    public func nanosecond(in timeZone: TimeZone? = nil, using calendar: Calendar = .autoupdatingCurrent) -> Int {
        self.component(.nanosecond, in: timeZone, using: calendar)
    }
    
    @available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
    public func isLeapMonth(in timeZone: TimeZone? = nil, using calendar: Calendar = .autoupdatingCurrent) -> Bool {
        self.component(.isLeapMonth, in: timeZone, using: calendar) == 1
    }
    
    @available(macOS 15, iOS 18, tvOS 18, watchOS 11, *)
    public func dayOfYear(in timeZone: TimeZone? = nil, using calendar: Calendar = .autoupdatingCurrent) -> Int {
        self.component(.dayOfYear, in: timeZone, using: calendar)
    }
    
}
