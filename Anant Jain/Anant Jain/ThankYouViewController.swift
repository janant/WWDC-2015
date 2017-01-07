//
//  ThankYouViewController.swift
//  Anant Jain
//
//  Created by Anant Jain on 4/20/15.
//  Copyright (c) 2015 Anant Jain. All rights reserved.
//

import UIKit

class ThankYouViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        titleLabel.transform = CGAffineTransform(translationX: 20, y: 0)
        profile.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        UIView.animate(withDuration: 0.25, delay: 1.0, options: .curveEaseOut, animations: { () -> Void in
            self.titleLabel.transform = CGAffineTransform.identity
            self.titleLabel.alpha = 1.0
        }, completion: nil)
        UIView.animate(withDuration: 0.35, delay: 1.0, options: .curveEaseOut, animations: { () -> Void in
            self.profile.transform = CGAffineTransform.identity
            }, completion: { (completed) -> Void in
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: { () -> Void in
                    self.nameLabel.alpha = 1.0
                }, completion: nil)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.alpha = 0.0
        nameLabel.alpha = 0.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
