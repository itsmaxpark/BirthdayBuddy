//
//  SignOutCell.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/11/22.
//

import UIKit

class SignOutCell: UITableViewCell {
    
    static let identifier = "SignOutCell"
    
    private let signOutLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign Out"
        label.textColor = .white
        label.backgroundColor = .red
        
        return label
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .red
        contentView.addSubview(signOutLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        signOutLabel.frame = CGRect(
            x: 10,
            y: 5,
            width: signOutLabel.intrinsicContentSize.width,
            height: signOutLabel.intrinsicContentSize.height
        )
    }
}
