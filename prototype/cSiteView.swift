//
//  SecondViewController.swift
//  prototype
//
//  Created by 한상현 on 2016. 5. 20..
//  Copyright © 2016년 한상현. All rights reserved.
//

import UIKit

class cSiteView: UICollectionViewController {
    
    @IBAction func dismiss(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)

    }
    
    var siteurl = ""
    var productList = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("serialization start")
        let url = "http://52.36.117.149:3000/imgurl/\(siteurl)" //리뷰를 불러오는 명령
        let nsurl = NSURL(string: url)
        let data = NSData(contentsOfURL: nsurl!)
        
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            
            if let jsonDatalist = json as? [[String: AnyObject]] { //파싱을 시작한다.
                for jsonData in jsonDatalist {
                    //작성자 이름을 가져와서 배열에 추가
                    let site = Product()
                    if let url = jsonData["img_thumb"] as? String {
                        
                        
                        site.imageUrl = url
                        
                        
                        
                    }
                    if let namee = jsonData["name"] as? String {
                        
                        site.productName = namee
                        
                        
                        
                        
                    }
                    if let pricee = jsonData["price"] as? String {
                        
                        site.price = pricee
                        
                        
                        
                        
                    }
                    self.productList.append(site)
                }
                
            }
        } catch {
            print("error serializing JSON: \(error)")
        }
        print("serialization complete")
        
        
        print(productList.count)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
}

