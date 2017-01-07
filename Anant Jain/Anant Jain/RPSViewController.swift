//
//  RPSViewController.swift
//  Anant Jain
//
//  Created by Anant Jain on 4/21/15.
//  Copyright (c) 2015 Anant Jain. All rights reserved.
//

import UIKit

protocol RPSViewControllerDelegate {
    func finishedRPS()
}

class RPSViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var downloadButton: UIButton!
    
    var delegate: RPSViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        downloadButton.setBackgroundImage(UIImage(named: "Button Frame.png")?.withRenderingMode(.alwaysTemplate).resizableImage(withCapInsets: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4), resizingMode: .stretch), for: UIControlState())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func download(_ sender: AnyObject) {
        UIApplication.shared.openURL(URL(string: "https://itunes.apple.com/us/app/rock-paper-scissors-for-iphone/id619530332?mt=8")!)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Image Cell\(indexPath.row + 1)", for: indexPath) 
        
        return cell
    }
    
    @IBAction func dismiss(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: { () -> Void in
            self.delegate?.finishedRPS()
        })
    }
    

}
