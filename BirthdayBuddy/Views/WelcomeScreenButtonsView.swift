//
//  WelcomeScreenButtonsView.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/8/22.
//

import UIKit
import AuthenticationServices
import FirebaseAuth

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
        performSignIn()
    }
    
//    private var presentingViewController: UIViewController?
    
    func performSignIn() {
        let request = createAppleIDRequest()
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        
        authorizationController.performRequests()
        print("performing requests")
    }
    
    func createAppleIDRequest() -> ASAuthorizationAppleIDRequest {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request  = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        currentNonce = nonce
        print("Nonce \(currentNonce!)")
        
        return request
        
    }
}

fileprivate var currentNonce: String?

extension WelcomeScreenButtonsView: ASAuthorizationControllerDelegate {
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
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid State: A login callback was received, but no login request was sent")
            }
            guard let appleIDtoken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDtoken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDtoken.debugDescription)")
                return
            }
            print("Creating credentials")
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            Auth.auth().signIn(with: credential) { authDataResult, error in
                if let user = authDataResult?.user {
                    print("Awesome! You are signed in as \(user.uid) using \(user.email ?? "Unknown Email")")
                }
                AppleUserAuth.login()
            }
        }
    }
}

extension WelcomeScreenButtonsView: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        print("Inside presentation anchor")
        return window!
    }
}


// Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: [Character] =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length
    
    while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
            var random: UInt8 = 0
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if errorCode != errSecSuccess {
                fatalError(
                    "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                )
            }
            return random
        }
        
        randoms.forEach { random in
            if remainingLength == 0 {
                return
            }
            
            if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
            }
        }
    }
    return result
}

import CryptoKit

private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
    }.joined()
    
    return hashString
}



