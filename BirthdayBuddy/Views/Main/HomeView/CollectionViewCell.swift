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
        label.font = UIFont.appFont(name: "IndieFlower", size: 40)
        return label
    }()
    
    private let previewView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.opacity = 0.7
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(monthLabel)
        contentView.addSubview(previewView)
        // Shadow Layer
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        monthLabel.frame = CGRect(
            x: (contentView.width/2) - (monthLabel.intrinsicContentSize.width/2),
            y: 20,
            width: monthLabel.intrinsicContentSize.width,
            height: monthLabel.intrinsicContentSize.height
        )
        previewView.frame = CGRect(
            x: 20,
            y: monthLabel.frame.maxY + 20,
            width: 180,
            height: 180
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Need to reset SubLayer or else layers are used twice
        for sublayer in self.layer.sublayers! {
            if let _ = sublayer as? CAGradientLayer { // Check only gradient layers
                sublayer.removeFromSuperlayer()
           }
        }
    }
    
    func configure(with viewModel: CollectionViewCellViewModel) {
        monthLabel.text = viewModel.name
    }
}
