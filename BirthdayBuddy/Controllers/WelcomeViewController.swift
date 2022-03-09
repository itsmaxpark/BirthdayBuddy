//
//  WelcomeViewController.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/7/22.
//

import UIKit
import AuthenticationServices

class WelcomeViewController: UIViewController {
    
    // MARK: - Buttons
    
    private let signUpButton: UIButton = {
        
        let button = UIButton()
        button.titleLabel?.font = UIFont.appFont(size: 36)
        button.setTitle("Sign Up", for: .normal)
        
        return button
    }()
    
    private let logInButton: UIButton = {
        
        let button = UIButton()
        button.titleLabel?.font = UIFont.appFont(size: 36)
        button.setTitle("Log In", for: .normal)
        
        return button
    }()
    
    private let signInAppleButton: UIButton = {
        
        var container = AttributeContainer()
        container.font = UIFont.boldSystemFont(ofSize: 19)
        
        var config = UIButton.Configuration.filled()
        config.attributedTitle = AttributedString("Continue with Apple", attributes: container)
        
        config.buttonSize = .large
        config.cornerStyle = .capsule
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .black
        
        config.image = UIImage(systemName: "applelogo")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 19)
        config.imagePadding = 20
        config.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 20, bottom: 2, trailing: 40)

        let button = UIButton(configuration: config, primaryAction: nil)
        
        return button
    }()
    
    // MARK: - View
    
    private let backgroundView = WelcomeScreenBackgroundView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(backgroundView)
        
        view.addSubview(signUpButton)
        view.addSubview(signInAppleButton)
        view.addSubview(logInButton)
        
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        
        let width = view.bounds.width
        let height = view.bounds.height
        
        backgroundView.frame = view.bounds

        // Buttons
        signUpButton.frame = CGRect(
            x: (width-signUpButton.intrinsicContentSize.width)/2,
            y: height-340,
            width: signUpButton.intrinsicContentSize.width,
            height: signUpButton.intrinsicContentSize.height
        )
        logInButton.frame = CGRect(
            x: (width-logInButton.intrinsicContentSize.width)/2,
            y: height-100,
            width: logInButton.intrinsicContentSize.width,
            height: logInButton.intrinsicContentSize.height
        )
        signInAppleButton.frame = CGRect(
            x: (width-300)/2,
            y: signUpButton.frame.maxY,
            width: 300,
            height: 44
        )
    }
}


