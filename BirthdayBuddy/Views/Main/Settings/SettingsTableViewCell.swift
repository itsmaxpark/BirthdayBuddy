//
//  SettingsTableViewCell.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/11/22.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    static let identifier = "SettingsTableViewCell"
    
    private let cellTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 20)
        return label
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(cellTextLabel)
        contentView.clipsToBounds = true
        self.accessoryType = .disclosureIndicator
        self.backgroundColor = .systemGray5
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        cellTextLabel.frame = CGRect(
            x: 20,
            y: 10,
            width: cellTextLabel.intrinsicContentSize.width,
            height: cellTextLabel.intrinsicContentSize.height
        )
    }
    
    func configure(viewModel: SettingsTableViewCellViewModel) {
        cellTextLabel.text = viewModel.text
        cellTextLabel.textColor = viewModel.color
    }
}
