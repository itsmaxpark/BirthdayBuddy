//
//  SignOutCell.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/11/22.
//

import UIKit

class SignOutCell: UITableViewCell {
    
    private let signOutLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign Out"
        label.textColor = .red
        
        return label
        
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
