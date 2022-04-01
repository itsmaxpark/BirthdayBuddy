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
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(monthLabel)
        // Shadow Layer
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
