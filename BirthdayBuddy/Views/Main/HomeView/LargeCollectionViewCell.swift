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
//        label.font = UIFont.appFont(name: "IndieFlower", size: 50)
        label.font = UIFont.appFont(name: "Rubik", size: 50)
        return label
    }()
    private let previewView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.clipsToBounds = true
//        view.layer.cornerRadius = 10
//        view.layer.borderColor = UIColor.label.cgColor
        return view
    }()
    private let numberOfBirthdaysLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(name: "IndieFlower", size: 30)
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    private let calendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: CalendarCollectionViewCell.identifier)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(monthLabel)
        contentView.addSubview(previewView)
        contentView.layer.cornerRadius = 20
        
        previewView.addSubview(calendarCollectionView)
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
//        numberOfBirthdaysLabel.frame = CGRect(
//            x: 20,
//            y: 5,
//            width: previewView.width-40,
//            height: 50
//        )
        calendarCollectionView.frame = CGRect(
            x: 0,
            y: 0,
            width: previewView.width,
            height: previewView.height
        )
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    func configure(with viewModel: CollectionViewCellViewModel) {
        monthLabel.text = viewModel.name.uppercased()
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

extension LargeCollectionViewCell {
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int) {
        calendarCollectionView.delegate = dataSourceDelegate
        calendarCollectionView.dataSource = dataSourceDelegate
        calendarCollectionView.tag = row
        calendarCollectionView.reloadData()
    }
}
