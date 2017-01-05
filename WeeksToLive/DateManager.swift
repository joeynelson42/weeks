//
//  DateManager.swift
//  WeeksToLive
//
//  Created by Joey on 12/16/16.
//  Copyright © 2016 NelsonJE. All rights reserved.
//

import UIKit

struct DateManager {
    
    /// Takes any day and returns the next previous Sunday
    func weekOf(day: Date) -> Date? {
        for i in 0...6 {
            guard let previousDay = NSCalendar.current.date(byAdding: .day, value: -i, to: day) else { return nil }
            if Calendar.current.component(.weekday, from: previousDay) == 0 {
                return previousDay
            }
        }
        return nil
    }
    
    /// Takes an index of all of a person's weeks, their DOB and returns the Sunday of that week
    func weekOf(index: Int, dob: Date) -> Date? {
        // get the Sunday before their birthday
        guard let weekOfBirth = weekOf(day: dob) else { return nil }
        
        // advance the day by the number of weeks (i.e. index * 7)
        guard let sundayForIndex = NSCalendar.current.date(byAdding: .day, value: (index * 7), to: weekOfBirth) else { return nil }
        return sundayForIndex
    }
    
    private func daysBetween(start: Date, end: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: start, to: end).day!
    }
    
    func totalWeeksSince(date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: Date()).weekOfYear!
    }
}
