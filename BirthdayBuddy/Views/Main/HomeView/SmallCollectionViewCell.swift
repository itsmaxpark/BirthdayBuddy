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
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    private let infoView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 0
        return view
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25.0)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .black
        return label
    }()
    private let birthdayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.textColor = .darkGray
        return label
    }()
    private let daysUntilBirthdayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.textColor = .darkGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(cellView)
        cellView.addSubview(pictureView)
        cellView.addSubview(infoView)
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
        infoView.frame = CGRect(
            x: pictureView.right+5,
            y: 5,
            width: contentView.width-pictureView.width-20,
            height: contentView.height-10
        )
        nameLabel.frame = CGRect(
            x: pictureView.right+10,
            y: 10,
            width: cellView.width-pictureView.right-40 ,
            height: nameLabel.intrinsicContentSize.height
        )
        birthdayLabel.frame = CGRect(
            x: nameLabel.left,
            y: nameLabel.bottom,
            width: birthdayLabel.intrinsicContentSize.width,
            height: birthdayLabel.intrinsicContentSize.height
        )
        daysUntilBirthdayLabel.frame = CGRect(
            x: cellView.right-daysUntilBirthdayLabel.intrinsicContentSize.width-10,
            y: birthdayLabel.top,
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
    func getNextBirthday(date: Date) -> Date {
        // Get current date
        let currentDate = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        // get birthday date
        var birthday = Calendar.current.dateComponents([.day,.month,.year], from: date)
        // set birthday year to current year
        birthday.year = currentDate.year
        // if birthday already happened this year, add 1 to year
        let numberOfDays = Calendar.current.dateComponents([.day], from: currentDate, to: birthday).day!
        if numberOfDays < 0 {
            birthday.year! += 1
        }
        let nextBirthday = Calendar.current.date(from: birthday)
        return nextBirthday!
    }
    func configure(person: Person) {
        
        cellView.backgroundColor = UIColor(named: "Light Blue")
        infoView.backgroundColor = .clear
        infoView.layer.cornerRadius = 20
        
        guard
            let firstName = person.firstName,
            let birthday = person.birthday
        else {
            return
        }
        nameLabel.text = "\(firstName) \(person.lastName ?? "")"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        birthdayLabel.text = formatter.string(from: birthday)
        
        let nextBirthday = getNextBirthday(date: person.birthday!)
        let daysLeft = Calendar.current.numberOfDaysBetween(Date(), and: nextBirthday)
        daysUntilBirthdayLabel.text = configureDaysLeftText(daysLeft: daysLeft)
        
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
    func configureDaysLeftText(daysLeft: Int) -> String {
        switch daysLeft {
        case 0:
            return "🎂 Today"
        case 1:
            return "🎉 Tomorrow"
        default:
            return "\(daysLeft) days"
        }
    }
}
