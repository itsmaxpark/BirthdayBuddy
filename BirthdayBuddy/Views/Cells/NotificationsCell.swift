//
//  NotificationsCell.swift
//  BirthdayBuddy
//
//  Created by Max Park on 4/11/22.
//

import UIKit

protocol NotificationsCellDelegate: AnyObject {
    func switchChanged(cell: NotificationsCell)
}

class NotificationsCell: UITableViewCell {

    static let identifier = "NotificationsCell"
    
    weak var delegate: NotificationsCellDelegate?
    
    private let cellTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Notifications"
        label.textColor = .label
        return label
    }()
    
    private let iconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "bell.fill")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let switchView: UISwitch = {
        let toggle = UISwitch(frame: .zero)
        toggle.setOn(false, animated: true)
        toggle.backgroundColor = .systemBackground
        toggle.isOn = true
        return toggle
    }()
    
    public var isOn: Bool = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(cellTextLabel)
        contentView.addSubview(iconView)
        contentView.backgroundColor = .systemBackground
        self.backgroundColor = .systemBackground
        self.selectionStyle = .none
        
        switchView.addTarget(self, action: #selector(toggleSwitch), for: .valueChanged)
        self.accessoryView = switchView
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconView.frame = CGRect(
            x: 20,
            y: 10,
            width: contentView.height/2,
            height: contentView.height/2
        )
        
        cellTextLabel.frame = CGRect(
            x: iconView.right + 20,
            y: contentView.center.y-40,
            width: contentView.width,
            height: 80
        )
    }
    
    @objc func toggleSwitch() {
        delegate?.switchChanged(cell: self)
    }
    
    func configure(_ hasNotifications: Bool) {
        switchView.isOn = hasNotifications
    }
}
