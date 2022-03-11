//
//  WelcomeScreenButtonsView.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/8/22.
//

import UIKit
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
    
    private let signInGoogleButton: UIButton = {
        
        var container = AttributeContainer()
        container.font = UIFont.boldSystemFont(ofSize: 19)
        
        var config = UIButton.Configuration.filled()
        config.attributedTitle = AttributedString("Continue with Google", attributes: container)
        
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
    
    private let signInFacebookButton: UIButton = {
        
        var container = AttributeContainer()
        container.font = UIFont.boldSystemFont(ofSize: 19)
        
        var config = UIButton.Configuration.filled()
        config.attributedTitle = AttributedString("Continue with Facebook", attributes: container)
        
        config.buttonSize = .large
        config.cornerStyle = .capsule
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .black
        
        config.image = UIImage(systemName: "applelogo")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 19)
        config.imagePadding = 20
        config.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 20, bottom: 2, trailing: 10)
        
        let button = UIButton(configuration: config, primaryAction: nil)
        
        return button
    }()
    
    // MARK: - Log In Pressed
    
    private let returnButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.appFont(size: 36)
        button.setTitle("Return", for: .normal)
        
        return button
    }()
    
    private let emailTextField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 20
        field.attributedPlaceholder = NSAttributedString(
            string: "Email Address",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 19)
            ]
        )
        field.textColor = .black
        field.backgroundColor = .white
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        field.leftViewMode = .always
        field.textContentType = .oneTimeCode
        
        return field
    }()
    
    private let passwordTextField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 20
        field.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 19)
            ]
        )
        field.textColor = .black
        field.backgroundColor = .white
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        field.leftViewMode = .always
        field.isSecureTextEntry = true
        field.textContentType = .oneTimeCode
    
        
        return field
    }()
    
    private let enterButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.appFont(size: 36)
        button.setTitle("Enter", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.appFont(size: 36)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    
    // MARK: - INIT
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(signUpButton)
        addSubview(signInAppleButton)
        addSubview(signInGoogleButton)
        addSubview(signInFacebookButton)
        addSubview(logInButton)
        
        signUpButton.addTarget(self, action: #selector(didTapEmailSignUp), for: .touchUpInside)
        signInAppleButton.addTarget(self, action: #selector(didTapAppleSignIn), for: .touchUpInside)
        signInGoogleButton.addTarget(self, action: #selector(didTapGoogleSignIn), for: .touchUpInside)
        signInFacebookButton.addTarget(self, action: #selector(didTapFacebookSignIn), for: .touchUpInside)
        logInButton.addTarget(self, action: #selector(didTapEmailLogIn), for: .touchUpInside)
        
        // Sign In
        returnButton.isHidden = true
        emailTextField.isHidden = true
        passwordTextField.isHidden = true
        enterButton.isHidden = true
        
        addSubview(returnButton)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(enterButton)
        
        returnButton.addTarget(self, action: #selector(didTapReturn), for: .touchUpInside)
        enterButton.addTarget(self, action: #selector(didTapEnter), for: .touchUpInside)
        
        // Sign Up
        registerButton.isHidden = true
        
        addSubview(registerButton)

        registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
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
        signInAppleButton.frame = CGRect(
            x: (width-300)/2,
            y: signUpButton.bottom,
            width: 300,
            height: 44
        )
        signInGoogleButton.frame = CGRect(
            x: (width-300)/2,
            y: signInAppleButton.bottom+10,
            width: 300,
            height: 44
        )
        signInFacebookButton.frame = CGRect(
            x: (width-300)/2,
            y: signInGoogleButton.bottom+10,
            width: 300,
            height: 44
        )
        logInButton.frame = CGRect(
            x: (width-logInButton.intrinsicContentSize.width)/2,
            y: height-100,
            width: logInButton.intrinsicContentSize.width,
            height: logInButton.intrinsicContentSize.height
        )
        
        returnButton.frame = CGRect(
            x: (width-returnButton.intrinsicContentSize.width)/2,
            y: height-330,
            width: returnButton.intrinsicContentSize.width,
            height: returnButton.intrinsicContentSize.height
        )
        emailTextField.frame = CGRect(
            x: (width-300)/2,
            y: returnButton.bottom,
            width: 300,
            height: 44
        )
        passwordTextField.frame = CGRect(
            x: (width-300)/2,
            y: emailTextField.bottom+10,
            width: 300,
            height: 44
        )
        enterButton.frame = CGRect(
            x: (width-enterButton.intrinsicContentSize.width)/2,
            y: height-100,
            width: enterButton.intrinsicContentSize.width,
            height: enterButton.intrinsicContentSize.height
        )
        
        registerButton.frame = CGRect(
            x: (width-registerButton.intrinsicContentSize.width)/2,
            y: height-100,
            width: registerButton.intrinsicContentSize.width,
            height: registerButton.intrinsicContentSize.height
        )
    }
    
    // MARK: - Selectors
    
    @objc private func didTapEmailSignUp() {
        
        signUpButton.isHidden = true
        signInAppleButton.isHidden = true
        signInGoogleButton.isHidden = true
        signInFacebookButton.isHidden = true
        logInButton.isHidden = true
        
        enterButton.isHidden = true
        
        returnButton.isHidden = false
        emailTextField.isHidden = false
        passwordTextField.isHidden = false
        registerButton.isHidden = false
        
    }
    @objc private func didTapAppleSignIn() {
        AppleSignInHelper.shared.performSignIn(with: self)
    }
    @objc private func didTapGoogleSignIn() {
        
    }
    @objc private func didTapFacebookSignIn() {
        
    }
    @objc private func didTapEmailLogIn() {
        signUpButton.isHidden = true
        signInAppleButton.isHidden = true
        signInGoogleButton.isHidden = true
        signInFacebookButton.isHidden = true
        logInButton.isHidden = true
        
        returnButton.isHidden = false
        emailTextField.isHidden = false
        passwordTextField.isHidden = false
        enterButton.isHidden = false
        
    }
    
    @objc private func didTapReturn() {
        returnButton.isHidden = true
        emailTextField.isHidden = true
        passwordTextField.isHidden = true
        enterButton.isHidden = true
        
        registerButton.isHidden = true
        
        signUpButton.isHidden = false
        signInAppleButton.isHidden = false
        signInGoogleButton.isHidden = false
        signInFacebookButton.isHidden = false
        logInButton.isHidden = false
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    @objc private func didTapEnter() {
        
        print("didTapEnter: Button pressed")
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        guard !email.isEmpty else {
            alertEmptyEmail()
            return
        }
        guard !password.isEmpty, password.count >= 6 else {
            alertPasswordLength()
            return
        }
        
        EmailSignInHelper.shared.performSignIn(email: email, password: password)
    }
    
    @objc private func didTapRegister() {
        print("didTapRegister: Button pressed")
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        guard !email.isEmpty else {
            alertEmptyEmail()
            return
        }
        guard !password.isEmpty, password.count >= 6 else {
            alertPasswordLength()
            return
        }
        
        EmailSignInHelper.shared.performCreateUser(email: email, password: password)
    }
    
    // MARK: Alerts
    
    func alertEmptyEmail() {
        let alert = UIAlertController(title: "Whoops", message: "Please enter an email address", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        alert.view.layoutIfNeeded()
        let vc = findViewController()
        vc?.present(alert, animated: true)
        
    }
    func alertPasswordLength() {
        let alert = UIAlertController(title: "Whoops", message: "Please enter a password. Password must be at least 6 characters", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        alert.view.layoutIfNeeded()
        let vc = findViewController()
        vc?.present(alert, animated: true)
    }
}

extension WelcomeScreenButtonsView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            didTapEnter()
        }
        return true
    }
}
