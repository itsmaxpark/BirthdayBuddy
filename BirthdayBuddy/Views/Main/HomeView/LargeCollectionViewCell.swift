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
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.appFont(name: "Rubik", size: 50)
        return label
    }()
    private let previewView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.tintColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    private let calendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: CalendarCollectionViewCell.identifier)
        return view
    }()
    private let sundayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.text = "SUN"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    private let mondayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.text = "MON"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    private let tuesdayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.text = "TUE"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    private let wednesdayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.text = "WED"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    private let thursdayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.text = "THU"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    private let fridayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.text = "FRI"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    private let satudayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.text = "SAT"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(monthLabel)
        contentView.addSubview(previewView)
        contentView.layer.cornerRadius = 20
        
        previewView.addSubview(calendarCollectionView)
        previewView.addSubview(sundayLabel)
        previewView.addSubview(mondayLabel)
        previewView.addSubview(tuesdayLabel)
        previewView.addSubview(wednesdayLabel)
        previewView.addSubview(thursdayLabel)
        previewView.addSubview(fridayLabel)
        previewView.addSubview(satudayLabel)
        
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        monthLabel.frame = CGRect(
            x: (contentView.width/2) - (monthLabel.intrinsicContentSize.width/2),
            y: 10,
            width: monthLabel.intrinsicContentSize.width,
            height: monthLabel.intrinsicContentSize.height
        )
        previewView.frame = CGRect(
            x: 10,
            y: monthLabel.frame.maxY + 10,
            width: contentView.width-20,
            height: contentView.height-monthLabel.height-30
        )
        calendarCollectionView.frame = CGRect(
            x: 0,
            y: 20,
            width: previewView.width,
            height: previewView.height-20
        )
        sundayLabel.frame = CGRect(
            x: 0,
            y: 0,
            width: previewView.width/7,
            height: 20
        )
        mondayLabel.frame = CGRect(
            x: sundayLabel.right,
            y: 0,
            width: previewView.width/7,
            height: 20
        )
        tuesdayLabel.frame = CGRect(
            x: mondayLabel.right,
            y: 0,
            width: previewView.width/7,
            height: 20
        )
        wednesdayLabel.frame = CGRect(
            x: tuesdayLabel.right,
            y: 0,
            width: previewView.width/7,
            height: 20
        )
        thursdayLabel.frame = CGRect(
            x: wednesdayLabel.right,
            y: 0,
            width: previewView.width/7,
            height: 20
        )
        fridayLabel.frame = CGRect(
            x: thursdayLabel.right,
            y: 0,
            width: previewView.width/7,
            height: 20
        )
        satudayLabel.frame = CGRect(
            x: fridayLabel.right,
            y: 0,
            width: previewView.width/7,
            height: 20
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    func configure(with viewModel: CollectionViewCellViewModel) {
        monthLabel.text = viewModel.name
        self.contentView.backgroundColor = UIColor(named: "Light Blue")
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
