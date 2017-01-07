//
//  MyPhotosPageViewController.swift
//  Anant Jain
//
//  Created by Anant Jain on 4/18/15.
//  Copyright (c) 2015 Anant Jain. All rights reserved.
//

import UIKit

class MyPhotosPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pages = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 1...7 {
            pages.append(self.storyboard!.instantiateViewController(withIdentifier: "Pic\(i)"))
        }
        
        self.setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
        
        self.dataSource = self
        self.delegate = self
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = { () -> Int in
            for i in 0 ..< self.pages.count {
                if viewController === self.pages[i] {
                    return i
                }
            }
            return -1
        }()
        
        return index > 0 ? pages[index - 1] : nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = { () -> Int in
            for i in 0 ..< self.pages.count {
                if viewController === self.pages[i] {
                    return i
                }
            }
            return -1
        }()
        
        return index != pages.count - 1 ? pages[index + 1] : nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    @IBAction func finishViewingPhotos(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        
        dismiss(animated: true, completion: nil)
    }
    
    
}
