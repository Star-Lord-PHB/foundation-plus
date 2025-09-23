//
//  Calendar+MeasurableComponent.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/8/16.
//

import Foundation


extension Calendar {
    
    /// A wrapper for [`Calendar.Component`], which contains only components that can truly be
    /// measured with numbers
    ///
    /// For example, `.year`, `.hour` are measurable, but `.calendar`, `.isLeapMonth` are not
    ///
    /// [`Calendar.Component`]: https://developer.apple.com/documentation/foundation/calendar/component
    public enum MeasurableComponent: RawRepresentable, Sendable {
        
        /// Identifier for the era unit.
        case era
        
        /// Identifier for the year unit.
        case year
        
        /// Identifier for the month unit.
        case month
        
        /// Identifier for the day unit.
        case day
        
        /// Identifier for the hour unit.
        case hour
        
        /// Identifier for the minute unit.
        case minute
        
        /// Identifier for the second unit.
        case second
        
        /// Identifier for the weekday unit.
        case weekday
        
        /// Identifier for the weekday ordinal unit.
        case weekdayOrdinal
        
        /// Identifier for the quarter of the calendar.
        ///
        /// - Important: The quarter unit is largely unimplemented, and is not recommended for use.
        case quarter
        
        /// Identifier for the week of the month calendar unit.
        case weekOfMonth
        
        /// Identifier for the week of the year unit.
        case weekOfYear
        
        /// Identifier for the week-counting year unit.
        ///
        /// See the DateComponents property yearForWeekOfYear for a discussion of the semantics of this component.
        case yearForWeekOfYear
        
        /// Identifier for the nanosecond unit.
        case nanosecond
        
        @available(macOS 15, iOS 18, tvOS 18, watchOS 11, *)
        case dayOfYear
        
        
        /// Get the actual [`Calendar.Component`] instance
        ///
        /// [`Calendar.Component`]: https://developer.apple.com/documentation/foundation/calendar/component
        @inlinable
        public var rawValue: Component {
            if #available(macOS 15, iOS 18, tvOS 18, watchOS 11, *) {
                switch self {
                    case .era: .era
                    case .year: .year
                    case .month: .month
                    case .day: .day
                    case .hour: .hour
                    case .minute: .minute
                    case .second: .second
                    case .weekday: .weekday
                    case .weekdayOrdinal: .weekdayOrdinal
                    case .quarter: .quarter
                    case .weekOfMonth: .weekOfMonth
                    case .weekOfYear: .weekOfYear
                    case .yearForWeekOfYear: .yearForWeekOfYear
                    case .nanosecond: .nanosecond
                    case .dayOfYear: .dayOfYear
                }
            } else {
                switch self {
                    case .era: .era
                    case .year: .year
                    case .month: .month
                    case .day: .day
                    case .hour: .hour
                    case .minute: .minute
                    case .second: .second
                    case .weekday: .weekday
                    case .weekdayOrdinal: .weekdayOrdinal
                    case .quarter: .quarter
                    case .weekOfMonth: .weekOfMonth
                    case .weekOfYear: .weekOfYear
                    case .yearForWeekOfYear: .yearForWeekOfYear
                    case .nanosecond: .nanosecond
                    default: fatalError("unsupported case: \(self)")
                }
            }
        }
        
        
        @inlinable
        public var granularity: Granularity {
            switch self {
                case .era, .year: .year
                case .month, .quarter: .month
                case .day, .weekday, .weekdayOrdinal, .weekOfMonth, .weekOfYear, .yearForWeekOfYear, .dayOfYear: .day
                case .hour: .hour
                case .minute: .minute
                case .second: .second
                case .nanosecond: .nanosecond
            }
        }


        public init?(rawValue: Component) {
            if #available(macOS 15, iOS 18, tvOS 18, watchOS 11, *) {
            switch rawValue {
                case .era: self = .era
                case .year: self = .year
                case .month: self = .month
                case .day: self = .day
                case .hour: self = .hour
                case .minute: self = .minute
                case .second: self = .second
                case .weekday: self = .weekday
                case .weekdayOrdinal: self = .weekdayOrdinal
                case .quarter: self = .quarter
                case .weekOfMonth: self = .weekOfMonth
                case .weekOfYear: self = .weekOfYear
                case .yearForWeekOfYear: self = .yearForWeekOfYear
                case .nanosecond: self = .nanosecond
                case .dayOfYear: self = .dayOfYear
                default: return nil
            }
        } else {
            switch rawValue {
                case .era: self = .era
                case .year: self = .year
                case .month: self = .month
                case .day: self = .day
                case .hour: self = .hour
                case .minute: self = .minute
                case .second: self = .second
                case .weekday: self = .weekday
                case .weekdayOrdinal: self = .weekdayOrdinal
                case .quarter: self = .quarter
                case .weekOfMonth: self = .weekOfMonth
                case .weekOfYear: self = .weekOfYear
                case .yearForWeekOfYear: self = .yearForWeekOfYear
                case .nanosecond: self = .nanosecond
                default: return nil
            }
        }
        }
        
    }
    
}


extension Calendar.Component {
    
    @inlinable
    public func toMeasurable() -> Calendar.MeasurableComponent? {
        return .init(rawValue: self)
    }
    
}



extension Set<Calendar.MeasurableComponent> {
    
    @inlinable
    public var rawComponents: Set<Calendar.Component> {
        .init(self.map(\.rawValue))
    }
    
}



extension Calendar.MeasurableComponent {
    
    public enum Granularity: Sendable {
        
        case nanosecond
        case second
        case minute
        case hour
        case day
        case month
        case year
        
        public var smallerNecessaryMeasurableComponents: Set<Calendar.MeasurableComponent> {
            switch self {
                case .nanosecond: []
                case .second: [.nanosecond]
                case .minute: [.nanosecond, .second]
                case .hour: [.nanosecond, .second, .minute]
                case .day: [.nanosecond, .second, .minute, .hour]
                case .month: [.nanosecond, .second, .minute, .hour, .day]
                case .year: [.nanosecond, .second, .minute, .hour, .day, .month]
            }
        }
        
        public var smallerNecessaryComponents: Set<Calendar.Component> {
            switch self {
                case .nanosecond: []
                case .second: [.nanosecond]
                case .minute: [.nanosecond, .second]
                case .hour: [.nanosecond, .second, .minute]
                case .day: [.nanosecond, .second, .minute, .hour]
                case .month: [.nanosecond, .second, .minute, .hour, .day]
                case .year: [.nanosecond, .second, .minute, .hour, .day, .month]
            }
        }
        
    }
    
}



extension DateComponents {

    @inlinable
    public func value(for component: Calendar.MeasurableComponent) -> Int {
        return self.value(for: component.rawValue) ?? 0
    }

}