//
//  LogInSheetViewController.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/10/22.
//

import UIKit

class LogInSheetViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true

        return scrollView
    }()
    
    private let birthdayBuddyTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 44)
        label.text = "Birthday Buddy"
        label.textColor = UIColor.white
        
        return label
    }()
    
    private let emailTextField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor(red: 0.293, green: 0.125, blue: 0.961, alpha: 0.71).cgColor
        field.placeholder = "Email Address"
        
        return field
    }()
    
    private let passwordTextField: UITextField = {
        let field = UITextField()
        
        return field
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "BirthdayBuddyLogoTransparent")

        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(birthdayBuddyTextLabel)
        scrollView.addSubview(logoImageView)
        scrollView.addSubview(emailTextField)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let logoSize: CGFloat = 260
        
        scrollView.frame = view.bounds
        
        birthdayBuddyTextLabel.frame = CGRect(
            x: (scrollView.width-birthdayBuddyTextLabel.intrinsicContentSize.width)/2,
            y: 20,
            width: birthdayBuddyTextLabel.intrinsicContentSize.width,
            height: birthdayBuddyTextLabel.intrinsicContentSize.height
        )
        
        logoImageView.frame = CGRect(
            x: (scrollView.width-logoSize)/2,
            y: birthdayBuddyTextLabel.bottom + 10,
            width: logoSize,
            height: logoSize
        )
        
        emailTextField.frame = CGRect(x: 30, y: logoImageView.bottom + 10, width: scrollView.width/2, height: 52)
    }

}
