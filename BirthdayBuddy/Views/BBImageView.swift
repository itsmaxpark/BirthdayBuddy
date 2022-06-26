//
//  BBImageView.swift
//  BirthdayBuddy
//
//  Created by Max Park on 6/25/22.
//

import UIKit

class BBImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    convenience init(image: UIImage, cornerRadius: CGFloat, clipsToBounds: Bool, contentMode: ContentMode) {
        self.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        self.image = image
        layer.cornerRadius = cornerRadius
        self.clipsToBounds = clipsToBounds
        self.contentMode = contentMode
    }
}
