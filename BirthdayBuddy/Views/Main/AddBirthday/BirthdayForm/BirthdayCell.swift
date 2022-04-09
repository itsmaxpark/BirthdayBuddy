//
//  BirthdayCell.swift
//  BirthdayBuddy
//
//  Created by Max Park on 4/7/22.
//

import UIKit

class BirthdayCell: UITableViewCell {

    static let identifier = "BirthdayCell"
    
    private let iconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "gift.fill")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let cellTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Birthday"
        label.textColor = .label
        return label
    }()
    
    private let dateTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(cellTextLabel)
        contentView.addSubview(iconView)
        contentView.addSubview(dateTextLabel)
        contentView.backgroundColor = .systemBackground
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconView.frame = CGRect(
            x: 20,
            y: 10,
            width: contentView.height/2,
            height: contentView.height/2
        )
        
        cellTextLabel.frame = CGRect(
            x: iconView.right + 20,
            y: contentView.center.y-40,
            width: contentView.width-120,
            height: 80
        )
        
        dateTextLabel.frame = CGRect(
            x: cellTextLabel.right+40-dateTextLabel.intrinsicContentSize.width,
            y: contentView.center.y-40,
            width: 120,
            height: 80
        )
    }
    
    func configure(date: String) {
        dateTextLabel.text = date
    }
}
