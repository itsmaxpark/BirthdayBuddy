//
//  WelcomeScreenButtonsView.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/8/22.
//

import UIKit
import AuthenticationServices

class WelcomeScreenButtonsView: UIView {
    
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(signUpButton)
        addSubview(signInAppleButton)
        addSubview(logInButton)
        
        signInAppleButton.addTarget(self, action: #selector(didTapAppleSignIn), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        signUpButton.frame = CGRect(
            x: (width-signUpButton.intrinsicContentSize.width)/2,
            y: height-330,
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
    
    @objc private func didTapAppleSignIn() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    
}

extension UIView: ASAuthorizationControllerDelegate {
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
        guard let error = error as? ASAuthorizationError else {
            return
        }
        
        switch error.code {
        case .canceled:
            print("Canceled")
        case .unknown:
            print("Unknown")
        case .invalidResponse:
            print("Invalid Respone")
        case .notHandled:
            print("Not handled")
        case .failed:
            print("Failed")
        case .notInteractive:
            print("Not interactive")
        @unknown default:
            print("Default")
        }
    }
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
        case let credentials as ASAuthorizationAppleIDCredential:
            let firstName = credentials.fullName?.givenName
            let lastName = credentials.fullName?.familyName
            let email = credentials.email
            
            
        default:
            fatalError()
        }
    }
}

extension UIView: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return window!
    }
    
    
}
