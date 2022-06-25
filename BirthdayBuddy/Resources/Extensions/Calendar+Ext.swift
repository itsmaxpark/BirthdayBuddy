//
//  Calendar+Ext.swift
//  BirthdayBuddy
//
//  Created by Max Park on 6/24/22.
//

import Foundation

extension Calendar {
    
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from) // <1>
        let toDate = startOfDay(for: to) // <2>
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate) // <3>
        
        return numberOfDays.day!
    }
    
    func getCurrentMonth() -> Int {
        return component(.month, from: Date())
    }
    
    func getCurrentYear() -> Int {
        return component(.year, from: Date())
    }
    
    func isSameMonthAndDay(date1: Date, date2: Date) -> Bool {
        let oldFirstDate = Calendar.current.dateComponents([.day, .month, .year], from: date1)
        let oldSecondDate = Calendar.current.dateComponents([.day, .month, .year], from: date2)
        var firstDate = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        var secondDate = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        firstDate.month = oldFirstDate.month
        secondDate.month = oldSecondDate.month
        firstDate.day = oldFirstDate.day
        secondDate.day = oldSecondDate.day
        let newFirstDate = Calendar.current.date(from: firstDate)
        let newSecondDate = Calendar.current.date(from: secondDate)
        let isDayEqual = Calendar.current.isDate(newFirstDate!, equalTo: newSecondDate!, toGranularity: .day)
        let isMonthEqual = Calendar.current.isDate(newFirstDate!, equalTo: newSecondDate!, toGranularity: .month)
        if isDayEqual && isMonthEqual {
            return true
        }
        return false
    }
}
