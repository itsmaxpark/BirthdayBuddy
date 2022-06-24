//
//  Date+Ext.swift
//  BirthdayBuddy
//
//  Created by Max Park on 6/24/22.
//

import Foundation

extension Date {
    
    func getString(components: Set<Calendar.Component>) -> String {
        let dateComponents = Calendar.current.dateComponents(components, from: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        
        guard let month = dateComponents.month else { return ""}
        guard let day = dateComponents.day else { return ""}
        
        if components.contains(.year) {
            dateFormatter.dateFormat = "MM/dd/yyyy"
            guard let year = dateComponents.year else { return "" }
            let text = "\(month)/\(day)/\(year)"
            return text
        }
        let text = "\(month)/\(day)"
        return text
    }
}
