//
//  LargeCollectionViewCell.swift
//  BirthdayBuddy
//
//  Created by Max Park on 4/3/22.
//

import UIKit

class LargeCollectionViewCell: UICollectionViewCell {
    static let identifier = "LargeCollectionViewCell"
    
    private let monthLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.appFont(name: "IndieFlower", size: 50)
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
        contentView.layer.cornerRadius = 20
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
            width: contentView.width-40,
            height: contentView.height-monthLabel.height-60
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
        self.contentView.backgroundColor =  UIColor(
            red: 0,
            green: CGFloat(viewModel.id)/12,
            blue: 1,
            alpha: 1
        )
    }
}
