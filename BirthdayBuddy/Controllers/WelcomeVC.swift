//
//  WelcomeViewController.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/7/22.
//

import UIKit
import FirebaseAuth

class WelcomeVC: UIViewController {
    
    static var isLoggedIn: Bool = false
    
    private let backgroundView = WelcomeScreenBackgroundView()
    private let buttonsView = WelcomeScreenButtonsView()
    private let scrollView = UIScrollView()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
    }
    
    private func configureVC() {
        view.backgroundColor = .white
        hideKeyboardWhenTappedAround()
        
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundView)
        scrollView.addSubview(buttonsView)
        
        scrollView.frame = view.bounds
        backgroundView.frame = scrollView.bounds
        buttonsView.frame = scrollView.bounds
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    public static func login() {
        WelcomeVC.presentTabBarVC()
        WelcomeVC.isLoggedIn = true
    }
    
    private static func presentTabBarVC() {
        print("Presenting Tab Bar VC after successful login")
        let vc = TabBarVC()
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc, animated: true)
        
    }
    
    // MARK: - Selectors
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        self.view.frame.origin.y = -keyboardSize.height
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
}





