//
//  BBButton.swift
//  BirthdayBuddy
//
//  Created by Max Park on 6/24/22.
//

import UIKit

class BBButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    convenience init(image: UIImage, contentMode: ContentMode) {
        self.init(frame: .zero)
        self.imageView?.image = image
        self.contentMode = contentMode
    }
    
    convenience init(color: UIColor, title: String, image: UIImage) {
        self.init(frame: .zero)
        configure()
        set(color: color, title: title, image: image)
    }
    
    convenience init(titleColor: UIColor, title: String, font: UIFont) {
        self.init(frame: .zero)
        self.titleLabel?.font = font
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.systemBlue.cgColor
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configure() {
        configuration = .tinted()
        configuration?.cornerStyle = .medium
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    final func set(color: UIColor, title: String, image: UIImage) {
        configuration?.baseBackgroundColor = color
        configuration?.baseForegroundColor = color
        configuration?.title = title
        
        configuration?.image = image
        configuration?.imagePadding = 6
        configuration?.imagePlacement = .leading
    }
}

//button.titleLabel?.font = UIFont.appFont(name: "Rubik", size: 20)
//button.setTitle("Change Photo", for: .normal)
//button.setTitleColor(UIColor.systemBlue, for: .normal)
//button.layer.cornerRadius = 10
//button.layer.borderColor = UIColor.systemBlue.cgColor
//button.layer.borderWidth = 2.0
//button.translatesAutoresizingMaskIntoConstraints = false
