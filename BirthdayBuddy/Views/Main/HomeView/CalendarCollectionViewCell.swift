//
//  CalendarCollectionViewCell.swift
//  BirthdayBuddy
//
//  Created by Max Park on 4/10/22.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CalendarCollectionViewCell"
    
    var isActive: Bool = false
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        backgroundColor = .label
        contentView.layer.borderColor = UIColor.label.cgColor
        contentView.layer.borderWidth = CGFloat(2)
        contentView.layer.cornerRadius = 10
        contentView.layer.backgroundColor = UIColor.systemGray5.cgColor
        contentView.addSubview(dateLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dateLabel.frame = contentView.frame
    }
    
    func configure(with date: CalendarDay, with index: Int) {
        if isActive {
            contentView.layer.backgroundColor = UIColor.clear.cgColor
            dateLabel.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize+5)
        } else {
            contentView.layer.backgroundColor = UIColor.systemGray5.cgColor
            dateLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        }
        if date.isWithinDisplayedMonth {
            self.contentView.isHidden = false
        } else {
            self.contentView.isHidden = true
        }
        if Calendar.current.isDateInToday(date.date) {
            dateLabel.textColor = .systemRed
            contentView.layer.borderColor = UIColor.systemRed.cgColor
        } else {
            dateLabel.textColor = .label
            contentView.layer.borderColor = .none
            contentView.layer.borderColor = UIColor.label.cgColor
        }
        dateLabel.text = date.number
        self.backgroundColor =  UIColor(
            red: 0,
            green: 0.8-CGFloat(index)/12*(0.6),
            blue: 1,
            alpha: 1
        )
    }
}
