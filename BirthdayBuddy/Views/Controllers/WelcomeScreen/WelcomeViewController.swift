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
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true

        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundView)
        scrollView.addSubview(buttonsView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        backgroundView.frame = scrollView.bounds
        buttonsView.frame = scrollView.bounds
    }
}
    

