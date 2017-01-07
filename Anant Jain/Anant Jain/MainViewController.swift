//
//  MainViewController.swift
//  Anant Jain
//
//  Created by Anant Jain on 4/16/15.
//  Copyright (c) 2015 Anant Jain. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation

class MainViewController: UIViewController, UICollisionBehaviorDelegate, UIViewControllerTransitioningDelegate, AboutMeViewControllerDelegate, ExperienceAndAwardsViewControllerDelegate, HobbiesAndInterestsViewControllerDelegate, ConnectWithMeTableViewControllerDelegate, MyAppsViewControllerDelegate {
    
    @IBOutlet weak var ball: UIImageView!
    
    @IBOutlet weak var startHole: UIImageView!
    @IBOutlet weak var aboutMeHole: UIImageView!
    @IBOutlet weak var experienceAndAwardsHole: UIImageView!
    @IBOutlet weak var hobbiesAndInterestsHole: UIImageView!
    @IBOutlet weak var connectWithMeHole: UIImageView!
    @IBOutlet weak var myAppsHole: UIImageView!

    @IBOutlet weak var rollField: UIView!
    
    @IBOutlet weak var aboutMeCheck: UIImageView!
    @IBOutlet weak var experienceAndAwardsCheck: UIImageView!
    @IBOutlet weak var hobbiesAndInterestsCheck: UIImageView!
    @IBOutlet weak var connectWithMeCheck: UIImageView!
    @IBOutlet weak var myAppsCheck: UIImageView!
    
    @IBOutlet weak var nextHole: UIImageView!
    @IBOutlet weak var nextArrow: UIImageView!
    @IBOutlet weak var nextLabel: UILabel!
    
    var animator = UIDynamicAnimator()
    
    var horizontalPush = UIPushBehavior()
    var verticalPush = UIPushBehavior()
    
    var aboutMeCollision = UICollisionBehavior()
    var experienceAndAwardsCollision = UICollisionBehavior()
    var hobbiesAndInterestsCollision = UICollisionBehavior()
    var connectWithMeCollision = UICollisionBehavior()
    var myAppsCollision = UICollisionBehavior()
    var nextHoleCollision = UICollisionBehavior()
    
    var edgeCollision = UICollisionBehavior()
    
    var holeResistance = UIDynamicItemBehavior()
    
