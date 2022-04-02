//
//  CollectionViewCellDetailViewController.swift
//  BirthdayBuddy
//
//  Created by Max Park on 4/1/22.
//

import UIKit

class CollectionViewCellDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(backButtonPressed))
    }
    
    @objc func backButtonPressed() {
        print("Back button pressed")
        dismiss(animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}
