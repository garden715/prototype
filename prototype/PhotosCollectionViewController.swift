//
//  PhotosCollectionViewController.swift
//  GlacierScenics
//
//  Created by Todd Kramer on 1/30/16.
//  Copyright © 2016 Todd Kramer. All rights reserved.
//

import UIKit
import JLToast

private let PhotoCollectionViewCellIdentifier = "PhotoCell"

class PhotosCollectionViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var navBarButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    //MARK: - View Controller Lifecycle
    var baseUrl = "http://09women.com"
    var name = ""
    var productTYPE = ""
    var productPATH = ""
    var productList = [Product]()
    let emptyImage = UIImageView()
    let emptyText = UILabel()
    var pageNumber = 1
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        addLongPressGesture()
        //addGoHomepageButton()
        addImageAndTextView()
        registerCollectionViewCells()
        navBarButton.setTitle(name, forState: .Normal)
        navBarButton.addTarget(self, action: #selector(self.pressed(_:)), forControlEvents: .TouchUpInside)
    }
    @IBAction func dismiss(sender: AnyObject) {
        PhotosDataManager.sharedManager.destroycache()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func whetherFavoriteIsEmpty() -> Bool{
        if PhotosDataManager.sharedManager.allPhotos(1, str: baseUrl, pageNumber: pageNumber).count == 0 {
            return true
        }
        return false
    }
    override func viewWillAppear(animated: Bool) {
        if whetherFavoriteIsEmpty() {
            emptyImage.hidden = false
            emptyText.hidden = false
        } else {
            emptyText.hidden = true
            emptyImage.hidden = true
        }
    }
    
    func pressed(sender: UIButton!) {
        let uvc = self.storyboard!.instantiateViewControllerWithIdentifier("ShoppingMallDetail") as! ShoppingMallHomeViewController
        
        uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        
        uvc.urlSource = "http://\(self.baseUrl)"
        uvc.name = self.name
        self.presentViewController(uvc, animated: true, completion: {})
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
    
     func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return PhotosDataManager.sharedManager.allPhotos(1, str: baseUrl, pageNumber: pageNumber).count
    }
    
     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoCollectionViewCellIdentifier, forIndexPath: indexPath) as! PhotoCollectionViewCell
        cell.configure(glacierScenicAtIndex(indexPath))
        cell.layer.cornerRadius = 10
        return cell
    }
    
    func glacierScenicAtIndex(indexPath: NSIndexPath) -> GlacierScenic {
        
        let photos = PhotosDataManager.sharedManager.allPhotos(1, str: baseUrl, pageNumber: pageNumber)
        return photos[indexPath.row]
    }
    
     func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let uvc = self.storyboard!.instantiateViewControllerWithIdentifier("PageDetail") as! PageDetailViewController
        
        uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        
        uvc.selectedItem = PhotosDataManager.sharedManager.allPhotos(1, str: baseUrl, pageNumber: pageNumber)[indexPath.row]
        uvc.baseUrl = baseUrl
        uvc.productTYPE = productTYPE
        uvc.productPATH = productPATH
        self.presentViewController(uvc, animated: true, completion: {})

    }
    
    func addLongPressGesture(){
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(PhotosCollectionViewController.handleLongPress(_:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.collectionView?.addGestureRecognizer(lpgr)
    }
    
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state == .Began {
            let p = gestureReconizer.locationInView(self.collectionView)
            let indexPath = self.collectionView?.indexPathForItemAtPoint(p)
            
            if let index = indexPath {
                favoriteButton(index)
            } else {
                print("Could not find index path")
            }
        }
    }
    
    func favoriteButton(index: NSIndexPath) {
        JLToastCenter.defaultCenter().cancelAllToasts()
        if DatabaseManager.isStored(baseUrl, product: PhotosDataManager.sharedManager.allPhotos(1, str: baseUrl, pageNumber: pageNumber)[index.row]) == 1 { // 없는 경우
            DatabaseManager.saveData(baseUrl, type: productTYPE, path: productPATH, product: PhotosDataManager.sharedManager.allPhotos(1, str: baseUrl, pageNumber: pageNumber)[index.row])
            JLToast.makeText("찜상품에 추가했습니다.", duration: JLToastDelay.ShortDelay).show()
            
        } else { // 있는 경우
            JLToast.makeText("이미 찜하셨습니다.", duration: JLToastDelay.ShortDelay).show()
        }
        
    }
    
    func addGoHomepageButton() {
        let myFirstButton = UIButton()
        let myFirstButton_width:CGFloat  = 50
        let myFirstButton_height:CGFloat  = 50
        
        let margin:CGFloat = 15
        let navbarheight:CGFloat  = 64
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.collectionView?.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        myFirstButton.setTitle("홈", forState: UIControlState.Normal)
        myFirstButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        myFirstButton.backgroundColor = UIColor.init(red: 1, green: 0.3, blue: 0, alpha: 0.8)
        myFirstButton.layer.shadowColor = UIColor.grayColor().CGColor
        myFirstButton.layer.shadowOffset = CGSizeMake(2, 3.0);
        myFirstButton.layer.shadowOpacity = 0.5;
        myFirstButton.layer.shadowRadius = 1.0;
        
        myFirstButton.frame = CGRectMake(view.bounds.size.width-myFirstButton_width-margin, view.bounds.size.height-myFirstButton_height-navbarheight-margin-(self.tabBarController?.tabBar.frame.height)!, myFirstButton_width,myFirstButton_height )
        myFirstButton.addTarget(self, action: #selector(self.pressed(_:)), forControlEvents: .TouchUpInside)
        
        //half of the width
        myFirstButton.layer.cornerRadius = myFirstButton_width/2
        
        view.addSubview(myFirstButton)

    }
    
    func addImageAndTextView(){
        emptyImage.image = UIImage(named: "emptyBox")
        emptyImage.translatesAutoresizingMaskIntoConstraints = false
        emptyText.text = "등록된 상품이 없습니다.\n조금만 기다려 주세요."
        emptyText.font = UIFont.systemFontOfSize(17,weight: UIFontWeightLight)
        emptyText.textAlignment = NSTextAlignment.Center
        emptyText.textColor = UIColor.darkGrayColor()
        emptyText.translatesAutoresizingMaskIntoConstraints = false
        emptyText.numberOfLines = 2 

        
        view.addSubview(emptyImage)
        view.addSubview(emptyText)
        
        let horizontalConstraint = NSLayoutConstraint(item: emptyImage, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        view.addConstraint(horizontalConstraint)
        
        let horizontalConstraint2 = NSLayoutConstraint(item:emptyText, attribute:NSLayoutAttribute.CenterX, relatedBy:NSLayoutRelation.Equal, toItem:view, attribute:NSLayoutAttribute.CenterX, multiplier:1, constant:0)
        view.addConstraint(horizontalConstraint2)
        
        let verticalConstraint = NSLayoutConstraint(item: emptyImage, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        view.addConstraint(verticalConstraint)
        
        let verticalConstraint2 = NSLayoutConstraint(item: emptyText, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 20)
        view.addConstraint(verticalConstraint2)
        
        let widthConstraint = NSLayoutConstraint(item: emptyImage, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100)
        view.addConstraint(widthConstraint)
        
        let widthConstraint2 = NSLayoutConstraint(item: emptyText, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        view.addConstraint(widthConstraint2)
        
        let heightConstraint = NSLayoutConstraint(item: emptyImage, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100)
        view.addConstraint(heightConstraint)
        
        let heightConstraint2 = NSLayoutConstraint(item: emptyText, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: emptyText, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        view.addConstraint(heightConstraint2)
        
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == PhotosDataManager.sharedManager.allPhotos(1, str: baseUrl, pageNumber: pageNumber).count-1) {
            pageNumber+=1
            print("\t\(pageNumber)")
            
            PhotosDataManager.sharedManager.allPhotos(1, str: baseUrl, pageNumber: pageNumber)
            
            dispatch_async(dispatch_get_main_queue()) {
                
                collectionView.reloadData()
            }
        }
    }
    
}

////MARK: - CollectionView Flow Layout

extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let spacing: CGFloat = 5
        let itemWidth = (collectionView.frame.size.width / 3) - (spacing * 2)
        let itemHeight = (collectionView.frame.size.width / 2.2)
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
