//
//  BBTextField.swift
//  BirthdayBuddy
//
//  Created by Max Park on 6/25/22.
//

import UIKit

class BBTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
        
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    convenience init(placeholder: String) {
        self.init(frame: .zero)
        self.placeholder = placeholder
        self.textColor = .systemGray
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
