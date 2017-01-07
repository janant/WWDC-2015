//
//  SlideInTransition.swift
//  Anant Jain
//
//  Created by Anant Jain on 4/16/15.
//  Copyright (c) 2015 Anant Jain. All rights reserved.
//

import UIKit

class SlideInTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
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
            let darkView = UIView()
            darkView.backgroundColor = UIColor.black
            darkView.frame = toVC.frame
            darkView.alpha = 0.5
            
            containerView.addSubview(toVC)
            containerView.addSubview(darkView)
            containerView.addSubview(fromVC)
            
            toVC.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: { () -> Void in
                fromVC.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                fromVC.alpha = 0.0
                }) { (completed) -> Void in
                    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: { () -> Void in
                        toVC.transform = CGAffineTransform.identity
                        darkView.alpha = 0.0
                    }, completion: { (completed) -> Void in
                        transitionContext.completeTransition(true)
                    })
            }
        }
        else {
            toVC.removeFromSuperview()
            fromVC.removeFromSuperview()
            
            containerView.addSubview(fromVC)
            containerView.addSubview(toVC)
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: { () -> Void in
                toVC.transform = CGAffineTransform.identity
                }) { (completed) -> Void in
                    transitionContext.completeTransition(true)
            }
        }
    }
}
