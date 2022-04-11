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
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: UIFont.systemFontSize+5)
        label.textAlignment = .center
        label.layer.borderWidth = 2
        label.layer.cornerRadius = 10
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.borderWidth = CGFloat(2)
        contentView.layer.cornerRadius = 10
        contentView.layer.backgroundColor = UIColor.white.cgColor
        contentView.addSubview(dateLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dateLabel.frame = CGRect(
            x: 8,
            y: 2,
            width: contentView.width-16,
            height: contentView.height-4
        )
    }
    
    func configure(with date: CalendarDay, with index: Int) {
        // Reset to Default Cell
        dateLabel.layer.backgroundColor = UIColor.white.cgColor
        dateLabel.textColor = .black
        dateLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        dateLabel.text = date.number
        dateLabel.layer.borderColor = UIColor.white.cgColor
        self.contentView.isHidden = false
        
        if !date.isWithinDisplayedMonth {
            dateLabel.textColor = .lightGray
        } else {
            if isActive { // Current cell is a birthday
                dateLabel.layer.backgroundColor = UIColor(named: "Light Blue")?.cgColor
            }
            if Calendar.current.isDateInToday(date.date) { // Current cell is today's date
                dateLabel.layer.borderColor = UIColor.systemRed.cgColor
            }
        }
    }
}