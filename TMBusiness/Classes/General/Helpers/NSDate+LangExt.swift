//
//  NSDate+LangExt.swift
//  AZKit
//
//  Created by ZhangMing on 14-9-6.
//  Copyright (c) 2014年 ZhangMing. All rights reserved.
//

import Foundation

enum DateFormat {
    case ISO8601, DotNet, RSS, AltRSS
    case Custom(String)
}

extension NSDate {
    // MARK: - Intervals In Seconds
    var minuteInSeconds: Double {
        get {
            return 60
        }
    }
    
    var hourInSeconds: Double {
        get {
            return 3600
        }
    }
    
    var dayInSeconds: Double {
        return 86400
    }
    
    var weekInSeconds: Double {
        get {
            return 604800
        }
    }
    
    var yearInSeconds: Double {
        get {
            return 31556926
        }
    }
    
    // MARK: - Components
     private class func componentFlags() -> NSCalendarUnit {
        return
            .YearCalendarUnit | .MonthCalendarUnit |
            .DayCalendarUnit | .WeekCalendarUnit |
            .HourCalendarUnit | .MinuteCalendarUnit |
            .SecondCalendarUnit | .WeekdayCalendarUnit |
            .WeekdayOrdinalCalendarUnit | .CalendarUnitWeekOfYear
    }
    
    private class func components(#fromDate: NSDate) -> NSDateComponents {
        return NSCalendar.currentCalendar().components(NSDate.componentFlags(), fromDate: fromDate)
    }
    
    private func components() -> NSDateComponents {
        return NSDate.components(fromDate: self);
    }
    
    // MARK: - Date From String
    
    convenience init(fromString string: String, format: DateFormat) {
        if string.isEmpty {
            self.init()
            return
        }
        
        let string = string as NSString
        
        switch format {
        case .DotNet:
            // Expects "/Date(1268123281843)/"
            let startIndex = string.rangeOfString("(").location + 1
            let endIndex = string.rangeOfString(")").location
            let range = NSRange(location: startIndex, length: endIndex - startIndex)
            let milliseconds = (string.substringWithRange(range) as NSString).longLongValue
            let interval = NSTimeInterval(milliseconds / 1000)
            self.init(timeIntervalSince1970: interval)
            
        case .ISO8601:
            var s = string
            if string.hasSuffix(" 00:00") {
                s = s.substringToIndex(s.length - 6) + "GMT"
            } else if string.hasSuffix("Z") {
                s = s.substringToIndex(s.length + 1) + "GMT"
            }
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
            
            if let date = formatter.dateFromString(string as String) {
                self.init(timeInterval: 0, sinceDate: date)
            } else {
                self.init()
            }
            
        case .RSS:
            var s  = string
            if string.hasSuffix("Z") {
                s = s.substringToIndex(s.length-1) + "GMT"
            }
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss ZZZ"
            
            if let date = formatter.dateFromString(string as String) {
                self.init(timeInterval:0, sinceDate:date)
            } else {
                self.init()
            }
        case .AltRSS:
            var s  = string
            if string.hasSuffix("Z") {
                s = s.substringToIndex(s.length-1) + "GMT"
            }
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "d MMM yyyy HH:mm:ss ZZZ"
            
            if let date = formatter.dateFromString(string as String) {
                self.init(timeInterval:0, sinceDate:date)
            } else {
                self.init()
            }
        case .Custom(let dateFormat):
            let formatter = NSDateFormatter()
            formatter.dateFormat = dateFormat
            
            if let date = formatter.dateFromString(string as String) {
                self.init(timeInterval:0, sinceDate:date)
            } else {
                self.init()
            }
        }
    }
    
    // MARK: - Comparing Dates
    func isEqualToDateIgnoringTime(date: NSDate) -> Bool {
        let comp1 = NSDate.components(fromDate: self)
        let comp2 = NSDate.components(fromDate: date)
        
        return (comp1.year == comp2.year) && (comp1.month == comp2.month) && (comp1.day  == comp2.day)
    }
    
    func isToday() -> Bool {
        return self.isEqualToDateIgnoringTime(NSDate())
    }
    
    func isTomorrow() -> Bool {
        return self.isEqualToDateIgnoringTime(NSDate().dateByAddingDays(1))
    }
    
    func isYesterday() -> Bool {
        return self.isEqualToDateIgnoringTime(NSDate().dateBySubtractingDays(1))
    }
    
