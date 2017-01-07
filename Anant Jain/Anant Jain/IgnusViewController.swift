//
//  IgnusViewController.swift
//  Anant Jain
//
//  Created by Anant Jain on 4/22/15.
//  Copyright (c) 2015 Anant Jain. All rights reserved.
//

import UIKit

protocol IgnusViewControllerDelegate {
    func finishedIgnus()
}

class IgnusViewController: UIViewController, UICollectionViewDataSource {
    
    var delegate: IgnusViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            self.delegate?.finishedIgnus()
        })
    }

}
