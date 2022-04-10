//
//  LargeCollectionViewCell.swift
//  BirthdayBuddy
//
//  Created by Max Park on 4/3/22.
//

import UIKit

class SmallCollectionViewCell: UICollectionViewCell {
    static let identifier = "SmallCollectionViewCell"
    
    private let cellView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        return view
    }()
    private let pictureView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        return imageView
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25.0)
        return label
    }()
    private let birthdayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20.0)
        return label
    }()
    private let daysUntilBirthdayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 20.0)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(cellView)
        cellView.addSubview(pictureView)
        cellView.addSubview(nameLabel)
        cellView.addSubview(birthdayLabel)
        cellView.addSubview(daysUntilBirthdayLabel)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cellView.frame = CGRect(
            x: 0,
            y: 0,
            width: contentView.bounds.width,
            height: contentView.bounds.height
        )
        pictureView.frame = CGRect(
            x: cellView.left+10,
            y: (cellView.height-60)/2,
            width: 60,
            height: 60
        )
        nameLabel.frame = CGRect(
            x: pictureView.right+10,
            y: 10,
            width: 200,
            height: nameLabel.intrinsicContentSize.height
        )
        birthdayLabel.frame = CGRect(
            x: nameLabel.left,
            y: nameLabel.bottom,
            width: birthdayLabel.intrinsicContentSize.width,
            height: birthdayLabel.intrinsicContentSize.height
        )
        daysUntilBirthdayLabel.frame = CGRect(
            x: cellView.right-daysUntilBirthdayLabel.intrinsicContentSize.width-20,
            y: (cellView.height-daysUntilBirthdayLabel.intrinsicContentSize.height)/2,
            width: daysUntilBirthdayLabel.intrinsicContentSize.width,
            height: daysUntilBirthdayLabel.intrinsicContentSize.height
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        birthdayLabel.text = nil
        daysUntilBirthdayLabel.text = nil
        pictureView.image = UIImage(systemName: "person.crop.circle.fill")
        cellView.backgroundColor = .blue
    }
    
    func configure(person: Person) {
        guard
            let firstName = person.firstName,
//            let lastName = person.lastName,
            let birthday = person.birthday
        else {
            return
        }
        nameLabel.text = "\(firstName) \(person.lastName ?? "")"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        
        birthdayLabel.text = formatter.string(from: birthday)
        
        daysUntilBirthdayLabel.text = "\(person.daysLeft) \(person.daysLeft != 1 ? "days" : "day")"
        
        cellView.backgroundColor = UIColor(red: 0, green: 0.8-(CGFloat(person.daysLeft)/365*(0.6)), blue: 1, alpha: 1)
        guard let data = person.picture else {
            pictureView.image = UIImage(systemName: "person.crop.circle.fill")
            return
        }
        
        pictureView.image = UIImage(data: data)
    }
    
    func configureReuse() {
        nameLabel.text = nil
        birthdayLabel.text = nil
        daysUntilBirthdayLabel.text = nil
        pictureView.image = UIImage(systemName: "person.crop.circle.fill")
        cellView.backgroundColor = .blue
    }
}
