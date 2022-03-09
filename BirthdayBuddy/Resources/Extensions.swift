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

extension UIView {
    var width: CGFloat {
        return frame.size.width
    }
    var height: CGFloat {
        return frame.size.height
    }
    var left: CGFloat {
        return frame.origin.x
    }
    var right: CGFloat {
        return left + width
    }
    var top: CGFloat {
        return frame.origin.y
    }
    var bottom: CGFloat {
        return top + height
    }
}



