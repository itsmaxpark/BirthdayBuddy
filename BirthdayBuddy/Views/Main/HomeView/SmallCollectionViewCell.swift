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
        view.backgroundColor = .clear
        return view
    }()
    private let pictureView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "person.crop.circle.fill")

        return imageView
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25.0)
        return label
    }()
    private let birthdayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20.0)
        return label
    }()
    private let daysUntilBirthdayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20.0)
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
            width: nameLabel.intrinsicContentSize.width,
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
        // Need to reset SubLayer or else layers are used twice
        for sublayer in self.layer.sublayers! {
            if let _ = sublayer as? CAGradientLayer { // Check only gradient layers
                sublayer.removeFromSuperlayer()
           }
        }
    }
    
    func configure(person: Person) {
        
        guard
            let firstName = person.firstName,
            let lastName = person.lastName,
            let birthday = person.birthday
        else {
            return
        }
        nameLabel.text = firstName+" "+lastName
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        birthdayLabel.text = formatter.string(from: birthday)
        
//        let nextBirthday = getNextBirthday(date: birthday)
//        let daysLeft = Calendar.current.numberOfDaysBetween(Date(), and: nextBirthday)
//        person.daysLeft = Int64(daysLeft)
        
        daysUntilBirthdayLabel.text = "\(person.daysLeft) \(person.daysLeft != 1 ? "days" : "day")"
    }
    
//    func getNextBirthday(date: Date) -> Date {
//        // Get current date
//        let currentDate = Calendar.current.dateComponents([.day, .month, .year], from: Date())
//        // get birthday date
//        var birthday = Calendar.current.dateComponents([.day,.month,.year], from: date)
//        // set birthday year to current year
//        birthday.year = currentDate.year
//        // if birthday already happened this year, add 1 to year
//        let numberOfDays = Calendar.current.dateComponents([.day], from: currentDate, to: birthday).day!
//        if numberOfDays < 0 {
//            birthday.year! += 1
//        }
//
//        let nextBirthday = Calendar.current.date(from: birthday)
//
//        return nextBirthday!
//
//    }
}
