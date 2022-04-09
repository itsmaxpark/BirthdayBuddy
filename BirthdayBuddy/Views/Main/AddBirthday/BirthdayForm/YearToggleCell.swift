//
//  YearToggleCell.swift
//  BirthdayBuddy
//
//  Created by Max Park on 4/7/22.
//

import UIKit

protocol YearToggleCellDelegate: AnyObject {
    func switchChanged(cell: YearToggleCell)
}

class YearToggleCell: UITableViewCell {

    static let identifier = "YearToggleCell"
    
    weak var delegate: YearToggleCellDelegate?
    
    private let cellTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Show Year"
        label.textColor = .label
        return label
    }()
    
    private let iconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "calendar")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let switchView: UISwitch = {
        let switchView = UISwitch(frame: .zero)
        switchView.setOn(false, animated: true)
        switchView.backgroundColor = .systemBackground
        return switchView
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
}
