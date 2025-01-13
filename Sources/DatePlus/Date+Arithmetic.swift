//
//  Date+Arithmetic.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/8/14.
//

import Foundation


extension Calendar {
    
    /// A type that wraps a `Calendar.MeasurableComponent` and an integer
    ///
    /// Used for date calculation, can be created using a set of static methods
    /// ```swift
    /// let newDate = Date().adding(.day(1))
    /// ```
    public struct ComponentValue: Sendable {
        public var value: Int
        public var unit: Calendar.MeasurableComponent
    }
    
}


extension Calendar.ComponentValue {
    
    /// Invert a ``Foundation/Calendar/ComponentValue`` instance by inverting its
    /// ``Foundation/Calendar/ComponentValue/value`` field
    public static prefix func - (_ value: Self) -> Self {
        .init(value: -value.value, unit: value.unit)
    }
    
    /// Create a ``Foundation/Calendar/ComponentValue`` instance of the identifier for the era unit.
    public static func era(_ value: Int) -> Self {
        .init(value: value, unit: .era)
    }
    
    /// Create a ``Foundation/Calendar/ComponentValue`` instance of the identifier for the year unit.
    public static func year(_ value: Int) -> Self {
        .init(value: value, unit: .year)
    }
    
    /// Create a ``Foundation/Calendar/ComponentValue`` instance of the identifier for the month unit.
    public static func month(_ value: Int) -> Self {
        .init(value: value, unit: .month)
    }
    
    /// Create a ``Foundation/Calendar/ComponentValue`` instance of the identifier for the day unit.
    public static func  day(_ value: Int) -> Self {
        .init(value: value, unit: .day)
    }
    
    /// Create a ``Foundation/Calendar/ComponentValue`` instance of the identifier for the hour unit.
    public static func hour(_ value: Int) -> Self {
        .init(value: value, unit: .hour)
    }
    
    /// Create a ``Foundation/Calendar/ComponentValue`` instance of the identifier for the minute unit.
    public static func minute(_ value: Int) -> Self {
        .init(value: value, unit: .minute)
    }
    
    /// Create a ``Foundation/Calendar/ComponentValue`` instance of the identifier for the second unit.
    public static func second(_ value: Int) -> Self {
        .init(value: value, unit: .second)
    }
    
    /// Create a ``Foundation/Calendar/ComponentValue`` instance of the identifier for the weekday unit.
    public static func weekday(_ value: Int) -> Self {
        .init(value: value, unit: .weekday)
    }
    
    /// Create a ``Foundation/Calendar/ComponentValue`` instance of the identifier for the weekday ordinal unit.
    public static func weekdayOrdinal(_ value: Int) -> Self {
        .init(value: value, unit: .weekdayOrdinal)
    }
    
    /// Create a ``Foundation/Calendar/ComponentValue`` instance of the identifier for the quarter of the calendar.
    ///
    /// - Important: The quarter unit is largely unimplemented, and is not recommended for use.
    public static func quarter(_ value: Int) -> Self {
        .init(value: value, unit: .quarter)
    }
    
    /// Create a ``Foundation/Calendar/ComponentValue`` instance of the identifier for the week of the month calendar unit.
    public static func weekOfMonth(_ value: Int) -> Self {
        .init(value: value, unit: .weekOfMonth)
    }
    
    /// Create a ``Foundation/Calendar/ComponentValue`` instance of the identifier for the week of the year unit.
    public static func weekOfYear(_ value: Int) -> Self {
        .init(value: value, unit: .weekOfYear)
    }
    
    /// Create a ``Foundation/Calendar/ComponentValue`` instance of the identifier for the week-counting year unit.
    ///
    /// See the DateComponents property yearForWeekOfYear for a discussion of the semantics of this component.
    public static func yearForWeekOfYear(_ value: Int) -> Self {
        .init(value: value, unit: .yearForWeekOfYear)
    }
    
    /// Create a ``Foundation/Calendar/ComponentValue`` instance of the identifier for the nanosecond unit.
    public static func nanosecond(_ value: Int) -> Self {
        .init(value: value, unit: .nanosecond)
    }
    
    /// Create a ``Foundation/Calendar/ComponentValue`` instance of the identifier for the day of the year unit.
    @available(macOS 15, iOS 18, tvOS 18, watchOS 11, *)
    public static func dayOfYear(_ value: Int) -> Self {
        .init(value: value, unit: .dayOfYear)
    }
    
}


extension Date {
    
