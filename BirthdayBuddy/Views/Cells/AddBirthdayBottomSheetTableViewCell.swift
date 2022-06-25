//
//  AddBirthdayBottomSheetTableViewCell.swift
//  BirthdayBuddy
//
//  Created by Max Park on 4/4/22.
//

import UIKit

class AddBirthdayBottomSheetTableViewCell: UITableViewCell {
    
    static let identifier = "AddBirthdayBottomSheetTableViewCell"
    
    private let cellTextLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let iconView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(cellTextLabel)
        contentView.addSubview(iconView)
        contentView.backgroundColor = .systemBackground
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
            width: contentView.width,
            height: 80
        )
        
    }
    
    func configure(viewModel: BottomSheetCellViewModel) {
        cellTextLabel.text = viewModel.text
        cellTextLabel.textColor = viewModel.textColor
        cellTextLabel.font = UIFont.systemFont(ofSize: viewModel.fontSize)
        iconView.image = viewModel.image
    }
    
}
