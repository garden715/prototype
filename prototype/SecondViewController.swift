//
//  SecondViewController.swift
//  prototype
//
//  Created by 한상현 on 2016. 5. 20..
//  Copyright © 2016년 한상현. All rights reserved.
//

import UIKit
import FMDB

private let PhotoCollectionViewCellIdentifier = "PhotoCell"

class SecondViewController: UICollectionViewController {
    
    //MARK: - View Controller Lifecycle
    var baseUrl = ""
    var productTYPE = ""
    var productPATH = ""
    var productList = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let favoriteButton = UIButton()
        let favoriteButton_width:CGFloat  = 60
        let favoriteButton_height:CGFloat  = 60
        let navbarheight:CGFloat  = 64
        let margin:CGFloat  = 30
        
        favoriteButton.setTitle("홈", forState: UIControlState.Normal)
        favoriteButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        favoriteButton.backgroundColor = UIColor.yellowColor()
        
        favoriteButton.layer.shadowColor = UIColor.grayColor().CGColor
        favoriteButton.layer.shadowOffset = CGSizeMake(2, 3.0);
        favoriteButton.layer.shadowOpacity = 0.5;
        favoriteButton.layer.shadowRadius = 1.0;
        
        favoriteButton.frame = CGRectMake(favoriteButton_width-margin, view.bounds.size.height-favoriteButton_height-navbarheight-margin, favoriteButton_width,favoriteButton_height )
        favoriteButton.addTarget(self, action: #selector(self.store(_:)), forControlEvents: .TouchUpInside)
        
        //half of the width
        favoriteButton.layer.cornerRadius = favoriteButton_width/2
        
        self.view.addSubview(favoriteButton)

        
        registerCollectionViewCells()
    }
    
    func searchFromBaseurl(baseUrl : String) {
        print("serialization start")
        
        let siteurl = "http://52.38.132.199:3000/title/\(baseUrl)" //리뷰를 불러오는 명령
        
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

    }
    
    func store(sender: UIButton!) {
        
    }
    
    func pressed(sender: UIButton!) {
        let uvc = self.storyboard!.instantiateViewControllerWithIdentifier("PageDetail") as! PageDetailViewController
        
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
        return PhotosDataManager.sharedManager.allPhotos("favoriteItems").count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoCollectionViewCellIdentifier, forIndexPath: indexPath) as! PhotoCollectionViewCell
        cell.configure(glacierScenicAtIndex(indexPath))
        return cell
    }
    
    func glacierScenicAtIndex(indexPath: NSIndexPath) -> GlacierScenic {
        
        let photos = PhotosDataManager.sharedManager.allPhotos("favoriteItems")
        return photos[indexPath.row]
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let uvc = self.storyboard!.instantiateViewControllerWithIdentifier("PageDetail") as! PageDetailViewController
        
        uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        
        uvc.urlSource = "http://\(baseUrl)\(productPATH)?\(productTYPE)=\(PhotosDataManager.sharedManager.allPhotos(baseUrl)[indexPath.row].product_id)"
        print(uvc.urlSource)
        
        self.presentViewController(uvc, animated: true, completion: {})
        
    }
    
    
}
//MARK: - CollectionView Flow Layout

extension SecondViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let spacing: CGFloat = 0
        let itemWidth = (view.bounds.size.width / 3.2) - (spacing / 2)
        let itemHeight = (view.bounds.size.width / 2) - (spacing / 2)
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
}
