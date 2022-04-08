//
//  AddBirthdayTextFieldCell.swift
//  BirthdayBuddy
//
//  Created by Max Park on 4/7/22.
//

import UIKit

protocol TextFieldCellDelegate: AnyObject {
    func didTapTextField(textField: UITextField)
}

class AddBirthdayTextFieldCell: UITableViewCell, UITextFieldDelegate {

    static let identifier = "AddBirthdayTextFieldCell"
    
    var placeholder: String? {
        didSet {
            guard let item = placeholder else {
                return
            }
            textField.placeholder = item
        }
    }
    
    let textField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.textColor = .systemGray
        return field
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textField.delegate = self
        contentView.addSubview(textField)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        textField.frame = CGRect(
            x: 20,
            y: 0,
            width: contentView.width,
            height: contentView.height
        )
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        print(textField.text ?? "")
        return true
    }
    
    
}
