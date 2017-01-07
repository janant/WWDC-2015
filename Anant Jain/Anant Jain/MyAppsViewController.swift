//
//  MyAppsViewController.swift
//  Anant Jain
//
//  Created by Anant Jain on 4/19/15.
//  Copyright (c) 2015 Anant Jain. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation

protocol MyAppsViewControllerDelegate {
    func finishedMyApps()
}

class MyAppsViewController: UIViewController, UICollisionBehaviorDelegate, RPSViewControllerDelegate, CBViewControllerDelegate, CWViewControllerDelegate, IgnusViewControllerDelegate {
    
    @IBOutlet weak var ball: UIImageView!
    
    @IBOutlet weak var backHole: UIImageView!
    
    @IBOutlet weak var rollField: UIView!
    
    @IBOutlet weak var backArrow: UIImageView!
    @IBOutlet weak var backLabel: UILabel!
    
    @IBOutlet weak var ignusHole: UIImageView!
    @IBOutlet weak var cwHole: UIImageView!
    @IBOutlet weak var cbHole: UIImageView!
    @IBOutlet weak var rpsHole: UIImageView!
    
    var ignusCollision = UICollisionBehavior()
    var cwCollision = UICollisionBehavior()
    var cbCollision = UICollisionBehavior()
    var rpsCollision = UICollisionBehavior()
    
    var delegate: MyAppsViewControllerDelegate?
    
    var animator = UIDynamicAnimator()
    
    var horizontalPush = UIPushBehavior()
    var verticalPush = UIPushBehavior()
    
    var backCollision = UICollisionBehavior()
    var edgeCollision = UICollisionBehavior()
    
