//
//  StartViewController.swift
//  Anant Jain
//
//  Created by Anant Jain on 4/16/15.
//  Copyright (c) 2015 Anant Jain. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation

class StartViewController: UIViewController, UICollisionBehaviorDelegate, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var hiLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var rollView: UIView!
    
    @IBOutlet weak var ball: UIImageView!
    @IBOutlet weak var ballArrow: UIImageView!
    @IBOutlet weak var ballDescription: UILabel!
    
    @IBOutlet weak var hole: UIImageView!
    @IBOutlet weak var holeArrow: UIImageView!
    @IBOutlet weak var holeDescription: UILabel!
    
    var animator = UIDynamicAnimator()
    
    var horizontalPush = UIPushBehavior()
    var verticalPush = UIPushBehavior()
    var collision = UICollisionBehavior()
    var ballBehavior = UIDynamicItemBehavior()
    
    var motionManager = CMMotionManager()
    
    var rollingSound = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "Roll", withExtension: "m4a")!)
    var hitSound = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "Hit", withExtension: "m4a")!)
    var warpPipeSound = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "Warp Pipe", withExtension: "mp3")!)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        rollingSound.numberOfLoops = -1
        rollingSound.volume = 0
        rollingSound.prepareToPlay()
        
        hitSound.prepareToPlay()
        warpPipeSound.prepareToPlay()
        warpPipeSound.volume = 0.7
        
        hiLabel.transform = CGAffineTransform(translationX: -20, y: 0)
        nameLabel.transform = CGAffineTransform(translationX: 20, y: 0)
        descriptionLabel.transform = CGAffineTransform(translationX: 0, y: 20)
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            self.hiLabel.transform = CGAffineTransform.identity
            self.hiLabel.alpha = 1.0
        }, completion: nil)
        
        UIView.animate(withDuration: 0.25, delay: 0.75, options: .curveEaseOut, animations: { () -> Void in
            self.nameLabel.transform = CGAffineTransform.identity
            self.nameLabel.alpha = 1.0
        }, completion: nil)
        
        UIView.animate(withDuration: 0.25, delay: 2.0, options: .curveEaseOut, animations: { () -> Void in
            self.descriptionLabel.transform = CGAffineTransform.identity
            self.descriptionLabel.alpha = 1.0
        }, completion: nil)
        
        animator = UIDynamicAnimator(referenceView: rollView)
        
        let edgeCollision = UICollisionBehavior(items: [ball])
        edgeCollision.translatesReferenceBoundsIntoBoundary  = true
        edgeCollision.collisionDelegate = self
        animator.addBehavior(edgeCollision)
        
        horizontalPush = UIPushBehavior(items: [ball], mode: UIPushBehaviorMode.continuous)
        verticalPush = UIPushBehavior(items: [ball], mode: UIPushBehaviorMode.continuous)
        animator.addBehavior(horizontalPush)
        verticalPush.angle = CGFloat(3 * M_PI_2)
        animator.addBehavior(verticalPush)
        
        ballBehavior = UIDynamicItemBehavior(items: [ball])
        ballBehavior.resistance = 1;
        ballBehavior.allowsRotation = false
        ballBehavior.density = 0.5
        self.animator.addBehavior(ballBehavior)
        
        collision = UICollisionBehavior(items: [ball, hole])
        collision.collisionDelegate = self
        
        UIView.animate(withDuration: 0.5, delay: 3.5, options: .curveEaseOut, animations: { () -> Void in
            self.ball.alpha = 1.0
            self.ballArrow.alpha = 1.0
            self.ballDescription.alpha = 1.0
            self.hole.alpha = 1.0
            self.holeArrow.alpha = 1.0
            self.holeDescription.alpha = 1.0
        }) { (completed) -> Void in
            self.animator.addBehavior(self.collision)
            self.rollingSound.play()
            
            if self.motionManager.isAccelerometerAvailable {
                if !self.motionManager.isAccelerometerActive {
                    self.motionManager.accelerometerUpdateInterval = 0.01
                    
                    self.motionManager.startAccelerometerUpdates(to: OperationQueue.main, withHandler: { (data, error) -> Void in
                        let acceleration = data!.acceleration
                        
                        let horizontalMag = abs(acceleration.x) > 0.05 ? CGFloat(acceleration.x) : 0
                        let verticalMag = abs(acceleration.y) > 0.05 ? CGFloat(acceleration.y) : 0
                        
                        self.horizontalPush.magnitude = horizontalMag
                        self.verticalPush.magnitude = verticalMag
                        
                        let velocity = self.ballBehavior.linearVelocity(for: self.ball)
                        self.rollingSound.volume = Float(sqrt(pow(velocity.x, 2) + pow(velocity.y, 2)) / 1400)
                    })
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        if behavior == collision {
            animator.removeAllBehaviors()
            warpPipeSound.play()
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.ball.transform = CGAffineTransform(scaleX: 0.7, y: 0.7).concatenating(CGAffineTransform(translationX: self.hole.center.x - self.ball.center.x, y: self.hole.center.y - self.ball.center.y))
                self.ball.alpha = 0
            }, completion: { (completed) -> Void in
                self.performSegue(withIdentifier: "Learn More", sender: nil)
            })
        }
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        let velocity = self.ballBehavior.linearVelocity(for: self.ball)
        hitSound.volume = Float(sqrt(pow(velocity.x, 2) + pow(velocity.y, 2)) / 350)
        hitSound.play()
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideInTransition(presenting: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Learn More" {
            let mainVC = segue.destination as! MainViewController
            mainVC.modalPresentationStyle = .fullScreen
            mainVC.transitioningDelegate = self
        }
    }

}
