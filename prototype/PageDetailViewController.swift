//
//  PageDetailViewController.swift
//  prototype
//
//  Created by seojungwon on 2016. 5. 25..
//  Copyright © 2016년 한상현. All rights reserved.
//

import UIKit
import JLToast

class PageDetailViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var navTitle: UINavigationItem!

    
    var urlSource = String()
    
    var baseUrl = String()
    var productPATH = String()
    var productTYPE = String()
    var selectedItem = GlacierScenic(name: "", price: "", photoURLString: "", product_id: 0, baseUrl: "")
    var databasePath = NSString()
    var isStored :Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        urlSource = "http://\(baseUrl)\(productPATH)?\(productTYPE)=\(selectedItem.product_id)"
        
        setNavigationItem()
        
        navTitle.title =  selectedItem.name
        
        dispatch_async(dispatch_get_main_queue()) { // 2
            
            self.loadWebPage()
        }
        
        //        print("the end")
        // Do any additional setup after loading the view.
    }
    
    func setNavigationItem() {
        var favoriteBackgroundImage: UIImage
        
        isStored = DatabaseManager.isStored(baseUrl, product: selectedItem)
        
        // 없는 경우
        if isStored == 1 {
            favoriteBackgroundImage = UIImage(named: "heart-outline")!
        } else {
            favoriteBackgroundImage = UIImage(named: "heart")!
        }
        
        let button: UIButton = UIButton.init(type: UIButtonType.Custom)
        //set image for button
        button.setImage(favoriteBackgroundImage, forState: UIControlState.Normal)
        
        //add function for button
        button.addTarget(self, action:#selector(self.favoriteButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        //set frame
        button.frame = CGRectMake(0, 0, 22, 22)
        
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        navTitle.rightBarButtonItem = barButton


    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* webView Loading하는 함수
     * url 변수에 baseUrl입력 해서 request날림
     * */
    func loadWebPage(){
        let url = NSURL(string: urlSource)
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
    }
    
    /* webView의 load가 시작할 때 호출 됨*/
    func webViewDidStartLoad(webView: UIWebView){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    /* webView의 load가 끝났을 때 호출 됨*/
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        print("There was a problem loading the web page!")
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func favoriteButton(sender: AnyObject) {
        
        
        let alert = DatabaseManager.saveData(baseUrl, type: productTYPE, path: productPATH, product: selectedItem)

        if alert == 1 {
            JLToast.makeText("추가완료", duration: JLToastDelay.ShortDelay).show()
        } else if alert == 2 {
            JLToast.makeText("삭제완료", delay: 1, duration: JLToastDelay.ShortDelay).show()
        }
        setNavigationItem()
    }
}
