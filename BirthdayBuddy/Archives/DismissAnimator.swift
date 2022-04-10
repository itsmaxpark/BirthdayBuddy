//
//  DismissAnimator.swift
//  BirthdayBuddy
//
//  Created by Max Park on 4/2/22.
//

import Foundation

import UIKit

class DismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.5
    
    private let destinationFrame: CGRect
    
    init(destinationFrame: CGRect) {
        self.destinationFrame = destinationFrame
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        //1) setup the transition
        
       guard let fromView = transitionContext.viewController(forKey: .from),
             let toView = transitionContext.viewController(forKey: .to) else {
           return
       }
        
        
        //2) animations!
        let containerView = transitionContext.containerView
        containerView.insertSubview(toView.view, belowSubview: fromView.view)
        
        UIView.animate(withDuration: duration, delay: 0.0, options: [], animations: {
            
            fromView.view.transform = CGAffineTransform(scaleX: 1, y: 1)
            
        }, completion: {_ in
            
            //3) complete the transition
            transitionContext.completeTransition(
                !transitionContext.transitionWasCancelled
            )
        })
        
        
    }
    
}
