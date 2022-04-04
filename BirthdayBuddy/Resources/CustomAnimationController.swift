//
//  CustomAnimationController.swift
//  BirthdayBuddy
//
//  Created by Max Park on 4/2/22.
//

import Foundation
import UIKit


class CustomTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {

  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return CustomAnimationController(isPresenting: true)
  }

  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return CustomAnimationController(isPresenting: false)
  }

}

class CustomAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let isPresenting: Bool
    
    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
        else {
            transitionContext.completeTransition(true)
            return
        }
        
        let containerView = transitionContext.containerView
        
        // add toVC.view as subview. If dismissing, make sure it is under the presented view!
        if isPresenting {
            containerView.addSubview(toVC.view)
        } else {
            containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        }
        toVC.view.frame = containerView.bounds
        
//        print("from: \(fromVC.title)")
//        print("to: \(toVC.title)") // DetailView
        
        let tabBarVC = (isPresenting ? fromVC : toVC) as! HomeViewController
        let detailVC = (isPresenting ? toVC : fromVC) as! CollectionViewCellDetailViewController
//        print("tab: \(tabBarVC.title)")
        let initialFrame = tabBarVC.selectedCell.frame
//        else {
//            assertionFailure("Selected emoji frame not set before presentation")
//            transitionContext.completeTransition(true)
//            return
//        }
        
        // ensure views laid out for snapshots and positioning
        containerView.layoutIfNeeded()
        let snapshot = detailVC.view.snapshotView(afterScreenUpdates: true)!
        containerView.addSubview(snapshot)
        snapshot.frame = detailVC.view.frame
        
        let initialPosition = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
        let initialScale = initialFrame.height / snapshot.bounds.height
        
        // setup for animation
        detailVC.view.isHidden = true  // snapshot stands in for this view
        if isPresenting {
            snapshot.center = initialPosition
            snapshot.transform = CGAffineTransform.identity.scaledBy(x: initialScale, y: initialScale)
            detailVC.view.alpha = 0.0
        }
        
        // define animations
        let animations: () -> ()
        if isPresenting {
            animations = {
                snapshot.center = detailVC.view.center
                snapshot.transform = .identity
                detailVC.view.alpha = 1.0
            }
        } else {
            animations = {
                snapshot.center = initialPosition
                snapshot.transform = CGAffineTransform.identity.scaledBy(x: initialScale, y: initialScale)
                detailVC.view.alpha = 0.0
            }
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: animations) { _ in
            detailVC.view.isHidden = false
            snapshot.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
        
    }
}

