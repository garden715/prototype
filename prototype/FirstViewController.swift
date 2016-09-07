//
//  FirstViewController.swift
//  prototype
//
//  Created by 한상현 on 2016. 5. 20..
//  Copyright © 2016년 한상현. All rights reserved.
//

import UIKit
import Haneke


class FirstViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var ShoppingMallsTableView: UITableView!
    
    // MARK : Properties
    var shoppinMalls = [Site]()
    
    var sitelistCallUrl:String = "http://52.36.117.149:3000/title"
    
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
                    if let type1 = jsonData["type1"] as? String {
                        site.type1 = type1
                    }
                    if let type2 = jsonData["type2"] as? String {
                        site.type2 = type2
                    }
                    if let type3 = jsonData["type3"] as? String {
                        site.type3 = type3
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
        let shoppingMall = shoppinMalls[indexPath.row]

        let uvc = self.storyboard!.instantiateViewControllerWithIdentifier("PhotoscollectionVC") as! PhotosCollectionViewController
        
        uvc.modalTransitionStyle = .CoverVertical
        
        uvc.baseUrl = shoppingMall.url
        uvc.productPATH = shoppingMall.productPATH
        uvc.productTYPE = shoppingMall.productTYPE
        uvc.name = shoppingMall.name
        uvc.title = shoppingMall.name
        self.presentViewController(uvc, animated: true, completion: {})
        
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
        
        var typeLabel = "\(shoppingMall.type1)"
        
        if shoppingMall.type2 != "" {
            typeLabel += ",\(shoppingMall.type2)"
            if shoppingMall.type3 != "" {
                typeLabel += ",\(shoppingMall.type3)"
            }
        }
        
        cell.tags.text = typeLabel
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
        
        uvc.sites = self.shoppinMalls
        
        uvc.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        self.presentViewController(uvc, animated: true, completion: {})
    }
}