//
//  MoreViewController.swift
//  prototype
//
//  Created by seojungwon on 2016. 7. 4..
//  Copyright © 2016년 한상현. All rights reserved.
//

import UIKit
import MessageUI

class MoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,MFMailComposeViewControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var tableView: UITableView!
    var sections: [Section] = SectionsData().getSectionsFromData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage.init(named: "fox")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sections[section].items.count
    }
    
     func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].heading
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("sectionCell", forIndexPath: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = sections[indexPath.section].items[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if ((indexPath.row == 0)){
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            // Configure the fields of the interface.
            composeVC.setToRecipients(["hsn103@gmail.com"])
            composeVC.setSubject("문의 및 건의사항!")
            composeVC.setMessageBody("Hello from California!", isHTML: false)
            
            // Present the view controller modally.
            self.presentViewController(composeVC, animated: true, completion: nil)
            composeVC.modalPresentationStyle = UIModalPresentationStyle.FormSheet
            
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController,
                               didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

}
