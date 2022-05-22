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
            UIColor(named: "Blue")?.cgColor as Any,
            UIColor(named: "Light Blue")?.cgColor as Any
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
            UIColor(named: "Light Blue")?.cgColor as Any,
            UIColor(named: "Blue")?.cgColor as Any
                ]
        gradient.mask = circle
        
        return gradient
    }()
    
    private let logoImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "BirthdayBuddyLogoTransparent")
//        ?.withTintColor(UIColor(named: "Light Blue") ?? UIColor.clear)

        return imageView
        
    }()
    
    private let birthdayBuddyTextLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.appFont(name: "IndieFlower", size: 44)
        label.text = "Birthday Buddy"
        label.textColor = UIColor.white
        
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
        let logoSize: CGFloat = height * 0.28
        let topCircleHeight: CGFloat = height * 0.2 // 188 pixels of the top circle is showing
        let bottomCircleHeight:CGFloat = height * 0.37 // 344 pixels of the bottom circle is showing
        
        // Background
        topCircleView.frame = CGRect(
            x: (width-circleDiameter)/2,
            y: topCircleHeight-circleDiameter,
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
            y: (topCircleHeight-birthdayBuddyTextLabel.intrinsicContentSize.height)/2,
            width: birthdayBuddyTextLabel.intrinsicContentSize.width,
            height: birthdayBuddyTextLabel.intrinsicContentSize.height
        )
    }
}
