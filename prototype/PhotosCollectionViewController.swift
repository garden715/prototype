//
//  PhotosCollectionViewController.swift
//  GlacierScenics
//
//  Created by Todd Kramer on 1/30/16.
//  Copyright © 2016 Todd Kramer. All rights reserved.
//

import UIKit

private let PhotoCollectionViewCellIdentifier = "PhotoCell"

class PhotosCollectionViewController: UICollectionViewController {
    
    //MARK: - View Controller Lifecycle
    var baseUrl = ""
    var productTYPE = ""
    var productPATH = ""
     var productList = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myFirstButton = UIButton()
        let myFirstButton_width:CGFloat  = 60
        let myFirstButton_height:CGFloat  = 60
        
        let margin:CGFloat  = 30
        
        let navbarheight:CGFloat  = 64
        
        myFirstButton.setTitle("홈", forState: UIControlState.Normal)
        myFirstButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        myFirstButton.backgroundColor = UIColor.yellowColor()
        
        myFirstButton.layer.shadowColor = UIColor.grayColor().CGColor
        myFirstButton.layer.shadowOffset = CGSizeMake(2, 3.0);
        myFirstButton.layer.shadowOpacity = 0.5;
        myFirstButton.layer.shadowRadius = 1.0;
        
        myFirstButton.frame = CGRectMake(view.bounds.size.width-myFirstButton_width-margin, view.bounds.size.height-myFirstButton_height-navbarheight-margin, myFirstButton_width,myFirstButton_height )
        myFirstButton.addTarget(self, action: #selector(self.pressed(_:)), forControlEvents: .TouchUpInside)
        
        //half of the width
        myFirstButton.layer.cornerRadius = myFirstButton_width/2
        
        self.view.addSubview(myFirstButton)
        
        print("serialization start")
        
        let siteurl = "http://52.38.132.199:3000/title/\(baseUrl)" //리뷰를 불러오는 명령
        print(siteurl)
        let nsurl = NSURL(string: siteurl)
        let data = NSData(contentsOfURL: nsurl!)
        
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            
            if let jsonDatalist = json as? [[String: AnyObject]] { //파싱을 시작한다.
                for jsonData in jsonDatalist {
                    //작성자 이름을 가져와서 배열에 추가
                    if let productTYPE = jsonData["productTYPE"] as? String {
                        self.productTYPE = productTYPE
                    }
                    if let productPATH = jsonData["productPATH"] as? String {
                        self.productPATH = productPATH
                    }
                }
                
            }
        } catch {
            print("error serializing JSON: \(error)")
        }
        print("serialization complete")

        
        registerCollectionViewCells()
    }
    
    func pressed(sender: UIButton!) {
        let uvc = self.storyboard!.instantiateViewControllerWithIdentifier("ShoppingMallDetail") as! ShoppingMallHomeViewController
        
        uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        
        uvc.urlSource = "http://\(baseUrl)"
        print(uvc.urlSource)
        
        self.presentViewController(uvc, animated: true, completion: {})
    }
    
    override func viewDidDisappear(animated: Bool) {
        PhotosDataManager.sharedManager.destroycache()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    //MARK: - Collection View Setup
    
    func registerCollectionViewCells() {
        collectionView?.registerNib(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: PhotoCollectionViewCellIdentifier)
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotosDataManager.sharedManager.allPhotos(baseUrl).count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoCollectionViewCellIdentifier, forIndexPath: indexPath) as! PhotoCollectionViewCell
        cell.configure(glacierScenicAtIndex(indexPath))
        return cell
    }

    func glacierScenicAtIndex(indexPath: NSIndexPath) -> GlacierScenic {
        
        let photos = PhotosDataManager.sharedManager.allPhotos(baseUrl)
        return photos[indexPath.row]
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let uvc = self.storyboard!.instantiateViewControllerWithIdentifier("PageDetail") as! PageDetailViewController
        
        uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        
        uvc.baseUrl = baseUrl
        uvc.productTYPE = productTYPE
        uvc.productPATH = productPATH
        
        uvc.selectedItem = PhotosDataManager.sharedManager.allPhotos(baseUrl)[indexPath.row]
        
        self.presentViewController(uvc, animated: true, completion: {})

    }
    

}

//MARK: - CollectionView Flow Layout

extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let spacing: CGFloat = 0
        let itemWidth = (view.bounds.size.width / 3.2) - (spacing / 2)
        let itemHeight = (view.bounds.size.width / 2) - (spacing / 2)
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
}
