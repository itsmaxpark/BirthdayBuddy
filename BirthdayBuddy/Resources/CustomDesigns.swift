//
//  CustomDesigns.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/11/22.
//

import Foundation
import UIKit




class CustomDesigns {
    
    static let shared = CustomDesigns()
    
    func createCustomButtonConfig(text: String, font: UIFont, image: UIImage, insets: NSDirectionalEdgeInsets) -> UIButton.Configuration {
        var container = AttributeContainer()
        container.font = font
        
        var config = UIButton.Configuration.filled()
        config.attributedTitle = AttributedString(text, attributes: container)
        
        config.buttonSize = .large
        config.cornerStyle = .capsule
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .black
        
        config.image = image
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 19)
        config.imagePadding = 20
        config.contentInsets = insets
        
        return config
    }
}



