//
//  TabBarBackgroundView.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/8/22.
//

import Foundation
import UIKit

class TabBarBackgroundView: UIView {
    
    private let topCircleView: CAGradientLayer = {
        
        let circleFrame = CGRect(x: 0, y: 0, width: 800, height: 800)
        
        let circle = CAShapeLayer()
        circle.frame = circleFrame
        circle.path = UIBezierPath(ovalIn: circleFrame).cgPath
        
        let gradient = CAGradientLayer()
        gradient.locations = [0.5, 1]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.colors = [
            UIColor(named: "Blue")?.cgColor as Any,
            UIColor(named: "Light Blue")?.cgColor as Any
                ]
        gradient.mask = circle
        
        return gradient
    }()
    
    private let dateTextLabel: UILabel = {
        var date = Date.now
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        
        let label = UILabel()
        label.font = UIFont.appFont(name: "IndieFlower", size: 44)
        label.text = dateFormatter.string(from: date)
        label.textColor = UIColor.white
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(topCircleView)
        addSubview(dateTextLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let circleDiameter: CGFloat = 800
        let topCircleHeight: CGFloat = 100 // 150 pixels of the top circle is showing
        // Background
        topCircleView.frame = CGRect(
            x: -(circleDiameter-width)/2,
            y: topCircleHeight-circleDiameter,
            width: circleDiameter,
            height: circleDiameter
        )
        dateTextLabel.frame = CGRect(
            x: (width-dateTextLabel.intrinsicContentSize.width)/2,
            y: topCircleHeight-60,
            width: dateTextLabel.intrinsicContentSize.width,
            height: dateTextLabel.intrinsicContentSize.height
        )
    }
}

