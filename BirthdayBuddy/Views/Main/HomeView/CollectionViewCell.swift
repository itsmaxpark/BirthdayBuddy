//
//  CollectionViewCell.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/29/22.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    static let identifier = "CollectionViewCell"
    
    private let monthLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.appFont(name: "IndieFlower", size: 50)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(monthLabel)
        contentView.layer.cornerRadius = 20
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: -10, height: 10)
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOpacity = 0.4
        contentView.layer.masksToBounds = false
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        monthLabel.frame = CGRect(
            x: (contentView.width/2) - (monthLabel.intrinsicContentSize.width)/2,
            y: 0,
            width: monthLabel.intrinsicContentSize.width,
            height: monthLabel.intrinsicContentSize.height
        )
        
        
    }
    
    func configure(with viewModel: CollectionViewCellViewModel) {
        contentView.backgroundColor = viewModel.backgroundColor
        monthLabel.text = viewModel.name
    }
}
