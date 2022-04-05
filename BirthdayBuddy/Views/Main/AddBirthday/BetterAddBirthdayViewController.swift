//
//  BetterAddBirthdayViewController.swift
//  BirthdayBuddy
//
//  Created by Max Park on 4/5/22.
//

import UIKit

class BetterAddBirthdayViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))

        // Do any additional setup after loading the view.
    }
    
    @objc func didTapDone() {
        
    }
    @objc func didTapCancel() {
        // Dismisses the bottomSheet view controller with BetterAddBirthdayVC
        self.presentingViewController?.presentingViewController?.dismiss(animated: true)
        
    }
}
