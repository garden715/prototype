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

    @IBOutlet weak var tableView: UITableView!
    var sections: [Section] = SectionsData().getSectionsFromData()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        if((indexPath.row==0)&&(indexPath.section==2)){
        
            cell.accessoryType = .None
            
            cell.selectionStyle = .None
        }
        else{
        cell.accessoryType = .DisclosureIndicator
        }
        
        return cell
    }
    
    

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //공지사항
        if ((indexPath.row == 0)&&(indexPath.section==0)){
            let url = NSURL(string: "http://blog.naver.com/PostList.nhn?blogId=stylefoxx&from=postList&categoryNo=1")
            
            UIApplication.sharedApplication().openURL(url!)
        }
        
        //이용가이드 
        
        
        if ((indexPath.row == 1)&&(indexPath.section==0)){
            let url = NSURL(string: "http://blog.naver.com/PostList.nhn?blogId=stylefoxx&from=postList&categoryNo=6")
            
            UIApplication.sharedApplication().openURL(url!)
        }

        
        if ((indexPath.row == 0)&&(indexPath.section==1)){
            
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
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (section == (tableView.numberOfSections-1)) {
            return 50.0;
        } else {
            return 0.0;
        }
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if (section == (tableView.numberOfSections-1)) {
            
            let ment = UILabel()
            ment.text = "본 회사는 쇼핑몰과 관계가 없습니다."
            ment.font = UIFont.systemFontOfSize(10,weight: UIFontWeightLight)
            ment.textAlignment = NSTextAlignment.Center
            ment.textColor = UIColor.darkGrayColor()
            //ment.translatesAutoresizingMaskIntoConstraints = false
            ment.numberOfLines = 2
            
            view.addSubview(ment)
            view.backgroundColor = UIColor.blackColor()
            return ment
        } else {
            return nil
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController,
                               didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

}
