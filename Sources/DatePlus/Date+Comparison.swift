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
    public func equals(
        to date: Date,
        in component: Calendar.Component,
        using calendar: Calendar = .current
    ) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }
    
    
    /// Return whether the date is larter than another date down to the specified component
    /// - Parameters:
    ///   - date: The other date for comparison
    ///   - component: The granularity for comparison
    ///   - calendar: The calendar to perform the comparison
    /// - Returns: true if the date is larger than the other date in the given component and
    /// all larger components
    public func larger(
        than date: Date,
        in component: Calendar.Component,
        using calendar: Calendar = .current
    ) -> Bool {
        calendar.compare(self, to: date, toGranularity: component) == .orderedDescending
    }
    
    
    /// Return whether the date is smaller than another date down to the specified component
    /// - Parameters:
    ///   - date: The other date for comparison
    ///   - component: The granularity for comparison
    ///   - calendar: The calendar to perform the comparison
    /// - Returns: true if the date is smaller than the other date in the given component and
    /// all larger components
    public func smaller(
        than date: Date,
        in component: Calendar.Component,
        using calendar: Calendar = .current
    ) -> Bool {
        calendar.compare(self, to: date, toGranularity: component) == .orderedAscending
    }
    
}