    func isSameWeekAsDate(date: NSDate) -> Bool {
        let comp1 = NSDate.components(fromDate: self)
        let comp2 = NSDate.components(fromDate: date)
        // Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
        if comp1.weekOfYear != comp2.weekOfYear {
            return false
        }
        // Must have a time interval under 1 week
        return abs(self.timeIntervalSinceDate(date)) < weekInSeconds
    }
    
    func isThisWeek() -> Bool {
        return self.isSameWeekAsDate(NSDate())
    }
    
    func isNextWeek() -> Bool {
        let interval: NSTimeInterval = NSDate().timeIntervalSinceReferenceDate + weekInSeconds
        let date = NSDate(timeIntervalSinceReferenceDate: interval)
        return self.isSameYearAsDate(date)
    }
    
    func isLastWeek() -> Bool {
        let interval: NSTimeInterval = NSDate().timeIntervalSinceReferenceDate - weekInSeconds
        let date = NSDate(timeIntervalSinceReferenceDate: interval)
        return self.isSameYearAsDate(date)
    }
    
    func isSameYearAsDate(date: NSDate) -> Bool {
        let comp1 = NSDate.components(fromDate: self)
        let comp2 = NSDate.components(fromDate: date)
        return (comp1.year == comp2.year)
    }
    
    func isThisYear() -> Bool  {
        return self.isSameYearAsDate(NSDate())
    }
    
    func isNextYear() -> Bool {
        let comp1 = NSDate.components(fromDate: self)
        let comp2 = NSDate.components(fromDate: NSDate())
        return (comp1.year == comp2.year + 1)
    }
    
    func isLastYear() -> Bool {
        let comp1 = NSDate.components(fromDate: self)
        let comp2 = NSDate.components(fromDate: NSDate())
        return (comp1.year == comp2.year - 1)
    }
    
    func isEarlierThanDate(date: NSDate) -> Bool {
        return self.earlierDate(date) == self
    }
    
    func isLaterThanDate(date: NSDate) -> Bool {
        return self.laterDate(date) == self
    }
    
    // MARK: - Adjusting Dates
    func dateByAddingDays(days: Int) -> NSDate {
        let interval: NSTimeInterval = self.timeIntervalSinceReferenceDate + dayInSeconds * Double(days)
        return NSDate(timeIntervalSinceReferenceDate: interval)
    }
    
    func dateBySubtractingDays(days: Int) -> NSDate {
        let interval: NSTimeInterval = self.timeIntervalSinceReferenceDate - dayInSeconds * Double(days)
        return NSDate(timeIntervalSinceReferenceDate: interval)
    }
    
    func dateByAddingHours(hours: Int) -> NSDate {
        let interval: NSTimeInterval = self.timeIntervalSinceReferenceDate + hourInSeconds * Double(hours)
        return NSDate(timeIntervalSinceReferenceDate: interval)
    }
    
    func dateBySubtractingHours(hours: Int) -> NSDate {
        let interval: NSTimeInterval = self.timeIntervalSinceReferenceDate - hourInSeconds * Double(hours)
        return NSDate(timeIntervalSinceReferenceDate: interval)
    }
    
    func dateByAddingMinutes(minutes: Int) -> NSDate {
        let interval: NSTimeInterval = self.timeIntervalSinceReferenceDate + minuteInSeconds * Double(minutes)
        return NSDate(timeIntervalSinceReferenceDate: interval)
    }
    
    func dateBySubtractingMinutes(minutes: Int) -> NSDate {
        let interval: NSTimeInterval = self.timeIntervalSinceReferenceDate - minuteInSeconds * Double(minutes)
        return NSDate(timeIntervalSinceReferenceDate: interval)
    }
    
    func dateByAddingSeconds(seconds: Int) -> NSDate {
        let interval: NSTimeInterval = self.timeIntervalSinceReferenceDate + Double(seconds)
        return NSDate(timeIntervalSinceReferenceDate: interval)
    }
    
    func dateBySubtractingSeconds(seconds: Int) -> NSDate {
        let interval: NSTimeInterval = self.timeIntervalSinceReferenceDate - Double(seconds)
        return NSDate(timeIntervalSinceReferenceDate: interval)
    }
    
