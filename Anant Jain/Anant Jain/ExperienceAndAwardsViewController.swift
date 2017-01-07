//
//  ExperienceAndAwardsViewController.swift
//  Anant Jain
//
//  Created by Anant Jain on 4/17/15.
//  Copyright (c) 2015 Anant Jain. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation

protocol ExperienceAndAwardsViewControllerDelegate {
    func finishedExperienceAndAwards()
}

class ExperienceAndAwardsViewController: UIViewController, UICollisionBehaviorDelegate {
    
    @IBOutlet weak var ball: UIImageView!
    
    @IBOutlet weak var backHole: UIImageView!
    
    @IBOutlet weak var rollField: UIView!
    
    @IBOutlet weak var backArrow: UIImageView!
    @IBOutlet weak var backLabel: UILabel!
    
    @IBOutlet weak var experienceAndAwardsTextView: UITextView!
    
    var delegate: ExperienceAndAwardsViewControllerDelegate?
    
    var animator = UIDynamicAnimator()
    
    var horizontalPush = UIPushBehavior()
    var verticalPush = UIPushBehavior()
    
    var backCollision = UICollisionBehavior()
    
    var rollingSound = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "Roll", withExtension: "m4a")!)
    var hitSound = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "Hit", withExtension: "m4a")!)
    var warpPipeSound = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "Warp Pipe", withExtension: "mp3")!)
    
    var motionManager = CMMotionManager()
    
    var ballBehavior = UIDynamicItemBehavior()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
            self.warpPipeSound.play()
            self.ball.transform = CGAffineTransform.identity
            self.ball.alpha = 1.0
            }) { (completed) -> Void in
                
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    self.backArrow.alpha = 1.0
                    self.backLabel.alpha = 1.0
                })
                
                self.animator = UIDynamicAnimator(referenceView: self.rollField)
                
                let edgeCollision = UICollisionBehavior(items: [self.ball])
                edgeCollision.translatesReferenceBoundsIntoBoundary  = true
                edgeCollision.collisionDelegate = self
                self.animator.addBehavior(edgeCollision)
                
                self.horizontalPush = UIPushBehavior(items: [self.ball], mode: UIPushBehaviorMode.continuous)
                self.verticalPush = UIPushBehavior(items: [self.ball], mode: UIPushBehaviorMode.continuous)
                self.animator.addBehavior(self.horizontalPush)
                self.verticalPush.angle = CGFloat(3 * M_PI_2)
                self.animator.addBehavior(self.verticalPush)
                
                if self.motionManager.isAccelerometerAvailable {
                    if !self.motionManager.isAccelerometerActive {
                        self.motionManager.accelerometerUpdateInterval = 0.01
                        
                        self.motionManager.startAccelerometerUpdates(to: OperationQueue.main, withHandler: { (data, error) -> Void in
                            let acceleration = data!.acceleration
                            
                            self.verticalPush.magnitude = abs(acceleration.y) > 0.05 ? CGFloat(acceleration.y) : 0
                            self.horizontalPush.magnitude = abs(acceleration.x) > 0.05 ? CGFloat(acceleration.x) : 0
                            
                            let velocity = self.ballBehavior.linearVelocity(for: self.ball)
                            self.rollingSound.volume = Float(sqrt(pow(velocity.x, 2) + pow(velocity.y, 2)) / 1400)
                        })
                    }
                }
                
                self.ballBehavior = UIDynamicItemBehavior(items: [self.ball])
                self.ballBehavior.resistance = 1;
                self.ballBehavior.allowsRotation = false
                self.ballBehavior.density = 0.5
                self.animator.addBehavior(self.ballBehavior)
                
                let holeResistance = UIDynamicItemBehavior(items: [self.backHole])
                holeResistance.resistance = 100000
                holeResistance.allowsRotation = false
                holeResistance.elasticity = -1
                holeResistance.density = 999
                self.animator.addBehavior(holeResistance)
                
                self.backCollision = UICollisionBehavior(items: [self.ball, self.backHole])
                self.backCollision.collisionDelegate = self
                self.animator.addBehavior(self.backCollision)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        rollingSound.numberOfLoops = -1
        rollingSound.volume = 0
        rollingSound.prepareToPlay()
        
        hitSound.prepareToPlay()
        warpPipeSound.prepareToPlay()
        warpPipeSound.volume = 0.7
        
        rollingSound.play()
        
        ball.transform = CGAffineTransform(scaleX: 0.7, y: 0.7).concatenating(CGAffineTransform(translationX: -125, y: 0))
        
        experienceAndAwardsTextView.isEditable = false
        experienceAndAwardsTextView.scrollRangeToVisible(NSMakeRange(0, 0))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        if behavior == backCollision {
            animator.removeAllBehaviors()
            warpPipeSound.play()
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.ball.transform = CGAffineTransform(scaleX: 0.7, y: 0.7).concatenating(CGAffineTransform(translationX: self.backHole.center.x - self.ball.center.x, y: self.backHole.center.y - self.ball.center.y))
                self.ball.alpha = 0
                }, completion: { (completed) -> Void in
                    self.dismiss(animated: true, completion: { () -> Void in
                        self.delegate?.finishedExperienceAndAwards()
                    })
            })
        }
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        let velocity = self.ballBehavior.linearVelocity(for: self.ball)
        hitSound.volume = Float(sqrt(pow(velocity.x, 2) + pow(velocity.y, 2)) / 350)
        hitSound.play()
    }

}
