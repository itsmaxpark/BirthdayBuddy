//
//  BirthdayBuddyFont.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/7/22.
//

import UIKit

class BirthdayBuddyFont: UIFont {
    
    override init() {
        guard let font = UIFont(name: "IndieFlower", size: 44) else {
            fatalError("Unable to retrieve font")
        }
    }
}
