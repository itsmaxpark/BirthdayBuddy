//
//  GradientBackgroundView.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/29/22.
//

import UIKit

class GradientBackgroundView: UIView {
    
    private var gradientLayer: CustomGradientLayer?
    
    init(gradient: GradientType) {
        
        super.init(frame: CGRect(x: 0, y: 0, width: 220, height: 300))
        getGradientType(gradient: gradient)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    override func layoutSubviews() {

        let topColor = UIColor(named: gradientLayer?.topColor ?? "B")
        let bottomColor = UIColor(named: gradientLayer?.bottomColor ?? "B")
        (layer as! CAGradientLayer).colors = [topColor as Any, bottomColor as Any]
        (layer as! CAGradientLayer).locations = gradientLayer?.locations

    }

    func getGradientType(gradient: GradientType) {
        switch gradient {
        case .blue:
            self.gradientLayer = CustomGradientLayer(
                topColor: "Light Blue",
                bottomColor: "Blue",
                locations: [0.25, 1],
                startPoint: CGPoint(x: 0.25, y: 0.5),
                endPoint: CGPoint(x: 0.75, y: 0.5)
            )
        case .green:
            self.gradientLayer = CustomGradientLayer(
                topColor: "Light Blue",
                bottomColor: "Blue",
                locations: [0.25, 1],
                startPoint: CGPoint(x: 0.25, y: 0.5),
                endPoint: CGPoint(x: 0.75, y: 0.5)
            )
        case .yellow:
            self.gradientLayer = CustomGradientLayer(
                topColor: "Light Blue",
                bottomColor: "Blue",
                locations: [0.25, 1],
                startPoint: CGPoint(x: 0.25, y: 0.5),
                endPoint: CGPoint(x: 0.75, y: 0.5)
            )
        case .orange:
            self.gradientLayer = CustomGradientLayer(
                topColor: "Light Blue",
                bottomColor: "Blue",
                locations: [0.25, 1],
                startPoint: CGPoint(x: 0.25, y: 0.5),
                endPoint: CGPoint(x: 0.75, y: 0.5)
            )
        case .purple:
            self.gradientLayer = CustomGradientLayer(
                topColor: "Light Blue",
                bottomColor: "Blue",
                locations: [0.25, 1],
                startPoint: CGPoint(x: 0.25, y: 0.5),
                endPoint: CGPoint(x: 0.75, y: 0.5)
            )
        case .pink:
            self.gradientLayer = CustomGradientLayer(
                topColor: "Light Blue",
                bottomColor: "Blue",
                locations: [0.25, 1],
                startPoint: CGPoint(x: 0.25, y: 0.5),
                endPoint: CGPoint(x: 0.75, y: 0.5)
            )
        }
    }

}