    func dateAtStartOfDay() -> NSDate? {
        var components = self.components()
        components.hour = 0
        components.minute = 0
        components.second = 0
        return NSCalendar.currentCalendar().dateFromComponents(components)
    }
    
    func dateAtEndDay() -> NSDate? {
        var components = self.components()
        components.hour = 23
        components.minute = 59
        components.second = 59
        return NSCalendar.currentCalendar().dateFromComponents(components)
    }
    
    func dateAtStartOfWeek() -> NSDate? {
        let flags :NSCalendarUnit = .YearCalendarUnit | .MonthCalendarUnit | .WeekCalendarUnit | .WeekdayCalendarUnit
        
        var components = NSCalendar.currentCalendar().components(flags, fromDate: self)
        
        components.weekday = 1 // Sunday
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        return NSCalendar.currentCalendar().dateFromComponents(components)
    }
    
    func dateAtEndOfWeek() -> NSDate? {
        let flags :NSCalendarUnit = .YearCalendarUnit | .MonthCalendarUnit | .WeekCalendarUnit | .WeekdayCalendarUnit
        var components = NSCalendar.currentCalendar().components(flags, fromDate: self)
        
        components.weekday = 7 // Sunday
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        return NSCalendar.currentCalendar().dateFromComponents(components)
    }
    
    // MARK: - Retrieving Intervals
    func minutesAfterDate(date: NSDate) -> Int {
        let interval = self.timeIntervalSinceDate(date)
        return Int(interval / minuteInSeconds)
    }
    
    func minutesBeforeDate(date: NSDate) -> Int {
        let interval = date.timeIntervalSinceDate(self)
        return Int(interval / minuteInSeconds)
    }
    
    func hoursAfterDate(date: NSDate) -> Int {
        let interval = self.timeIntervalSinceDate(date)
        return Int(interval / hourInSeconds)
    }
    
    func hoursBeforeDate(date: NSDate) -> Int {
        let interval = date.timeIntervalSinceDate(self)
        return Int(interval / hourInSeconds)
    }
    
    func daysAfterDate(date: NSDate) -> Int {
        let interval = self.timeIntervalSinceDate(date)
        return Int(interval / dayInSeconds)
    }
    
    func daysBeforeDate(date: NSDate) -> Int {
        let interval = date.timeIntervalSinceDate(self)
        return Int(interval / dayInSeconds)
    }
    
    // MARK: - Decomposing Dates
    
    func nearestHour() -> Int {
        let halfHour = minuteInSeconds * 30
        var interval = self.timeIntervalSinceReferenceDate
        
        if  self.seconds() < 30 {
            interval -= halfHour
        } else {
            interval += halfHour
        }
        let date = NSDate(timeIntervalSinceReferenceDate: interval)
        return date.hour()
    }
    
    func year () -> Int {
        return self.components().year
    }
    
    func month () -> Int {
        return self.components().month
    }
    
    func week () -> Int {
        return self.components().weekOfYear
    }
    
    func day () -> Int {
        return self.components().day
    }
    
    func hour () -> Int {
        return self.components().hour
    }
    
    func minute () -> Int {
        return self.components().minute
    }
    
    func seconds () -> Int {
        return self.components().second
    }
    
    func weekday () -> Int {
        return self.components().weekday
    }
    func nthWeekday () -> Int {
        return self.components().weekdayOrdinal     // e.g. 2nd Tuesday of the month is 2
    }
    
    func monthDays () -> Int {
        return NSCalendar.currentCalendar().rangeOfUnit(.DayCalendarUnit, inUnit: .MonthCalendarUnit, forDate: self).length
    }
    
    func firstDayOfWeek () -> Int {
        let distanceToStartOfWeek = dayInSeconds * Double(self.components().weekday - 1)
        let interval: NSTimeInterval = self.timeIntervalSinceReferenceDate - distanceToStartOfWeek
        return NSDate(timeIntervalSinceReferenceDate: interval).day()
    }
    
    func lastDayOfWeek () -> Int {
        let distanceToStartOfWeek = dayInSeconds * Double(self.components().weekday - 1)
        let distanceToEndOfWeek = dayInSeconds * Double(7)
        
        let interval: NSTimeInterval = self.timeIntervalSinceReferenceDate - distanceToStartOfWeek + distanceToEndOfWeek
        return NSDate(timeIntervalSinceReferenceDate: interval).day()
    }
    
    func isWeekday() -> Bool {
        return !self.isWeekend()
    }
    
