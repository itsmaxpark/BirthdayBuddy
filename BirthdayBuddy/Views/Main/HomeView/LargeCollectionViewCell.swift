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
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont.appFont(name: "IndieFlower", size: 50)
        return label
    }()
    private let previewView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        return view
    }()
    private let numberOfBirthdaysLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(name: "IndieFlower", size: 30)
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(monthLabel)
        contentView.addSubview(previewView)
        contentView.layer.cornerRadius = 20
        
        previewView.addSubview(numberOfBirthdaysLabel)
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
            x: 10,
            y: monthLabel.frame.maxY + 10,
            width: contentView.width-20,
            height: contentView.height-monthLabel.height-40
        )
        numberOfBirthdaysLabel.frame = CGRect(
            x: 20,
            y: 5,
            width: previewView.width-40,
            height: 50
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    func configure(with viewModel: CollectionViewCellViewModel) {
        monthLabel.text = viewModel.name
//        let numOfBirthdays = CoreDataManager.shared.getBirthdaysForMonth(month: viewModel.id)
//        var numOfBirthdaysText = ""
//        switch numOfBirthdays {
//        case 0:
//            numOfBirthdaysText = "No birthdays this month"
//        case 1:
//            numOfBirthdaysText = "1 birthday this month"
//        default:
//            numOfBirthdaysText = "\(numOfBirthdays) birthdays this month"
//        }
//        numberOfBirthdaysLabel.text = numOfBirthdaysText
    }
    
    func setBackground(with index: Int) {
        self.contentView.backgroundColor =  UIColor(
            red: 0,
            green: 0.8-CGFloat(index)/12*(0.6),
            blue: 1,
            alpha: 1
        )
    }
}