    var rollingSound = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "Roll", withExtension: "m4a")!)
    var hitSound = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "Hit", withExtension: "m4a")!)
    var warpPipeSound = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "Warp Pipe", withExtension: "mp3")!)
    
    var motionManager = CMMotionManager()
    
    var ballBehavior = UIDynamicItemBehavior()
    var holeResistance = UIDynamicItemBehavior()
    
    var initiallyLoaded = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !initiallyLoaded {
            initiallyLoaded = true
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
                    
                    self.edgeCollision = UICollisionBehavior(items: [self.ball])
                    self.edgeCollision.translatesReferenceBoundsIntoBoundary  = true
                    self.edgeCollision.collisionDelegate = self
                    self.animator.addBehavior(self.edgeCollision)
                    
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
                    
                    self.holeResistance = UIDynamicItemBehavior(items: [self.backHole])
                    self.holeResistance.resistance = 100000
                    self.holeResistance.allowsRotation = false
                    self.holeResistance.elasticity = -1
                    self.holeResistance.density = 999
                    self.animator.addBehavior(self.holeResistance)
                    
                    self.backCollision = UICollisionBehavior(items: [self.ball, self.backHole])
                    self.backCollision.collisionDelegate = self
                    self.animator.addBehavior(self.backCollision)
                    
                    self.ignusCollision = UICollisionBehavior(items: [self.ball, self.ignusHole])
                    self.ignusCollision.collisionDelegate = self
                    self.animator.addBehavior(self.ignusCollision)
                    
                    self.cwCollision = UICollisionBehavior(items: [self.ball, self.cwHole])
                    self.cwCollision.collisionDelegate = self
                    self.animator.addBehavior(self.cwCollision)
                    
                    self.cbCollision = UICollisionBehavior(items: [self.ball, self.cbHole])
                    self.cbCollision.collisionDelegate = self
                    self.animator.addBehavior(self.cbCollision)
                    
                    self.rpsCollision = UICollisionBehavior(items: [self.ball, self.rpsHole])
                    self.rpsCollision.collisionDelegate = self
                    self.animator.addBehavior(self.rpsCollision)
            }
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
                        self.delegate?.finishedMyApps()
                    })
            })
        }
        else if behavior == ignusCollision {
            animator.removeAllBehaviors()
            warpPipeSound.play()
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.ball.transform = CGAffineTransform(scaleX: 0.7, y: 0.7).concatenating(CGAffineTransform(translationX: self.ignusHole.center.x - self.ball.center.x, y: self.ignusHole.center.y - self.ball.center.y))
                self.ball.alpha = 0
                }, completion: { (completed) -> Void in
                    self.performSegue(withIdentifier: "Ignus", sender: nil)
            })
        }
        else if behavior == cwCollision {
            animator.removeAllBehaviors()
            warpPipeSound.play()
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.ball.transform = CGAffineTransform(scaleX: 0.7, y: 0.7).concatenating(CGAffineTransform(translationX: self.cwHole.center.x - self.ball.center.x, y: self.cwHole.center.y - self.ball.center.y))
                self.ball.alpha = 0
                }, completion: { (completed) -> Void in
                    self.performSegue(withIdentifier: "CW", sender: nil)
            })
        }
        else if behavior == cbCollision {
            animator.removeAllBehaviors()
            warpPipeSound.play()
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.ball.transform = CGAffineTransform(scaleX: 0.7, y: 0.7).concatenating(CGAffineTransform(translationX: self.cbHole.center.x - self.ball.center.x, y: self.cbHole.center.y - self.ball.center.y))
                self.ball.alpha = 0
                }, completion: { (completed) -> Void in
                    self.performSegue(withIdentifier: "CB", sender: nil)
            })
        }
        else if behavior == rpsCollision {
            animator.removeAllBehaviors()
            warpPipeSound.play()
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.ball.transform = CGAffineTransform(scaleX: 0.7, y: 0.7).concatenating(CGAffineTransform(translationX: self.rpsHole.center.x - self.ball.center.x, y: self.rpsHole.center.y - self.ball.center.y))
                self.ball.alpha = 0
                }, completion: { (completed) -> Void in
                    self.performSegue(withIdentifier: "RPS", sender: nil)
            })
        }
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        let velocity = self.ballBehavior.linearVelocity(for: self.ball)
        hitSound.volume = Float(sqrt(pow(velocity.x, 2) + pow(velocity.y, 2)) / 350)
        hitSound.play()
    }
    
    func finishedRPS() {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.warpPipeSound.play()
            self.ball.transform = CGAffineTransform.identity
            self.ball.alpha = 1.0
            self.ball.frame.origin.y = self.rpsHole.frame.origin.y - 50
            }, completion: { (completed) -> Void in
                self.restoreBehaviors()
        }) 
    }
    
    func finishedCB() {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.warpPipeSound.play()
            self.ball.transform = CGAffineTransform.identity
            self.ball.alpha = 1.0
            self.ball.frame.origin.y = self.cbHole.frame.origin.y - 50
            }, completion: { (completed) -> Void in
                self.restoreBehaviors()
        }) 
    }
    
    func finishedCW() {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.warpPipeSound.play()
            self.ball.transform = CGAffineTransform.identity
            self.ball.alpha = 1.0
            self.ball.frame.origin.x = self.cwHole.frame.origin.x + 50
            }, completion: { (completed) -> Void in
                self.restoreBehaviors()
        }) 
    }
    
    func finishedIgnus() {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.warpPipeSound.play()
            self.ball.transform = CGAffineTransform.identity
            self.ball.alpha = 1.0
            self.ball.frame.origin.x = self.ignusHole.frame.origin.x - 50
            }, completion: { (completed) -> Void in
                self.restoreBehaviors()
        }) 
    }
    
    func restoreBehaviors() {
        animator = UIDynamicAnimator(referenceView: rollField)
        
        self.animator.addBehavior(self.ignusCollision)
        self.animator.addBehavior(self.cwCollision)
        self.animator.addBehavior(self.cbCollision)
        self.animator.addBehavior(self.rpsCollision)
        self.animator.addBehavior(self.backCollision)
        
        self.animator.addBehavior(self.horizontalPush)
        self.animator.addBehavior(self.verticalPush)
        
        self.animator.addBehavior(self.ballBehavior)
        self.animator.addBehavior(self.holeResistance)
        
        edgeCollision = UICollisionBehavior(items: [self.ball])
        edgeCollision.translatesReferenceBoundsIntoBoundary  = true
        edgeCollision.collisionDelegate = self
        self.animator.addBehavior(edgeCollision)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RPS" {
            let rpsVC = (segue.destination as! UINavigationController).topViewController as! RPSViewController
            rpsVC.delegate = self
        }
        else if segue.identifier == "CB" {
            let cbVC = (segue.destination as! UINavigationController).topViewController as! CBViewController
            cbVC.delegate = self
        }
        else if segue.identifier == "CW" {
            let cwVC = (segue.destination as! UINavigationController).topViewController as! CWViewController
            cwVC.delegate = self
        }
        else if segue.identifier == "Ignus" {
            let ignusVC = (segue.destination as! UINavigationController).topViewController as! IgnusViewController
            ignusVC.delegate = self
        }
        
    }
    
}
