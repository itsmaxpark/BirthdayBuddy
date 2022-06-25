//
//  CustomDateFormatter.swift
//  BirthdayBuddy
//
//  Created by Max Park on 6/24/22.
//

import Foundation

class CustomDateFormatter: DateFormatter {
    
    override init() {
        super.init()
        dateFormat = "d"
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
