//
//  Date+Extension.swift
//  Models
//
//  Created by Johann Petzold on 17/01/2025.
//

import Foundation

extension Date {
    
    public static func randomDateBetween(start: Date, end: Date) -> Date {
        let timeInterval = end.timeIntervalSince(start)
        let randomTimeInterval = TimeInterval(arc4random_uniform(UInt32(timeInterval)))
        return start.addingTimeInterval(randomTimeInterval)
    }
    
    public func formatRelativeDayAndTime() -> String {
        let calendar = Calendar.current
        
        if calendar.isDateInToday(self) {
            return "Today, \(self.formatTimeOnly())"
        } else if calendar.isDateInYesterday(self) {
            return "Yesterday, \(self.formatTimeOnly())"
        } else {
            return "\(self.formatDayMonthHourMinute())"
        }
    }
    
    public func formatTimeOnly() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
    
    public func formatDayMonthHourMinute() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM, HH:mm"
        return dateFormatter.string(from: self)
    }
    
    public func formatRelativeDay() -> String {
        let calendar = Calendar.current
        
        if calendar.isDateInToday(self) {
            return "Today"
        } else if calendar.isDateInYesterday(self) {
            return "Yesterday"
        } else {
            return "\(self.formatDayMonthYear())"
        }
    }
    
    public func formatDayMonthYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
