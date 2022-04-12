//
//  DeleteButtonCell.swift
//  BirthdayBuddy
//
//  Created by Max Park on 4/12/22.
//


import UIKit

protocol DeleteButtonCellDelegate: AnyObject {
    func didTapDelete(cell: DeleteButtonCell)
}

class DeleteButtonCell: UITableViewCell {

    static let identifier = "DeleteButtonCell"
    
    weak var delegate: DeleteButtonCellDelegate?
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete Birthday", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(deleteButton)
        contentView.backgroundColor = .systemBackground
        self.backgroundColor = .systemBackground
        
        deleteButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        deleteButton.frame = contentView.frame
    }
    
    @objc func didTapButton() {
        delegate?.didTapDelete(cell: self)
    }
}
