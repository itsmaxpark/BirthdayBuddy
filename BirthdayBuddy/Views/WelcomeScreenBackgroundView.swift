//
//  WelcomeScreenBackgroundView.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/8/22.
//

import Foundation
import UIKit

class WelcomeScreenBackgroundView: UIView {
    
    private let topCircleView: CAGradientLayer = {
        
        let circleFrame = CGRect(x: 0, y: 0, width: 800, height: 800)
        
        let circle = CAShapeLayer()
        circle.frame = circleFrame
        circle.path = UIBezierPath(ovalIn: circleFrame).cgPath
        
        let gradient = CAGradientLayer()
        gradient.locations = [0.5, 1]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.colors = [
                  UIColor(red: 0.293, green: 0.125, blue: 0.961, alpha: 0.71).cgColor,
                  UIColor(red: 0.125, green: 0.863, blue: 0.961, alpha: 1).cgColor
                ]
        gradient.mask = circle
        
        return gradient
    }()
    
    private let bottomCircleView: CAGradientLayer = {
        
        let circleFrame = CGRect(x: 0, y: 0, width: 800, height: 800)
        
        let circle = CAShapeLayer()
        circle.frame = circleFrame
        circle.path = UIBezierPath(ovalIn: circleFrame).cgPath
        
        let gradient = CAGradientLayer()
        gradient.locations = [0, 0.7]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.colors = [
                UIColor(red: 0.125, green: 0.863, blue: 0.961, alpha: 1).cgColor,
                  UIColor(red: 0.293, green: 0.125, blue: 0.961, alpha: 0.71).cgColor,
                ]
        gradient.mask = circle
        
        return gradient
    }()
    
    private let logoImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "BirthdayBuddyLogoTransparent")

        return imageView
        
    }()
    
    private let birthdayBuddyTextLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.appFont(size: 44)
        label.text = "Birthday Buddy"
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(topCircleView)
        layer.addSublayer(bottomCircleView)
        addSubview(logoImageView)
        addSubview(birthdayBuddyTextLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let circleDiameter: CGFloat = 800
        let logoSize: CGFloat = 260
        let topCircleHeight: CGFloat = 188 // 188 pixels of the top circle is showing
        let bottomCircleHeight:CGFloat = 344 // 344 pixels of the bottom circle is showing
        
        // Background
        topCircleView.frame = CGRect(
            x: (width-circleDiameter)/2,
            y: -circleDiameter+topCircleHeight,
            width: circleDiameter,
            height: circleDiameter
        )
        bottomCircleView.frame = CGRect(
            x: (width-circleDiameter)/2,
            y: height-bottomCircleHeight,
            width: circleDiameter,
            height: circleDiameter
        )
        logoImageView.frame = CGRect(
            x: (width-logoSize)/2,
            y: topCircleHeight+(height-logoSize-topCircleHeight-bottomCircleHeight)/2,
            width: logoSize,
            height: logoSize
        )
        birthdayBuddyTextLabel.frame = CGRect(
            x: (width-birthdayBuddyTextLabel.intrinsicContentSize.width)/2,
            y: (topCircleHeight-safeAreaInsets.top)/2,
            width: birthdayBuddyTextLabel.intrinsicContentSize.width,
            height: birthdayBuddyTextLabel.intrinsicContentSize.height
        )
    }
}
