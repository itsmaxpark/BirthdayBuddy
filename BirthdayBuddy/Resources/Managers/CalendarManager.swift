//
//  CalendarManager.swift
//  BirthdayBuddy
//
//  Created by Max Park on 6/24/22.
//

import Foundation

class CalendarManager {
    
    static let shared = CalendarManager()
    let calendar = Calendar.current
    let dateFormatter = CustomDateFormatter()
    
    enum CalendarDataError: Error {
        case metadataGeneration
    }
    // Accepts a date and returns a MonthMetadata
    func monthMetadata(for baseDate: Date) throws -> MonthMetadata {
        // get number of days in month
        guard
            let numberOfDaysInMonth = calendar.range(of: .day, in: .month, for: baseDate)?.count,
            let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: baseDate))
        else {
            throw CalendarDataError.metadataGeneration
        }
        // A number that represents which day (1-7) the first day is on
        let firstDayWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        return MonthMetadata(
            numberOfDays: numberOfDaysInMonth,
            firstDay: firstDayOfMonth,
            firstDayWeekday: firstDayWeekday)
    }
    
    // Accepts a Date and returns an array of CalendarDay objects
    func generateDaysInMonth(for baseDate: Date) -> [CalendarDay] {
        // Retrieve metadata for a month
        guard let metadata = try? monthMetadata(for: baseDate) else {
            fatalError("An error occurred when generating the metadata for \(baseDate)")
        }
        let numberOfDaysInMonth = metadata.numberOfDays
        let offsetInInitialRow = metadata.firstDayWeekday
        let firstDayOfMonth = metadata.firstDay
        // Offset the Month's start position if first day of month is not a Sunday
        var days: [CalendarDay] = (1..<(numberOfDaysInMonth + offsetInInitialRow)).map { day in
            // Check if current day is from previous or current month
            let isWithinDisplayedMonth = day >= offsetInInitialRow
            // Calculate the offset from current day to first day of month
            let dayOffset = isWithinDisplayedMonth ? day-offsetInInitialRow : -(offsetInInitialRow-day)
            // Create a CalendarDay
            return generateDay(
                offsetBy: dayOffset,
                for: firstDayOfMonth,
                isWithinDisplayedMonth: isWithinDisplayedMonth)
        }
        days += generateStartOfNextMonth(using: firstDayOfMonth, using: offsetInInitialRow, using: numberOfDaysInMonth)
        
        return days
    }
    
    func generateDay(offsetBy dayOffset: Int, for baseDate: Date, isWithinDisplayedMonth: Bool ) -> CalendarDay {
        let date = calendar.date(
            byAdding: .day,
            value: dayOffset,
            to: baseDate
        ) ?? baseDate
        
        return CalendarDay(
            date: date,
            number: dateFormatter.string(from: date),
            isSelected: checkIfDateExists(date: date),
            isWithinDisplayedMonth: isWithinDisplayedMonth
        )
    }
    
    // Takes in the first day of current month and returns an array of CalendarDay
    func generateStartOfNextMonth(
        using firstDayOfDisplayedMonth: Date,
        using firstDayWeekDay: Int,
        using numberOfDaysInMonth: Int
    ) -> [CalendarDay] {
        guard let lastDayInMonth = calendar.date(
            byAdding: DateComponents(month: 1, day: -1),
            to: firstDayOfDisplayedMonth
        ) else { return [] }
        // Gets how many days we need to add to end of the current month to fill last row/rows
        // ie) if last day is Saturday, additionalDays = 7
        var additionalDays: Int
        if firstDayWeekDay + numberOfDaysInMonth > 36 {
            additionalDays = 7 - calendar.component(.weekday, from: lastDayInMonth)
        } else {
            additionalDays = 14 - calendar.component(.weekday, from: lastDayInMonth)
        }
        guard additionalDays > 0 else {
            return []
        }
        // Generate the start of next month
        let days: [CalendarDay] = (1...additionalDays).map {
            generateDay(
                offsetBy: $0,
                for: lastDayInMonth,
                isWithinDisplayedMonth: false
            )
        }
        return days
    }
    
    func checkIfDateExists(date: Date) -> Bool {
        var dateExists: Bool
        var persons: [Person] = []
        DatabaseManager.shared.fetchPerson({ newPersons in
            persons = newPersons
        })
        for person in persons {
            guard let birthday = person.birthday else { fatalError() }
            if self.calendar.isSameMonthAndDay(date1: date, date2: birthday) {
                dateExists = true
            }
        }
        dateExists = false
        return dateExists
    }
    
    func getNextBirthday(date: Date) -> Date {
        // Get current date
        let currentDate = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        // get birthday date
        var birthday = Calendar.current.dateComponents([.day,.month,.year], from: date)
        // set birthday year to current year
        birthday.year = currentDate.year
        // if birthday already happened this year, add 1 to year
        let numberOfDays = Calendar.current.dateComponents([.day], from: currentDate, to: birthday).day!
        if numberOfDays < 0 {
            birthday.year! += 1
        }
        let nextBirthday = Calendar.current.date(from: birthday)
        
        return nextBirthday!
    }
    
    func getMonthData() -> [[CalendarDay]] {
        var newMonthData: [[CalendarDay]] = []
        
        for month in 1...12 {
            var dateComponents = DateComponents()
            dateComponents.month = month
            if month < calendar.getCurrentMonth() {
                dateComponents.year = calendar.getCurrentYear() + 1
            } else {
                dateComponents.year = calendar.getCurrentYear()
            }
            let calendar = Calendar(identifier: .gregorian)
            let date = calendar.date(from: dateComponents)
            let newMonth = self.generateDaysInMonth(for: date!)
            newMonthData.append(newMonth)
        }
        newMonthData.rotate(array: &newMonthData, k: -(calendar.getCurrentMonth()-1))
        return newMonthData
    }
}
