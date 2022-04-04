//
//  PersonTableViewCell.swift
//  BirthdayBuddy
//
//  Created by Max Park on 4/3/22.
//

import UIKit

class PersonTableViewCell: UITableViewCell {
    
    static let identifier = "PersonTableViewCell"
    
    private let cellView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = .white
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
        label.text = "Max Park"
        label.font = UIFont.systemFont(ofSize: 25.0)
        return label
    }()
    private let birthdayLabel: UILabel = {
        let label = UILabel()
        label.text = "7/23/1999"
        label.font = UIFont.systemFont(ofSize: 20.0)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(cellView)
        cellView.addSubview(pictureView)
        cellView.addSubview(nameLabel)
        cellView.addSubview(birthdayLabel)
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
            height: 70
        )
        
        pictureView.frame = CGRect(
            x: cellView.left+5,
            y: cellView.top+5,
            width: 60,
            height: 60
        )
        
        nameLabel.frame = CGRect(
            x: pictureView.right+5,
            y: 5,
            width: nameLabel.intrinsicContentSize.width,
            height: nameLabel.intrinsicContentSize.height
        )
        
        birthdayLabel.frame = CGRect(
            x: nameLabel.left,
            y: nameLabel.bottom,
            width: birthdayLabel.intrinsicContentSize.width,
            height: birthdayLabel.intrinsicContentSize.height
        )
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
        formatter.dateFormat = "MM/dd/yyyy"
        birthdayLabel.text = formatter.string(from: birthday)
    }
}
