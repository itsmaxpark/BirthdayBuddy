//
//  WelcomeViewController.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/7/22.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    // MARK: - Background Views
    
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
        guard let font = UIFont(name: "IndieFlower", size: 44) else {
            fatalError("Unable to retrieve font")
        }
        label.font = font
        label.text = "Birthday Buddy"
        return label
    }()
    
    // MARK: - Buttons
    
    private let signUpButton: UIButton = {
        
        let button = UIButton()
        
        return button
    }()
    
    private let logInButton: UIButton = {
        
        let button = UIButton()
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.layer.addSublayer(topCircleView)
        view.layer.addSublayer(bottomCircleView)
        view.addSubview(logoImageView)
        view.addSubview(birthdayBuddyTextLabel)
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let width = Int(view.bounds.width)
        let height = Int(view.bounds.height)
        let circleDiameter = 800
        let logoSize = 260
        let topCircleHeight = 188 // 188 pixels of the top circle is showing
        let bottomCircleHeight = 344 // 344 pixels of the bottom circle is showing
        
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
            x: (width-300)/2,
            y: (topCircleHeight-Int(view.safeAreaInsets.top))/2,
            width: width,
            height: 100
        )

    }
}


