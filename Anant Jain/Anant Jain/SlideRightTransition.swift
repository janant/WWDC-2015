//
//  SlideRightTransition.swift
//  Anant Jain
//
//  Created by Anant Jain on 4/18/15.
//  Copyright (c) 2015 Anant Jain. All rights reserved.
//

import UIKit

class SlideRightTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var presenting: Bool?
    
    init(presenting: Bool) {
        self.presenting = presenting
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let toVC = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        let containerView = transitionContext.containerView
        
        if presenting == true {
            containerView.addSubview(toVC)
            
            let screenWidth = UIScreen.main.bounds.size.width
            
            toVC.frame.origin.x -= screenWidth
            
            UIView.animate(withDuration: 0.8, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
                fromVC.transform = CGAffineTransform(translationX: screenWidth, y: 0)
                toVC.transform = CGAffineTransform(translationX: screenWidth, y: 0)
                }) { (completed) -> Void in
                    transitionContext.completeTransition(true)
            }
        }
        else {
            toVC.removeFromSuperview()
            fromVC.removeFromSuperview()
            
            containerView.addSubview(fromVC)
            containerView.addSubview(toVC)
            
            UIView.animate(withDuration: 0.8, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
                toVC.transform = CGAffineTransform.identity
                fromVC.transform = CGAffineTransform.identity
                }) { (completed) -> Void in
                    transitionContext.completeTransition(true)
            }
        }
    }
}
