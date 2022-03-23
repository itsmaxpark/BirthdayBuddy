//
//  WelcomeViewController.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/7/22.
//

import UIKit
import FirebaseAuth

class WelcomeViewController: UIViewController {
    
    private let backgroundView = WelcomeScreenBackgroundView()
    private let buttonsView = WelcomeScreenButtonsView()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    static var isLoggedIn: Bool = false
    
    static func login() {
        presentTabBarVC()
        isLoggedIn = true
    }
    
    private var handle: AuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundView)
        scrollView.addSubview(buttonsView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        backgroundView.frame = scrollView.bounds
        buttonsView.frame = scrollView.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        handle = Auth.auth().addStateDidChangeListener({ auth, user in
//
//            let credential = auth.
//
//            auth.currentUser?.link(with: credential, completion: { linkResult, error in
//                print("FacebookSignInHelper: Linking providers")
//                guard let link = linkResult, error == nil else {
//                    print(error!)
//                    return
//                }
//                print("FacebookSignInHelper: link - \(link)")
//                print("FacebookSignInHelper: Providers successfully linked")
//            })
//        })
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           return
        }
      self.view.frame.origin.y = 0 - keyboardSize.height
    }

    @objc func keyboardWillHide(notification: NSNotification) {
      self.view.frame.origin.y = 0
    }
    
    private static func presentTabBarVC() {
        print("Presenting Tab Bar VC after successful login")
        let vc = TabBarViewController()
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc, animated: true)
    }
}

    

