//
//  Daate+Parsing.swift
//  FoundationPlus
//
//  Created by Star_Lord_PHB on 2024/8/15.
//

import Foundation


extension Date {
    
    /// Initializes a date instance, optionally specifying values for the components.
    public init?(
        calendar: Calendar = .current,
        timeZone: TimeZone = .current,
        era: Int? = nil,
        year: Int? = nil,
        month: Int? = nil,
        day: Int? = nil,
        hour: Int? = nil,
        minute: Int? = nil,
        second: Int? = nil,
        nanosecond: Int? = nil,
        weekday: Int? = nil,
        weekdayOrdinal: Int? = nil,
        quarter: Int? = nil,
        weekOfMonth: Int? = nil,
        weekOfYear: Int? = nil,
        yearForWeekOfYear: Int? = nil
    ) {
        self.init(
            components: .init(
                calendar: calendar,
                timeZone: timeZone,
                era: era,
                year: year,
                month: month,
                day: day,
                hour: hour,
                minute: minute,
                second: second,
                nanosecond: nanosecond,
                weekday: weekday,
                weekdayOrdinal: weekdayOrdinal,
                quarter: quarter,
                weekOfMonth: weekOfMonth,
                weekOfYear: weekOfYear,
                yearForWeekOfYear: yearForWeekOfYear
            ),
            calendar: calendar
        )
    }
    
    
    /// Create a Date instance by parsing the date string based on the provided format string
    /// - Parameters:
    ///   - string: The string representing a date to parse
    ///   - formatString: The format for parsing the string
    ///   - timeZone: The time zone to use for the created date
    ///   - locale: The locale to use for the created date
    ///   - calendar: The calendar to create the date
    public init(
        _ string: String,
        formatString: String,
        timeZone: TimeZone? = nil,
        locale: Locale? = nil,
        calendar: Calendar = .current
    ) throws {
        let formatter = DateFormatter()
        formatter.dateFormat = formatString
        formatter.timeZone = timeZone ?? calendar.timeZone
        formatter.locale = locale ?? calendar.locale
        formatter.calendar = calendar
        guard let date = formatter.date(from: string) else {
            throw CocoaError(
                .formatting,
                userInfo: [NSLocalizedDescriptionKey:"Cannot parse \(string)"]
            )
        }
        self = date
    }
    
    
    /// Create a Date instance by parsing the date string based on the provided format
    /// - Parameters:
    ///   - string: The string representing a date to parse
    ///   - format: The format for parsing the string as a [`Date.FormatString`]
    ///   - timeZone: The time zone to use for the created date
    ///   - locale: The locale to use for the created date
    ///   - calendar: The calendar to create the date
    ///
    /// [`Date.FormatString`]: https://developer.apple.com/documentation/foundation/date/formatstring
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public init(
        _ string: String,
        format: FormatString,
        timeZone: TimeZone? = nil,
        locale: Locale? = nil,
        calendar: Calendar = .current
    ) throws {
        let strategy = ParseStrategy(
            format: format,
            locale: locale ?? calendar.locale,
            timeZone: timeZone ?? calendar.timeZone,
            calendar: calendar
        )
        self = try Date(string, strategy: strategy)
    }
    
    
    /// Create a Date instance with the provided components
    /// - Parameters:
    ///   - components: The components for creating the date
    ///   - calendar: The calendar to create the date
    public init?(components: DateComponents, calendar: Calendar = .current) {
        guard let date = calendar.date(from: components) else {
            return nil
        }
        self = date
    }
    
    
    /// Create a Date instance by parsing the date string based on the ISO8601 standard
    /// - Parameters:
    ///   - string: The string representing a date to parse
    ///   - timeZone: The time zone to used for the created date
    @inlinable
    public static func iso8601Parse(
        _ string: String,
        timeZone: TimeZone = .init(secondsFromGMT: 0)!
    ) throws -> Date {
        if #available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *) {
            return try ISO8601FormatStyle(timeZone: timeZone).parse(string)
        } else {
            let formatter = ISO8601DateFormatter()
            formatter.timeZone = timeZone
            guard let date = formatter.date(from: string) else {
                throw CocoaError(
                    .formatting,
                    userInfo: [NSLocalizedDescriptionKey:"Cannot parse \(string)"]
                )
            }
            return date
        }
    }
    
}



extension DateComponents {
    /// Create a date instance from the Components
    @inlinable
    public func toDate(using calendar: Calendar = .current) -> Date {
        calendar.date(from: self)!
    }
}



@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension Date.FormatStyle.Symbol.VerbatimHour {
    
    /// Creates a custom format style portraying two digits with 24h clock that represent the hour.
    /// - Parameter hourCycle: The start of the clock representation.
    @inlinable
    public static func twoDigits24(hourCycle: Date.FormatStyle.Symbol.VerbatimHour.HourCycle = .oneBased) -> Self {
        .twoDigits(clock: .twentyFourHour, hourCycle: hourCycle)
    }
    
    /// Creates a custom format style portraying two digits with 12h clock that represent the hour.
    /// - Parameter hourCycle: The start of the clock representation.
    @inlinable
    public static func twoDigits12(hourCycle: Date.FormatStyle.Symbol.VerbatimHour.HourCycle = .oneBased) -> Self {
        .twoDigits(clock: .twelveHour, hourCycle: hourCycle)
    }
    
    /// Creates a custom format style portraying the minimum number of digits that represents the hour with 24h clock.
    /// - Parameter hourCycle: The start of the clock representation.
    @inlinable
    public static func defaultDigits24(hourCycle: Date.FormatStyle.Symbol.VerbatimHour.HourCycle = .oneBased) -> Self {
        .defaultDigits(clock: .twentyFourHour, hourCycle: hourCycle)
    }
    
    /// Creates a custom format style portraying the minimum number of digits that represents the hour with 12h clock.
    /// - Parameter hourCycle: The start of the clock representation.
    @inlinable
    public static func defaultDigits12(hourCycle: Date.FormatStyle.Symbol.VerbatimHour.HourCycle = .oneBased) -> Self {
        .defaultDigits(clock: .twelveHour, hourCycle: hourCycle)
    }
    
}
