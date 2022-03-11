//
//  WelcomeViewController.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/7/22.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private let backgroundView = WelcomeScreenBackgroundView()
    private let buttonsView = WelcomeScreenButtonsView()
    
//    static let shared = WelcomeViewController()
    
//    private let appleLoginAuth = AppleUserAuth()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(backgroundView)
        view.addSubview(buttonsView)
        
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backgroundView.frame = view.bounds
        buttonsView.frame = view.bounds
        
        
        
    }
}


