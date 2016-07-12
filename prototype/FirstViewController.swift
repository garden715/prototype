//
//  FirstViewController.swift
//  prototype
//
//  Created by 한상현 on 2016. 5. 20..
//  Copyright © 2016년 한상현. All rights reserved.
//

import UIKit
import Haneke

class Site : NSObject {
    var url : String = ""
    var name : String = ""
    var imgurl :String = "https://www.dropbox.com/s/5guvmulrpzyefbu/9466_shop1_145706.gif?dl=1"
    var productTYPE : String = ""
    var productPATH : String = ""
    
}

class FirstViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var ShoppingMallsTableView: UITableView!
    
    // MARK : Properties
    var shoppinMalls = [Site]()
    
    
    var sitelistCallUrl:String = "http://52.38.132.199:3000/title"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadsiteList(sitelistCallUrl)
        
    }
    
    func loadsiteList(loadurl:String){
        
        let nsurl = NSURL(string: loadurl)
        let data = NSData(contentsOfURL: nsurl!)
        
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            
            if let jsonDatalist = json as? [[String: AnyObject]] { //파싱을 시작한다.
                for jsonData in jsonDatalist {
                    //작성자 이름을 가져와서 배열에 추가
                    let site = Site()
                    if let url = jsonData["baseUrl"] as? String {
                        site.url = url
                    }
                    if let namee = jsonData["title"] as? String {
                        site.name = namee
                    }
                    if let productTYPE = jsonData["productTYPE"] as? String {
                        site.productTYPE = productTYPE
                    }
                    if let productPATH = jsonData["productPATH"] as? String {
                        site.productPATH = productPATH
                    }
                    self.shoppinMalls.append(site)
                }
                
            }
        } catch {
            print("error serializing JSON: \(error)")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        PhotosDataManager.sharedManager.destroycache()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        ShoppingMallsTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppinMalls.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ShoppingMallCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ShoppingMallCell
        
        let shoppingMall = shoppinMalls[indexPath.row]
        
        cell.name.text = shoppingMall.name
        
        cell.num.text = "\(indexPath.row+1)"
        let url = NSURL(string:shoppingMall.imgurl)
        cell.photo.hnk_setImageFromURL(url!)
        cell.tags.text = shoppingMall.url
        cell.rounded()
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier=="siteView")
        {
            let cell = sender as! UITableViewCell
            
            let path = self.ShoppingMallsTableView.indexPathForCell(cell)
            
            let param = self.shoppinMalls[path!.row]
            
            (segue.destinationViewController as? PhotosCollectionViewController)?.baseUrl = param.url
            
            (segue.destinationViewController as? PhotosCollectionViewController)?.productPATH = param.productPATH
            (segue.destinationViewController as? PhotosCollectionViewController)?.productTYPE = param.productTYPE
            (segue.destinationViewController as? PhotosCollectionViewController)?.title = param.name
            (segue.destinationViewController as? PhotosCollectionViewController)?.name = param.name
        }
    }
    
    @IBAction func siteSearchButtonClicked(sender: AnyObject) {
        let uvc = self.storyboard!.instantiateViewControllerWithIdentifier("SearchSite") as! SiteSearchViewController
        
        uvc.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        self.presentViewController(uvc, animated: true, completion: {})
    }
}