//
//  ShoppingMallHomeViewController.swift
//  prototype
//
//  Created by seojungwon on 2016. 6. 24..
//  Copyright © 2016년 한상현. All rights reserved.
//

import UIKit

class ShoppingMallHomeViewController: UIViewController {
    @IBOutlet weak var mallWebView: UIWebView!
    
    var urlSource = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(urlSource)
        
        loadWebPage()
        print("the end")
        
        // Do any additional setup after loading the view.
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
        mallWebView.loadRequest(request)
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
}
