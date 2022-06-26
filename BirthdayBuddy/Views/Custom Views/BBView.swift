//
//  BBView.swift
//  BirthdayBuddy
//
//  Created by Max Park on 6/24/22.
//

import UIKit

class BBView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    convenience init(backgroundColor: UIColor, isAutoLayoutOff: Bool) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.translatesAutoresizingMaskIntoConstraints = isAutoLayoutOff
    }
}