    /// Returns a new Date representing the date calculated by adding an amount of a specific
    /// `MeasurableComponent` to a given date.
    /// - Parameters:
    ///   - component: A single component to add.
    ///   - value: The value of the specified component to
    ///   - calendar: The calendar to used for this calculation, default is [`Calendar.autoupdatingCurrent`]
    /// - Returns: A new date
    ///
    /// [`Calendar.autoupdatingCurrent`]: https://developer.apple.com/documentation/foundation/calendar/2293260-autoupdatingcurrent
    public func adding(
        _ component: Calendar.MeasurableComponent,
        by value: Int,
        using calendar: Calendar = .autoupdatingCurrent
    ) -> Date {
        calendar.date(byAdding: component.component, value: value, to: self)!
    }
    
    
    /// Add an amount of a specific `MeasurableComponent` to the date.
    /// - Parameters:
    ///   - component: A single component to add.
    ///   - value: The value of the specified component to
    ///   - calendar: The calendar to used for this calculation, default is [`Calendar.autoupdatingCurrent`]
    ///
    /// [`Calendar.autoupdatingCurrent`]: https://developer.apple.com/documentation/foundation/calendar/2293260-autoupdatingcurrent
    public mutating func add(
        _ component: Calendar.MeasurableComponent,
        by value: Int,
        using calendar: Calendar = .autoupdatingCurrent
    ) {
        self = self.adding(component, by: value, using: calendar)
    }
    
    
    /// Returns a new Date representing the date calculated by adding an amount of a specific
    /// `MeasurableComponent` to a given date, represented by a ``Foundation/Calendar/ComponentValue``.
    /// - Parameters:
    ///   - duration: Specify the `MeasurableComponent` and the amount to add
    ///   - calendar: The calendar to used for this calculation, default is [`Calendar.autoupdatingCurrent`]
    /// - Returns: A new date
    ///
    /// [`Calendar.autoupdatingCurrent`]: https://developer.apple.com/documentation/foundation/calendar/2293260-autoupdatingcurrent
    public func adding(
        _ duration: Calendar.ComponentValue,
        using calendar: Calendar = .autoupdatingCurrent
    ) -> Date {
        self.adding(duration.unit, by: duration.value, using: calendar)
    }
    
    
    /// Add an amount of a specific `MeasurableComponent` to the date,
    /// represented by a ``DateComponentValue``.
    /// - Parameters:
    ///   - duration: Specify the `MeasurableComponent` and the amount to add
    ///   - calendar: The calendar to used for this calculation, default is [`Calendar.autoupdatingCurrent`]
    ///
    /// [`Calendar.autoupdatingCurrent`]: https://developer.apple.com/documentation/foundation/calendar/2293260-autoupdatingcurrent
    public mutating func add(
        _ duration: Calendar.ComponentValue,
        using calendar: Calendar = .autoupdatingCurrent
    ) {
        self = self.adding(duration, using: calendar)
    }
    
    
    /// Returns a new Date representing the date calculated by adding `components`
    /// to the current date.
    /// - Parameters:
    ///   - components: A set of values to add to the date.
    ///   - calendar: The calendar to used for this calculation, default is [`Calendar.autoupdatingCurrent`]
    /// - Returns: A new date
    ///
    /// [`Calendar.autoupdatingCurrent`]: https://developer.apple.com/documentation/foundation/calendar/2293260-autoupdatingcurrent
    public func adding(
        _ components: DateComponents,
        using calendar: Calendar = .autoupdatingCurrent
    ) -> Date {
        calendar.date(byAdding: components, to: self)!
    }
    
    
    /// Add `components` to the current date
    /// - Parameters:
    ///   - components: A set of values to add to the date.
    ///   - calendar: The calendar to used for this calculation, default is [`Calendar.autoupdatingCurrent`]
    ///
    /// [`Calendar.autoupdatingCurrent`]: https://developer.apple.com/documentation/foundation/calendar/2293260-autoupdatingcurrent
    public mutating func add(
        _ components: DateComponents,
        using calendar: Calendar = .autoupdatingCurrent
    ) {
        self = self.adding(components, using: calendar)
    }
    
}


extension Date {
    
    /// Returns a new Date representing the date calculated by adding an amount of a specific
    /// `MeasurableComponent` to a given date, represented by a ``Foundation/Calendar/ComponentValue``.
    public static func + (lhs: Date, rhs: Calendar.ComponentValue) -> Date {
        lhs.adding(rhs)
    }
    
    
    /// Add an amount of a specific `MeasurableComponent` to the date,
    /// represented by a ``Foundation/Calendar/ComponentValue``.
    public static func += (lhs: inout Date, rhs: Calendar.ComponentValue) {
        lhs.add(rhs)
    }
    
    /// Returns a new Date representing the date calculated by substracting an amount of
    /// a specific `MeasurableComponent` from a given date, represented by a ``Foundation/Calendar/ComponentValue``.
    public static func - (lhs: Date, rhs: Calendar.ComponentValue) -> Date {
        lhs.adding(-rhs)
    }
    
    
    /// Substract an amount of a specific `MeasurableComponent` from the date,
    /// represented by a ``Foundation/Calendar/ComponentValue``.
    public static func -= (lhs: inout Date, rhs: Calendar.ComponentValue) {
        lhs = lhs.adding(-rhs)
    }
    
    
    /// Returns a new Date representing the date calculated by adding components to the current date.
    public static func + (lhs: Date, rhs: DateComponents) -> Date {
        lhs.adding(rhs)
    }
    
    
    /// Add components to the current date
    public static func += (lhs: inout Date, rhs: DateComponents) {
        lhs = lhs.adding(rhs)
    }
    
}
