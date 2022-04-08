//
//  PresentAnimator.swift
//  BirthdayBuddy
//
//  Created by Max Park on 4/2/22.
//

import Foundation

import UIKit

class PresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.5
    
    private let originFrame: CGRect
    
    init(originFrame: CGRect) {
        self.originFrame = originFrame
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // 1) setup
        guard let _ = transitionContext.viewController(forKey: .from),
          let toView = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        //2) create animation
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toView)
        
        let xScaleFactor = originFrame.width / finalFrame.width
        let yScaleFactor = originFrame.height / finalFrame.height
        
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
            
        toView.view.transform = scaleTransform
        toView.view.center = CGPoint(
            x: originFrame.midX,
            y: originFrame.midY
        )
        
        toView.view.clipsToBounds = true
        toView.view.layer.cornerRadius = 20
        
        containerView.addSubview(toView.view)
        
        UIView.animate(withDuration: duration, delay: 0.0,
                       options: [], animations: {
            
            toView.view.transform = CGAffineTransform.identity
            toView.view.center = CGPoint(
                x: finalFrame.midX,
                y: finalFrame.midY
            )
            
        }, completion: {_ in
            
            //3 complete the transition
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
        
    }
    
}
