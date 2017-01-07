//
//  ConnectWithMeTableViewController.swift
//  Anant Jain
//
//  Created by Anant Jain on 4/19/15.
//  Copyright (c) 2015 Anant Jain. All rights reserved.
//

import UIKit
import MessageUI

protocol ConnectWithMeTableViewControllerDelegate {
    func finishedConnectWithMe()
}

class ConnectWithMeTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    var delegate: ConnectWithMeTableViewControllerDelegate?
    
    @IBOutlet weak var emailCell: UITableViewCell!
    @IBOutlet weak var facebookCell: UITableViewCell!
    @IBOutlet weak var twitterCell: UITableViewCell!
    @IBOutlet weak var linkedinCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        self.tableView.backgroundColor = UIColor.clear
        
        self.tableView.separatorEffect = UIBlurEffect(style: .dark)
        self.tableView.separatorStyle = .none
        
        let selectedView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        
        emailCell.selectedBackgroundView = selectedView
        facebookCell.selectedBackgroundView = selectedView
        twitterCell.selectedBackgroundView = selectedView
        linkedinCell.selectedBackgroundView = selectedView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if MFMailComposeViewController.canSendMail() {
                let composeVC = MFMailComposeViewController()
                composeVC.mailComposeDelegate = self
                composeVC.setToRecipients(["anantjain98@me.com"])
                composeVC.setSubject("Hey Anant!")
                composeVC.setMessageBody("I was checking out your WWDC app. I wanted to say this:\n\n", isHTML: false)
                present(composeVC, animated: true, completion: nil)
            }
        }
        else if indexPath.section == 2 {
            var link = ""
            
            if indexPath.row == 0 {
                link = "https://www.facebook.com/anant.jain.5243"
            }
            else if indexPath.row == 1 {
                link = "https://twitter.com/jainanant98"
            }
            else if indexPath.row == 2 {
                link = "https://www.linkedin.com/in/anantjain1"
            }
            
            self.tableView.deselectRow(at: indexPath, animated: true)
            
            UIApplication.shared.openURL(URL(string: link)!)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissConnectWithMe(_ sender: AnyObject) {
        dismiss(animated: true, completion: { () -> Void in
            self.delegate?.finishedConnectWithMe()
        })
    }
}
