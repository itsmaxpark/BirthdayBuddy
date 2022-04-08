//
//  Font.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/8/22.
//

import Foundation
import UIKit

extension Calendar {
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
            let fromDate = startOfDay(for: from) // <1>
            let toDate = startOfDay(for: to) // <2>
            let numberOfDays = dateComponents([.day], from: fromDate, to: toDate) // <3>
            
            return numberOfDays.day!
        }
}

extension Array {
    func rotate(array: inout [Element], k: Int) {
        // Check for edge cases
        if k == 0 || array.count <= 1 {
            return // The resulting array is similar to the input array
        }

        // Calculate the effective number of rotations
        // -> "k % length" removes the abs(k) > n edge case
        // -> "(length + k % length)" deals with the k < 0 edge case
        // -> if k > 0 the final "% length" removes the k > n edge case
        let length = array.count
        let rotations = (length + k % length) % length

        // 1. Reverse the whole array
        let reversed: Array = array.reversed()

        // 2. Reverse first k numbers
        let leftPart: Array = reversed[0..<rotations].reversed()

        // 3. Reverse last n-k numbers
        let rightPart: Array = reversed[rotations..<length].reversed()

        array = leftPart + rightPart
    }
}

extension UIFont {
    
    static func appFont(name: String, size: CGFloat) -> UIFont {
        guard let customFont = UIFont(name: name, size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return customFont
    }
}

extension UIView {
    var width: CGFloat {
        return frame.size.width
    }
    var height: CGFloat {
        return frame.size.height
    }
    var left: CGFloat {
        return frame.origin.x
    }
    var right: CGFloat {
        return left + width
    }
    var top: CGFloat {
        return frame.origin.y
    }
    var bottom: CGFloat {
        return top + height
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
    
    func findNavigationController() -> UINavigationController? {
            if let controller = findViewController() {
                return controller.navigationController
            }
            else {
                return nil
            }
        }
}

extension UIImage {
    
    func resizeImageTo(size: CGSize) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }
}

extension UIView {
    func setGradientBackground(id: Int) {
        switch id {
        case 3,9:
            let gradient = CAGradientLayer()
            gradient.frame = bounds
            gradient.name = String(id)
            gradient.colors = [
                UIColor(named: "Baby Blue")?.cgColor as Any,
                UIColor(named: "Blue")?.cgColor as Any
            ]
            gradient.locations = [0.25, 1]
            gradient.startPoint = CGPoint(x: 0.0, y: 0.1)
            gradient.endPoint = CGPoint(x: 0.75, y: 1)
            gradient.cornerRadius = 20
            gradient.masksToBounds = false
            layer.insertSublayer(gradient, at: 0)
            
        case 4,10:
            let gradient = CAGradientLayer()
            gradient.frame = bounds
            gradient.name = String(id)
            gradient.colors = [
                UIColor(named: "Green")?.cgColor as Any,
                UIColor(named: "Yellow Green")?.cgColor as Any
            ]
            gradient.locations = [0.25, 1]
            gradient.startPoint = CGPoint(x: 0.25, y: 0.1)
            gradient.endPoint = CGPoint(x: 0.75, y: 1)
            gradient.cornerRadius = 20
            gradient.masksToBounds = false
            layer.insertSublayer(gradient, at: 0)
        case 5,11:
            let gradient = CAGradientLayer()
            gradient.frame = bounds
            gradient.name = String(id)
            gradient.colors = [
                UIColor(named: "Yellow Orange")?.cgColor as Any,
                UIColor(named: "Light Orange")?.cgColor as Any
            ]
            gradient.locations = [0.25, 1]
            gradient.startPoint = CGPoint(x: 0.25, y: 0.1)
            gradient.endPoint = CGPoint(x: 0.75, y: 1)
            gradient.cornerRadius = 20
            gradient.masksToBounds = false
            layer.insertSublayer(gradient, at: 0)
            
        case 6,12:
            let gradient = CAGradientLayer()
            gradient.frame = bounds
            gradient.name = String(id)
            gradient.colors = [
                UIColor(named: "Orange")?.cgColor as Any,
                UIColor(named: "Dark Orange")?.cgColor as Any
            ]
            gradient.locations = [0.25, 1]
            gradient.startPoint = CGPoint(x: 0.25, y: 0.1)
            gradient.endPoint = CGPoint(x: 0.75, y: 1)
            gradient.cornerRadius = 20
            gradient.masksToBounds = false
            layer.insertSublayer(gradient, at: 0)
        case 1,7:
            let gradient = CAGradientLayer()
            gradient.frame = bounds
            gradient.name = String(id)
            gradient.colors = [
                UIColor(named: "Light Purple")?.cgColor as Any,
                UIColor(named: "Purple")?.cgColor as Any
            ]
            gradient.locations = [0.25, 1]
            gradient.startPoint = CGPoint(x: 0.25, y: 0.1)
            gradient.endPoint = CGPoint(x: 0.75, y: 1)
            gradient.cornerRadius = 20
            gradient.masksToBounds = false
            layer.insertSublayer(gradient, at: 0)
        case 2,8:
            let gradient = CAGradientLayer()
            gradient.frame = bounds
            gradient.name = String(id)
            gradient.colors = [
                UIColor(named: "Pink")?.cgColor as Any,
                UIColor(named: "Magenta")?.cgColor as Any
            ]
            gradient.locations = [0.25, 1]
            gradient.startPoint = CGPoint(x: 0.25, y: 0.1)
            gradient.endPoint = CGPoint(x: 0.75, y: 1)
            gradient.cornerRadius = 20
            gradient.masksToBounds = false
            layer.insertSublayer(gradient, at: 0)
        default:
            let gradient = CAGradientLayer()
            gradient.frame = bounds
            gradient.name = String(id)
            gradient.colors = [
                UIColor(named: "Pink")?.cgColor as Any,
                UIColor(named: "Magenta")?.cgColor as Any
            ]
            gradient.locations = [0.25, 1]
            gradient.startPoint = CGPoint(x: 0.25, y: 0.1)
            gradient.endPoint = CGPoint(x: 0.75, y: 1)
            gradient.cornerRadius = 20
            gradient.masksToBounds = false
            layer.insertSublayer(gradient, at: 0)
        }
    }
}



