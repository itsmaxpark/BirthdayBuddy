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
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25.0)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let birthdayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let daysUntilBirthdayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
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
        let pictureViewConstraints = [
            pictureView.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            pictureView.heightAnchor.constraint(equalTo: cellView.heightAnchor, constant: -10),
            pictureView.widthAnchor.constraint(equalTo: cellView.heightAnchor, constant: -10),
            pictureView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 5)
        ]
        NSLayoutConstraint.activate(pictureViewConstraints)
        
        let nameLabelConstraints = [
            nameLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 10),
            nameLabel.bottomAnchor.constraint(equalTo: birthdayLabel.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: pictureView.trailingAnchor, constant: 10),
            nameLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 300)
        ]
        NSLayoutConstraint.activate(nameLabelConstraints)
        
        let birthdayLabelConstraints = [
            birthdayLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            birthdayLabel.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -10),
            birthdayLabel.leadingAnchor.constraint(equalTo: pictureView.trailingAnchor, constant: 10)
        ]
        NSLayoutConstraint.activate(birthdayLabelConstraints)
        
        let daysUntilBirthdayLabelConstraints = [
            daysUntilBirthdayLabel.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -10),
            daysUntilBirthdayLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -10),
            daysUntilBirthdayLabel.leadingAnchor.constraint(equalTo: birthdayLabel.trailingAnchor, constant: 10),
        ]
        NSLayoutConstraint.activate(daysUntilBirthdayLabelConstraints)
        
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
