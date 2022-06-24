//
//  UIFont+Ext.swift
//  BirthdayBuddy
//
//  Created by Max Park on 6/24/22.
//

import UIKit

extension UIFont {
    
    static func appFont(name: String, size: CGFloat) -> UIFont {
        guard let customFont = UIFont(name: name, size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return customFont
    }
}
