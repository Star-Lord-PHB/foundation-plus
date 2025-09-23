//
//  Date+Comparison.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/8/15.
//

import Foundation


extension Date {
    
    /// Return whether the date is equals to another date down to the specific component
    /// - Parameters:
    ///   - date: The other date for comparison
    ///   - component: The granularity for comparison
    ///   - calendar: The calendar to perform the comparison
    /// - Returns: true if the two dates are equal in the given component and all larger
    /// components; otherwise, false.
    @inlinable
    public func equals(
        to date: Date,
        in component: Calendar.Component,
        using calendar: Calendar = .current
    ) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }
    
    
    /// Return whether the date is larger than another date down to the specified component
    /// - Parameters:
    ///   - date: The other date for comparison
    ///   - component: The granularity for comparison
    ///   - calendar: The calendar to perform the comparison
    /// - Returns: true if the date is larger than the other date in the given component and
    /// all larger components
    @inlinable
    public func larger(
        than date: Date,
        in component: Calendar.Component,
        using calendar: Calendar = .current
    ) -> Bool {
        calendar.compare(self, to: date, toGranularity: component) == .orderedDescending
    }


    /// Return whether the date is larger than or equal to another date down to the specified component
    /// - Parameters:
    ///   - date: The other date for comparison
    ///   - component: The granularity for comparison
    ///   - calendar: The calendar to perform the comparison
    /// - Returns: true if the date is larger than or equal to the other date in the given component and
    /// all larger components
    @inlinable
    public func largerOrEqual(
        than date: Date,
        in component: Calendar.Component,
        using calendar: Calendar = .current
    ) -> Bool {
        calendar.compare(self, to: date, toGranularity: component) != .orderedAscending
    }
    
    
    /// Return whether the date is smaller than another date down to the specified component
    /// - Parameters:
    ///   - date: The other date for comparison
    ///   - component: The granularity for comparison
    ///   - calendar: The calendar to perform the comparison
    /// - Returns: true if the date is smaller than the other date in the given component and
    /// all larger components
    @inlinable
    public func smaller(
        than date: Date,
        in component: Calendar.Component,
        using calendar: Calendar = .current
    ) -> Bool {
        calendar.compare(self, to: date, toGranularity: component) == .orderedAscending
    }


    /// Return whether the date is smaller than or equal to another date down to the specified component
    /// - Parameters:
    ///   - date: The other date for comparison
    ///   - component: The granularity for comparison
    ///   - calendar: The calendar to perform the comparison
    /// - Returns: true if the date is smaller than or equal to the other date in the given component and
    /// all larger components
    @inlinable
    public func smallerOrEqual(
        than date: Date,
        in component: Calendar.Component,
        using calendar: Calendar = .current
    ) -> Bool {
        calendar.compare(self, to: date, toGranularity: component) != .orderedDescending
    }


    /// Compares the date to another date down to the specified component
    /// - Parameters:
    ///   - date: The other date for comparison
    ///   - component: The granularity for comparison
    ///   - calendar: The calendar to perform the comparison
    /// - Returns: The comparison result.
    /// 
    /// - If date is smaller than the other date in the given component and all larger components,
    ///   returns `.orderedAscending`.
    /// - If date is equal to the other date in the given component and all larger components,
    ///   returns `.orderedSame`.
    /// - If date is larger than the other date in the given component and all larger components,
    ///   returns `.orderedDescending`.
    /// 
    /// - Seealso: [`ComparisonResult`](https://developer.apple.com/documentation/foundation/comparisonresult)
    @inlinable
    public func compare(
        to date: Date,
        in component: Calendar.Component,
        using calendar: Calendar = .current
    ) -> ComparisonResult {
        calendar.compare(self, to: date, toGranularity: component)
    }

}