    func isWeekend() -> Bool {
        let range = NSCalendar.currentCalendar().maximumRangeOfUnit(.WeekdayCalendarUnit)
        return (self.weekday() == range.location || self.weekday() == range.length)
    }
    
    // MARK: - To String
    func toString() -> String {
        return self.toString(dateStyle: .ShortStyle, timeStyle: .ShortStyle, doesRelativeDateFormatting: false)
    }
    
    func toString(#format: DateFormat) -> String {
        var dateFormat: String
        switch format {
        case .DotNet:
            let offset = NSTimeZone.defaultTimeZone().secondsFromGMT / 3600
            let nowMillis = 1000 * self.timeIntervalSince1970
            return  "/Date(\(nowMillis)\(offset))/"
        case .ISO8601:
            dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        case .RSS:
            dateFormat = "EEE, d MMM yyyy HH:mm:ss ZZZ"
        case .AltRSS:
            dateFormat = "d MMM yyyy HH:mm:ss ZZZ"
        case .Custom(let string):
            dateFormat = string
        }
        let formatter = NSDateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.stringFromDate(self)
    }
    
    func toString(#dateStyle: NSDateFormatterStyle, timeStyle: NSDateFormatterStyle, doesRelativeDateFormatting: Bool = false) -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        formatter.doesRelativeDateFormatting = doesRelativeDateFormatting
        return formatter.stringFromDate(self)
    }
    
    func relativeTimeToString() -> String
    {
        let time = self.timeIntervalSince1970
        let now = NSDate().timeIntervalSince1970
        
        let seconds = now - time
        let minutes = round(seconds/60)
        let hours = round(minutes/60)
        let days = round(hours/24)
        
        if seconds < 10 {
            return NSLocalizedString("just now", comment: "relative time")
        } else if seconds < 60 {
            return NSLocalizedString("\(seconds) seconds ago", comment: "relative time")
        }
        
        if minutes < 60 {
            if minutes == 1 {
                return NSLocalizedString("1 minute ago", comment: "relative time")
            } else {
                return NSLocalizedString("\(minutes) minutes ago", comment: "relative time")
            }
        }
        
        if hours < 24 {
            if hours == 1 {
                return NSLocalizedString("1 hour ago", comment: "relative time")
            } else {
                return NSLocalizedString("\(hours) hours ago", comment: "relative time")
            }
        }
        
        if days < 7 {
            if days == 1 {
                return NSLocalizedString("1 day ago", comment: "relative time")
            } else {
                return NSLocalizedString("\(days) days ago", comment: "relative time")
            }
        }
        
        return self.toString()
    }
    
    
    func weekdayToString() -> String {
        let formatter = NSDateFormatter()
        return formatter.weekdaySymbols[self.weekday() - 1] as! String
    }
    
    func shortWeekdayToString() -> String {
        let formatter = NSDateFormatter()
        return formatter.shortWeekdaySymbols[self.weekday() - 1] as! String
    }
    
    func veryShortWeekdayToString() -> String {
        let formatter = NSDateFormatter()
        return formatter.veryShortWeekdaySymbols[self.weekday() - 1] as! String
    }
    
    func monthToString() -> String {
        let formatter = NSDateFormatter()
        return formatter.monthSymbols[self.month() - 1] as! String
    }
    
    func shortMonthToString() -> String {
        let formatter = NSDateFormatter()
        return formatter.shortMonthSymbols[self.month() - 1] as! String
    }
    
    func veryShortMonthToString() -> String {
        let formatter = NSDateFormatter()
        return formatter.veryShortMonthSymbols[self.month() - 1] as! String
    }
    
    func startDateInDay() -> NSDate {
        
        var hour = self.hour()
        var minute = self.minute()
        var second = self.seconds()
        
        var totalSeconds = hour * Int(hourInSeconds) + minute * Int(minuteInSeconds) + second
        
        var date = dateBySubtractingSeconds(totalSeconds)
        
        return date
    }
    
    func endDateInDay() -> NSDate {
        var hour = self.hour()
        var minute = self.minute()
        var second = self.seconds()
        
        var totalSeconds = (23 - hour) * Int(hourInSeconds) + (59 - minute) * Int(minuteInSeconds) + (59 - second)
        
        var date = dateByAddingSeconds(totalSeconds)
        
        return date
    }
}