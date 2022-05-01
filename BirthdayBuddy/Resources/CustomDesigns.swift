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
    
    func createCustomTextField(previewText: String, isSecure: Bool) -> UITextField {
        
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 20
        field.attributedPlaceholder = NSAttributedString(
            string: previewText,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 19)
            ]
        )
        field.textColor = .black
        field.backgroundColor = .white
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        field.leftViewMode = .always
        field.isSecureTextEntry = isSecure
        field.textContentType = .oneTimeCode
        
        return field
        
    }
}