    var rollingSound = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "Roll", withExtension: "m4a")!)
    var hitSound = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "Hit", withExtension: "m4a")!)
    var warpPipeSound = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "Warp Pipe", withExtension: "mp3")!)
    
    var motionManager = CMMotionManager()
    
    var ballBehavior = UIDynamicItemBehavior()
    
    var initiallyLoaded = false
    
    var viewedAboutMe = false
    var viewedExperienceAndAwards = false
    var viewedHobbiesAndInterests = false
    var viewedConnectWithMe = false
    var viewedMyApps = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if !initiallyLoaded {
            initiallyLoaded = true
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
                self.warpPipeSound.play()
                self.ball.transform = CGAffineTransform.identity
                self.ball.alpha = 1.0
                }) { (completed) -> Void in
                    
                    UIView.animate(withDuration: 0.5, animations: { () -> Void in
                        self.startHole.alpha = 0.0
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
                    
                    let holeResistance = UIDynamicItemBehavior(items: [self.aboutMeHole, self.experienceAndAwardsHole, self.hobbiesAndInterestsHole, self.connectWithMeHole, self.myAppsHole])
                    holeResistance.resistance = 100000
                    holeResistance.allowsRotation = false
                    holeResistance.elasticity = -1
                    holeResistance.density = 999
                    self.animator.addBehavior(holeResistance)
                    
                    self.aboutMeCollision = UICollisionBehavior(items: [self.ball, self.aboutMeHole])
                    self.aboutMeCollision.collisionDelegate = self
                    self.animator.addBehavior(self.aboutMeCollision)
                    
                    self.experienceAndAwardsCollision = UICollisionBehavior(items: [self.ball, self.experienceAndAwardsHole])
                    self.experienceAndAwardsCollision.collisionDelegate = self
                    self.animator.addBehavior(self.experienceAndAwardsCollision)
                    
                    self.hobbiesAndInterestsCollision = UICollisionBehavior(items: [self.ball, self.hobbiesAndInterestsHole])
                    self.hobbiesAndInterestsCollision.collisionDelegate = self
                    self.animator.addBehavior(self.hobbiesAndInterestsCollision)
                    
                    self.connectWithMeCollision = UICollisionBehavior(items: [self.ball, self.connectWithMeHole])
                    self.connectWithMeCollision.collisionDelegate = self
                    self.animator.addBehavior(self.connectWithMeCollision)
                    
                    self.myAppsCollision = UICollisionBehavior(items: [self.ball, self.myAppsHole])
                    self.myAppsCollision.collisionDelegate = self
                    self.animator.addBehavior(self.myAppsCollision)
                    
                    self.nextHoleCollision = UICollisionBehavior(items: [self.ball, self.nextHole])
                    self.nextHoleCollision.collisionDelegate = self
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        rollingSound.numberOfLoops = -1
        rollingSound.volume = 0
        rollingSound.prepareToPlay()
        
        hitSound.prepareToPlay()
        warpPipeSound.prepareToPlay()
        warpPipeSound.volume = 0.7
        
        rollingSound.play()
        
        ball.transform = CGAffineTransform(scaleX: 0.7, y: 0.7).concatenating(CGAffineTransform(translationX: 80, y: 0))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        if behavior == aboutMeCollision {
            animator.removeAllBehaviors()
            warpPipeSound.play()
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.ball.transform = CGAffineTransform(scaleX: 0.7, y: 0.7).concatenating(CGAffineTransform(translationX: self.aboutMeHole.center.x - self.ball.center.x, y: self.aboutMeHole.center.y - self.ball.center.y))
                self.ball.alpha = 0
            }, completion: { (completed) -> Void in
                self.performSegue(withIdentifier: "About Me", sender: nil)
            })
        }
        else if behavior == experienceAndAwardsCollision {
            animator.removeAllBehaviors()
            warpPipeSound.play()
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.ball.transform = CGAffineTransform(scaleX: 0.7, y: 0.7).concatenating(CGAffineTransform(translationX: self.experienceAndAwardsHole.center.x - self.ball.center.x, y: self.experienceAndAwardsHole.center.y - self.ball.center.y))
                self.ball.alpha = 0
                }, completion: { (completed) -> Void in
                    self.performSegue(withIdentifier: "Experience and Awards", sender: nil)
            })
        }
        else if behavior == hobbiesAndInterestsCollision {
            animator.removeAllBehaviors()
            warpPipeSound.play()
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.ball.transform = CGAffineTransform(scaleX: 0.7, y: 0.7).concatenating(CGAffineTransform(translationX: self.hobbiesAndInterestsHole.center.x - self.ball.center.x, y: self.hobbiesAndInterestsHole.center.y - self.ball.center.y))
                self.ball.alpha = 0
                }, completion: { (completed) -> Void in
                    self.performSegue(withIdentifier: "Hobbies and Interests", sender: nil)
            })
        }
        else if behavior == connectWithMeCollision {
            animator.removeAllBehaviors()
            warpPipeSound.play()
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.ball.transform = CGAffineTransform(scaleX: 0.7, y: 0.7).concatenating(CGAffineTransform(translationX: self.connectWithMeHole.center.x - self.ball.center.x, y: self.connectWithMeHole.center.y - self.ball.center.y))
                self.ball.alpha = 0
                }, completion: { (completed) -> Void in
                    self.performSegue(withIdentifier: "Connect with Me", sender: nil)
            })
        }
        else if behavior == myAppsCollision {
            animator.removeAllBehaviors()
            warpPipeSound.play()
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.ball.transform = CGAffineTransform(scaleX: 0.7, y: 0.7).concatenating(CGAffineTransform(translationX: self.myAppsHole.center.x - self.ball.center.x, y: self.myAppsHole.center.y - self.ball.center.y))
                self.ball.alpha = 0
                }, completion: { (completed) -> Void in
                    self.performSegue(withIdentifier: "My Apps", sender: nil)
            })
        }
        else if behavior == nextHoleCollision {
            animator.removeAllBehaviors()
            warpPipeSound.play()
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.ball.transform = CGAffineTransform(scaleX: 0.7, y: 0.7).concatenating(CGAffineTransform(translationX: self.nextHole.center.x - self.ball.center.x, y: self.nextHole.center.y - self.ball.center.y))
                self.ball.alpha = 0
                }, completion: { (completed) -> Void in
                    self.performSegue(withIdentifier: "Next", sender: nil)
            })
        }
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        let velocity = self.ballBehavior.linearVelocity(for: self.ball)
        hitSound.volume = Float(sqrt(pow(velocity.x, 2) + pow(velocity.y, 2)) / 350)
        hitSound.play()
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if presented is AboutMeViewController {
            return SlideDownTransition(presenting: true)
        }
        else if presented is ExperienceAndAwardsViewController {
            return SlideRightTransition(presenting: true)
        }
        else if presented is HobbiesAndInterestsViewController {
            return SlideUpTransition(presenting: true)
        }
        else if presented is MyAppsViewController {
            return SlideLeftTransition(presenting: true)
        }
        else if presented is FirstWWDCViewController {
            return SlideInTransition(presenting: true)
        }
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if dismissed is AboutMeViewController {
            return SlideDownTransition(presenting: false)
        }
        else if dismissed is ExperienceAndAwardsViewController {
            return SlideRightTransition(presenting: false)
        }
        else if dismissed is HobbiesAndInterestsViewController {
            return SlideUpTransition(presenting: false)
        }
        else if dismissed is MyAppsViewController {
            return SlideLeftTransition(presenting: false)
        }
        else if dismissed is FirstWWDCViewController {
            return SlideInTransition(presenting: false)
        }
        return nil
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "About Me" {
            let aboutMeVC = segue.destination as! AboutMeViewController
            aboutMeVC.modalPresentationStyle = .fullScreen
            aboutMeVC.transitioningDelegate = self
            aboutMeVC.delegate = self
        }
        else if segue.identifier == "Experience and Awards" {
            let experienceAndAwardsVC = segue.destination as! ExperienceAndAwardsViewController
            experienceAndAwardsVC.modalPresentationStyle = .fullScreen
            experienceAndAwardsVC.transitioningDelegate = self
            experienceAndAwardsVC.delegate = self
        }
        else if segue.identifier == "Hobbies and Interests" {
            let hobbiesAndInterestsVC = segue.destination as! HobbiesAndInterestsViewController
            hobbiesAndInterestsVC.modalPresentationStyle = .fullScreen
            hobbiesAndInterestsVC.transitioningDelegate = self
            hobbiesAndInterestsVC.delegate = self
        }
        else if segue.identifier == "Connect with Me" {
            let connectWithMeTVC = (segue.destination as! UINavigationController).topViewController as! ConnectWithMeTableViewController
            connectWithMeTVC.delegate = self
        }
        else if segue.identifier == "My Apps" {
            let myAppsVC = segue.destination as! MyAppsViewController
            myAppsVC.modalPresentationStyle = .fullScreen
            myAppsVC.transitioningDelegate = self
            myAppsVC.delegate = self
        }
        else if segue.identifier == "Next" {
            let firstWWDCVC = segue.destination as! FirstWWDCViewController
            firstWWDCVC.modalPresentationStyle = .fullScreen
            firstWWDCVC.transitioningDelegate = self
        }
    }
    
    func checkIfAllVisited() {
        if viewedAboutMe && viewedExperienceAndAwards && viewedHobbiesAndInterests && viewedConnectWithMe && viewedMyApps {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: { () -> Void in
                self.nextHole.alpha = 1.0
                self.nextArrow.alpha = 1.0
                self.nextLabel.alpha = 1.0
            }, completion: { (completed) -> Void in
                self.animator.addBehavior(self.nextHoleCollision)
            })
        }
    }

    func finishedAboutMe() {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.warpPipeSound.play()
            self.ball.transform = CGAffineTransform.identity
            self.ball.alpha = 1.0
            self.ball.frame.origin.x = self.aboutMeHole.frame.origin.x + 50
        }, completion: { (completed) -> Void in
            self.restoreBehaviors()
            self.viewedAboutMe = true
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: { () -> Void in
                self.aboutMeCheck.alpha = 1.0
            }, completion: { (completed) -> Void in
                self.checkIfAllVisited()
            })
        }) 
    }
    
    func finishedExperienceAndAwards() {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.warpPipeSound.play()
            self.ball.transform = CGAffineTransform.identity
            self.ball.alpha = 1.0
            self.ball.frame.origin.x = self.experienceAndAwardsHole.frame.origin.x + 50
            }, completion: { (completed) -> Void in
                self.restoreBehaviors()
                self.viewedExperienceAndAwards = true
                
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: { () -> Void in
                    self.experienceAndAwardsCheck.alpha = 1.0
                    }, completion: { (completed) -> Void in
                        self.checkIfAllVisited()
                })
        }) 
    }
    
    func finishedHobbiesAndInterests() {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.warpPipeSound.play()
            self.ball.transform = CGAffineTransform.identity
            self.ball.alpha = 1.0
            self.ball.frame.origin.x = self.hobbiesAndInterestsHole.frame.origin.x + 50
            }, completion: { (completed) -> Void in
                self.restoreBehaviors()
                self.viewedHobbiesAndInterests = true
                
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: { () -> Void in
                    self.hobbiesAndInterestsCheck.alpha = 1.0
                    }, completion: { (completed) -> Void in
                        self.checkIfAllVisited()
                })
        }) 
    }
    
    func finishedConnectWithMe() {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.warpPipeSound.play()
            self.ball.transform = CGAffineTransform.identity
            self.ball.alpha = 1.0
            self.ball.frame.origin.y = self.connectWithMeHole.frame.origin.y + 50
            }, completion: { (completed) -> Void in
                self.restoreBehaviors()
                self.viewedConnectWithMe = true
                
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: { () -> Void in
                    self.connectWithMeCheck.alpha = 1.0
                    }, completion: { (completed) -> Void in
                        self.checkIfAllVisited()
                })
        }) 
    }
    
    func finishedMyApps() {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.warpPipeSound.play()
            self.ball.transform = CGAffineTransform.identity
            self.ball.alpha = 1.0
            self.ball.frame.origin.y = self.myAppsHole.frame.origin.y + 50
            }, completion: { (completed) -> Void in
                self.restoreBehaviors()
                self.viewedMyApps = true
                
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: { () -> Void in
                    self.myAppsCheck.alpha = 1.0
                    }, completion: { (completed) -> Void in
                        self.checkIfAllVisited()
                })
        }) 
    }
    
    func restoreBehaviors() {
        animator = UIDynamicAnimator(referenceView: rollField)
        
        self.animator.addBehavior(self.aboutMeCollision)
        self.animator.addBehavior(self.experienceAndAwardsCollision)
        self.animator.addBehavior(self.hobbiesAndInterestsCollision)
        self.animator.addBehavior(self.connectWithMeCollision)
        self.animator.addBehavior(self.myAppsCollision)
        
        self.animator.addBehavior(self.horizontalPush)
        self.animator.addBehavior(self.verticalPush)
        
        self.animator.addBehavior(self.ballBehavior)
        self.animator.addBehavior(self.holeResistance)
        
        edgeCollision = UICollisionBehavior(items: [self.ball])
        edgeCollision.translatesReferenceBoundsIntoBoundary  = true
        edgeCollision.collisionDelegate = self
        self.animator.addBehavior(edgeCollision)
    }
}

