//
//  TextFieldCell.swift
//  BirthdayBuddy
//
//  Created by Max Park on 4/7/22.
//

import UIKit

protocol TextFieldCellDelegate: AnyObject {
    func didEditTextField(textField: UITextField)
}

class TextFieldCell: UITableViewCell, UITextFieldDelegate {

    static let identifier = "TextFieldCell"
    
    weak var delegate: TextFieldCellDelegate?
    
    var placeholder: String? {
        didSet {
            guard let item = placeholder else {
                return
            }
            textField.placeholder = item
        }
    }
    
    var text: String?
    
    let textField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.textColor = .systemGray
        field.isUserInteractionEnabled = false
        return field
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textField.delegate = self
        contentView.addSubview(textField)
        selectionStyle = .none
        addContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func addContraints() {
        var constraints = [NSLayoutConstraint]()
        // add
        constraints.append(textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20))
        constraints.append(textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor))
        constraints.append(textField.topAnchor.constraint(equalTo: contentView.topAnchor))
        constraints.append(textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor))
        //activate
        NSLayoutConstraint.activate(constraints)
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
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        textField.isUserInteractionEnabled = false
        self.delegate?.didEditTextField(textField: textField)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(with viewModel: TextFieldCellViewModel) {
        textField.placeholder = viewModel.placeholder
        textField.text = viewModel.text
    }
}
