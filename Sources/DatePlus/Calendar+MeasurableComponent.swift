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
    public enum MeasurableComponent: RawRepresentable, CaseIterable, Sendable {
        
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
        
        
        /// Get the granularity level of this component
        /// 
        /// For example, `.day` has finer granularity than `.month`
        /// 
        /// - Seealso: ``Calendar/MeasurableComponent/Granularity``
        @inlinable
        public var granularity: Granularity {
            switch self {
                case .era: .era
                case .year, .yearForWeekOfYear: .year
                case .quarter: .quarter
                case .month: .month
                case .weekOfMonth, .weekOfYear: .week
                case .day, .weekday, .weekdayOrdinal, .dayOfYear: .day
                case .hour: .hour
                case .minute: .minute
                case .second: .second
                case .nanosecond: .nanosecond
            }
        }


        /// Get the set of smaller components that are necessary to define a precise and valid date when this component is specified
        @inlinable
        public var smallerNecessaryComponents: Set<Calendar.Component> {
            switch self {
                case .era: [.year, .month, .day, .hour, .minute, .second, .nanosecond]
                case .year, .quarter: [.month, .day, .hour, .minute, .second, .nanosecond]
                case .yearForWeekOfYear: [.weekOfYear, .weekday, .weekdayOrdinal, .hour, .minute, .second, .nanosecond]
                case .month: [.day, .hour, .minute, .second, .nanosecond]
                case .weekOfMonth, .weekOfYear: [.weekday, .weekdayOrdinal, .hour, .minute, .second, .nanosecond]
                case .day, .weekday, .weekdayOrdinal, .dayOfYear: [.hour, .minute, .second, .nanosecond]
                case .hour: [.minute, .second, .nanosecond]
                case .minute: [.second, .nanosecond]
                case .second: [.nanosecond]
                case .nanosecond: []
            }
        }


        /// Get the set of smaller components that are necessary to define a precise and valid date when this component is specified
        @inlinable
        public var smallerNecessaryMeasurableComponents: Set<Calendar.MeasurableComponent> {
            switch self {
                case .era: [.year, .month, .day, .hour, .minute, .second, .nanosecond]
                case .year, .quarter: [.month, .day, .hour, .minute, .second, .nanosecond]
                case .yearForWeekOfYear: [.weekOfYear, .weekday, .weekdayOrdinal, .hour, .minute, .second, .nanosecond]
                case .month: [.day, .hour, .minute, .second, .nanosecond]
                case .weekOfMonth, .weekOfYear: [.weekday, .weekdayOrdinal, .hour, .minute, .second, .nanosecond]
                case .day, .weekday, .weekdayOrdinal, .dayOfYear: [.hour, .minute, .second, .nanosecond]
                case .hour: [.minute, .second, .nanosecond]
                case .minute: [.second, .nanosecond]
                case .second: [.nanosecond]
                case .nanosecond: []
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


        public static let allCases: [Calendar.MeasurableComponent] = 
            if #available(macOS 15, iOS 18, tvOS 18, watchOS 11, *) {
                [
                    .era, .year, .month, .day, .hour, .minute, .second, .nanosecond, 
                    .weekday, .weekdayOrdinal, .quarter, .weekOfMonth, .weekOfYear, .yearForWeekOfYear, .dayOfYear
                ] 
            } else {
                [
                    .era, .year, .month, .day, .hour, .minute, .second, 
                    .weekday, .weekdayOrdinal, .quarter, .weekOfMonth, .weekOfYear, .yearForWeekOfYear
                ]
            }
        
    }
    
}


extension Calendar.Component {

    /// Convert the component to a ``Calendar/MeasurableComponent``, if possible
    @inlinable
    public func toMeasurable() -> Calendar.MeasurableComponent? {
        return .init(rawValue: self)
    }
    
}



extension Set<Calendar.MeasurableComponent> {
    
    /// Convert the set of ``Calendar/MeasurableComponent`` to a set of `Calendar.Component`
    @inlinable
    public var rawComponents: Set<Calendar.Component> {
        .init(self.map(\.rawValue))
    }
    
}



extension Calendar.MeasurableComponent {
    
    /// The granularity level of a measurable component
    public enum Granularity: Int, Sendable, CaseIterable {
        
        case nanosecond
        case second
        case minute
        case hour
        case day
        case week
        case month
        case quarter
        case year
        case era
        
    }
    
}



extension Calendar.MeasurableComponent.Granularity: Comparable {
    
    @inlinable
    public static func < (lhs: Calendar.MeasurableComponent.Granularity, rhs: Calendar.MeasurableComponent.Granularity) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
}



extension DateComponents {

    /// Get the value of the specified ``Calendar/MeasurableComponent``
    @inlinable
    public func value(for component: Calendar.MeasurableComponent) -> Int? {
        return self.value(for: component.rawValue)
    }

    /// Set the value of the specified ``Calendar/MeasurableComponent``
    @inlinable
    public mutating func setValue(_ value: Int?, for component: Calendar.MeasurableComponent) {
        self.setValue(value, for: component.rawValue)
    }


}