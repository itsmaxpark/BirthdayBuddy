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
