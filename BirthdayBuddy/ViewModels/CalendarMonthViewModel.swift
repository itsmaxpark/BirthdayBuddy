//
//  CollectionViewCellViewModel.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/29/22.
//

import Foundation
import UIKit

struct CalendarMonthViewModel {
    let name: String
    let id: Int
}

enum CalendarMonthViewModels {
    static let viewModels: [CalendarMonthViewModel] = [
        CalendarMonthViewModel(name: "January", id: 1),
        CalendarMonthViewModel(name: "February", id: 2),
        CalendarMonthViewModel(name: "March", id: 3),
        CalendarMonthViewModel(name: "April", id: 4),
        CalendarMonthViewModel(name: "May", id: 5),
        CalendarMonthViewModel(name: "June", id: 6),
        CalendarMonthViewModel(name: "July", id: 7),
        CalendarMonthViewModel(name: "August", id: 8),
        CalendarMonthViewModel(name: "September", id: 9),
        CalendarMonthViewModel(name: "October", id: 10),
        CalendarMonthViewModel(name: "November", id: 11),
        CalendarMonthViewModel(name: "December", id: 12),
    ]
}
