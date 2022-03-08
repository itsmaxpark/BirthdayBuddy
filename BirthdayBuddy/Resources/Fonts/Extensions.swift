//
//  Font.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/8/22.
//

import Foundation
import UIKit

extension UIFont {
    
    static func appFont(size: CGFloat) -> UIFont {
        guard let customFont = UIFont(name: "IndieFlower", size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return customFont
    }
}

