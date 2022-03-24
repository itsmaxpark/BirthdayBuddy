//
//  WelcomeScreenButtonsView.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/8/22.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import FBSDKCoreKit


class WelcomeScreenButtonsView: UIView {
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.appFont(name: "IndieFlower", size: 36)
        button.setTitle("Sign Up", for: .normal)
        return button
    }()
    private let logInButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.appFont(name: "IndieFlower", size: 36)
        button.setTitle("Log In", for: .normal)
        return button
    }()
    private let signInAppleButton: UIButton = {
        let text = "Continue with Apple"
        let image = UIImage(systemName: "applelogo")
        let insets = NSDirectionalEdgeInsets(top: 2, leading: 20, bottom: 2, trailing: 40)
        let font = UIFont.boldSystemFont(ofSize: 19)
        let config = CustomDesigns.shared.createCustomButtonConfig(text: text, font: font, image: image ?? UIImage(), insets: insets)
        let button = UIButton(configuration: config, primaryAction: nil)
        return button
    }()
    private let signInGoogleButton: UIButton = {
        let text = "Continue with Google"
        let image = UIImage(named: "googleLogo")?.resizeImageTo(size: CGSize(width: 22, height: 22))
        let insets = NSDirectionalEdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 20)
//        let font = UIFont.appFont(name: "Roboto-Medium", size: 19)
        let font = UIFont.boldSystemFont(ofSize: 19)
        let config = CustomDesigns.shared.createCustomButtonConfig(text: text, font: font, image: image ?? UIImage(), insets: insets)
        let button = UIButton(configuration: config, primaryAction: nil)
        return button
    }()
    private let signInFacebookButton: UIButton = {
        let text = "Continue with Facebook"
        let image = UIImage(named: "facebookLogo")?.resizeImageTo(size: CGSize(width: 24, height: 24))
        let insets = NSDirectionalEdgeInsets(top: 2, leading: 20, bottom: 2, trailing: 10)
        let font = UIFont.boldSystemFont(ofSize: 19)
        let config = CustomDesigns.shared.createCustomButtonConfig(text: text, font: font, image: image ?? UIImage(), insets: insets)
        let button = UIButton(configuration: config, primaryAction: nil)
        return button
    }()
    
    // MARK: - Log In Pressed
    
    private let returnButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.appFont(name: "IndieFlower", size: 36)
        button.setTitle("Return", for: .normal)
        return button
    }()
    private let emailTextField: UITextField = {
        return CustomDesigns.shared.createCustomTextField(
            previewText: "Email Address",
            isSecure: false
        )
    }()
    private let passwordTextField: UITextField = {
        return CustomDesigns.shared.createCustomTextField(
            previewText: "Password",
            isSecure: true
        )
    }()
    private let enterButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.appFont(name: "IndieFlower", size: 36)
        button.setTitle("Enter", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    // MARK: - Sign Up Pressed
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.appFont(name: "IndieFlower", size: 36)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    private let firstNameField: UITextField = {
        return CustomDesigns.shared.createCustomTextField(
            previewText: "First Name",
            isSecure: false
        )
    }()
    private let lastNameField: UITextField = {
        return CustomDesigns.shared.createCustomTextField(
            previewText: "Last Name",
            isSecure: false
        )
    }()
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.appFont(name: "IndieFlower", size: 36)
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private var firstName = String()
    private var lastName = String()
    
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
        firstNameField.isHidden = true
        lastNameField.isHidden = true
        nextButton.isHidden = true
        
        addSubview(registerButton)
        addSubview(firstNameField)
        addSubview(lastNameField)
        addSubview(nextButton)

        registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        firstNameField.delegate = self
        lastNameField.delegate = self

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
        firstNameField.frame = CGRect(
            x: (width-300)/2,
            y: returnButton.bottom,
            width: 300,
            height: 44
        )
        lastNameField.frame = CGRect(
            x: (width-300)/2,
            y: emailTextField.bottom+10,
            width: 300,
            height: 44
        )
        nextButton.frame = CGRect(
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
        
        returnButton.isHidden = false
        
        firstNameField.isHidden = false
        lastNameField.isHidden = false
        nextButton.isHidden = false
        
    }
    @objc private func didTapAppleSignIn() {
        AppleSignInHelper.shared.performSignIn(with: self)
    }
    @objc private func didTapGoogleSignIn() {
        GoogleSignInHelper.shared.performSignIn(with: self)
    }
    @objc private func didTapFacebookSignIn() {
        FacebookSignInHelper.shared.performSignIn(with: self)
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
        firstNameField.isHidden = true
        lastNameField.isHidden = true
        nextButton.isHidden = true
        
        signUpButton.isHidden = false
        signInAppleButton.isHidden = false
        signInGoogleButton.isHidden = false
        signInFacebookButton.isHidden = false
        logInButton.isHidden = false
        
        emailTextField.text = ""
        passwordTextField.text = ""
        firstNameField.text = ""
        lastNameField.text = ""
    }
    @objc private func didTapEnter() {
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
        print("WelcomeScreenButtonsView: Calling emailsigninhelper")
        EmailSignInHelper.shared.performCreateUser(firstName: firstName, lastName: lastName, email: email, password: password, view: self) { [weak self] in
            print("WelcomeScreenButtonsView: completion handler")
            self?.didTapReturn()
            self?.alertUserRegistered()
        }
        // TODO: Fix alertUserRegistered's UIAlertController overriding the alertLinkProviders UIAlertController from EmailSignInHelper
    }
    
    @objc private func didTapNext() {
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        
        guard let first = firstNameField.text , let last = lastNameField.text else {
            return
        }
        guard !first.isEmpty else {
            alertFirstName()
            return
        }
        
        firstName = first
        lastName = last
        
        firstNameField.isHidden = true
        lastNameField.isHidden = true
        nextButton.isHidden = true
        
        emailTextField.isHidden = false
        passwordTextField.isHidden = false
        registerButton.isHidden = false
        
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
    func alertFirstName() {
        let alert = UIAlertController(title: "Whoops", message: "Please enter your first name", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        alert.view.layoutIfNeeded()
        let vc = findViewController()
        vc?.present(alert, animated: true)
    }
    func alertUserRegistered() {
        let alert = UIAlertController(title: "Awesome", message: "Your account was successfully created! Please log in to continue.", preferredStyle: .alert)
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
            if !enterButton.isHidden {
                didTapEnter()
            } else {
                didTapRegister()
            }
        }
        if textField == firstNameField {
            lastNameField.becomeFirstResponder()
        } else if textField == lastNameField {
            self.endEditing(true)
        }
        return true
    }
}

