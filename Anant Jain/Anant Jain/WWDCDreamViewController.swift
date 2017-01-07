//
//  WWDCDreamViewController.swift
//  Anant Jain
//
//  Created by Anant Jain on 4/20/15.
//  Copyright (c) 2015 Anant Jain. All rights reserved.
//

import UIKit

class WWDCDreamViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tapLabel: UILabel!
    
    var tapRecognizer = UITapGestureRecognizer()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        titleLabel.transform = CGAffineTransform(translationX: 20, y: 0)
        descriptionLabel.transform = CGAffineTransform(translationX: 20, y: 0)
        
        UIView.animate(withDuration: 0.25, delay: 1.0, options: .curveEaseOut, animations: { () -> Void in
            self.titleLabel.transform = CGAffineTransform.identity
            self.titleLabel.alpha = 1.0
            }, completion: { (completed) -> Void in
                
                UIView.animate(withDuration: 0.25, delay: 2.5, options: .curveEaseOut, animations: { () -> Void in
                    self.descriptionLabel.transform = CGAffineTransform.identity
                    self.descriptionLabel.alpha = 1.0
                    }, completion: { (completed) -> Void in
                        
                        self.tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(WWDCDreamViewController.nextSlide(_:)))
                        self.view.addGestureRecognizer(self.tapRecognizer)
                        
                        UIView.animate(withDuration: 0.25, delay: 1.5, options: .curveEaseOut, animations: { () -> Void in
                            self.tapLabel.alpha = 1.0
                        }, completion: nil)
                        
                })
                
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.alpha = 0.0
        descriptionLabel.alpha = 0.0
        tapLabel.alpha = 0.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nextSlide(_ recognizer: UIGestureRecognizer) {
        self.view.removeGestureRecognizer(tapRecognizer)
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
            self.titleLabel.transform = CGAffineTransform(translationX: -20, y: 0)
            self.descriptionLabel.transform = CGAffineTransform(translationX: -20, y: 0)
            
            self.titleLabel.alpha = 0.0
            self.descriptionLabel.alpha = 0.0
            self.tapLabel.alpha = 0.0
            }, completion: { (completed) -> Void in
                self.performSegue(withIdentifier: "Next", sender: nil)
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
