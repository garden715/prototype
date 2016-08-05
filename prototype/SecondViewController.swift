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


enum flag {
    case Default
    case Modify
}




class SecondViewController: UICollectionViewController {
    
    //MARK: - View Controller Lifecycle
    var baseUrl = ""
    var productTYPE = ""
    var productPATH = ""
    var productList = [Product]()
    let emptyImage = UIImageView()
    let emptyText = UILabel()
    var currenctFlag = flag.Default
    
    
    @IBOutlet weak var leftButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.allowsMultipleSelection = true
        self.collectionView?.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
       
        leftButton.setTitle("편집하기", forState: .Normal)
        
        addImageAndTextView()
        registerCollectionViewCells()
    }
    
    @IBAction func change(sender: AnyObject) {
        print("?!dhdld")
        if (currenctFlag == flag.Default){
            currenctFlag = flag.Modify
            leftButton.setTitle("편집완료하기", forState: .Normal)
            
        }
        else{
            currenctFlag = flag.Default
            leftButton.setTitle("편집하기", forState: .Normal)
            
                print(collectionView?.indexPathsForSelectedItems())
            
        }

    }
        // 찜상품 삭제 후 두번째 탭을 보았을 때 collection view 데이터를 reload
    override func viewWillAppear(animated: Bool) {
        self.collectionView?.reloadData()
        if whetherFavoriteIsEmpty() {
            emptyImage.hidden = false
            emptyText.hidden = false
        } else {
            emptyText.hidden = true
            emptyImage.hidden = true
        }
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
        return PhotosDataManager.sharedManager.allPhotos(3, str: "favoriteItems", pageNumber: 0).count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoCollectionViewCellIdentifier, forIndexPath: indexPath) as! PhotoCollectionViewCell
        cell.configure(glacierScenicAtIndex(indexPath))
        cell.layer.cornerRadius = 10
        
        return cell
    }
    
    func glacierScenicAtIndex(indexPath: NSIndexPath) -> GlacierScenic {
        
        let photos = PhotosDataManager.sharedManager.allPhotos(3, str: "favoriteItems", pageNumber: 0)
        return photos[indexPath.row]
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if(currenctFlag == flag.Default){
        let uvc = self.storyboard!.instantiateViewControllerWithIdentifier("PageDetail") as! PageDetailViewController
        
        uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        
        let photo = PhotosDataManager.sharedManager.allPhotos(3, str: "favoriteItems", pageNumber: 0)[indexPath.row]
        print("세컨뷰:\(photo.baseUrl)")
        let pageInform = DatabaseManager.findbaseUrl(photo)
        
        uvc.baseUrl = pageInform.baseUrl
        uvc.productTYPE = pageInform.proType
        uvc.productPATH = pageInform.proPath
        
        uvc.selectedItem = photo
        
        self.presentViewController(uvc, animated: true, completion: {})
        }
        else {
        var cell = collectionView.cellForItemAtIndexPath(indexPath) as! PhotoCollectionViewCell
        var tempimage = cell.imageView.image
        
                cell.imageView.alpha = 0.5
         
        }
    }

    
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        var cell = collectionView.cellForItemAtIndexPath(indexPath) as! PhotoCollectionViewCell
        
        
        cell.imageView.alpha = 1
        

    }
    
    
    func whetherFavoriteIsEmpty() -> Bool{
        if PhotosDataManager.sharedManager.allPhotos(3, str: "favoriteItems", pageNumber: 0).count == 0 {
            return true
        }
        return false
    }
    
    func addImageAndTextView(){
        emptyImage.image = UIImage(named: "emptyBox")
        emptyImage.translatesAutoresizingMaskIntoConstraints = false
        emptyText.text = "찜상품이 없습니다.\n하트 버튼을 눌러 추가해 주세요."
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
    
    @IBAction func removeAll(sender: AnyObject) {
        if PhotosDataManager.sharedManager.allPhotos(3, str: "favoriteItems", pageNumber: 0).count == 0 {
            let controller = UIAlertController(title: "알림", message: "찜한 상품이 없습니다.", preferredStyle: .Alert)
            let confirmAction = UIAlertAction(title: "확인", style: .Cancel, handler: {(_) in})
            controller.addAction(confirmAction)
            self.presentViewController(controller, animated: true, completion: {(_) in})
        }
            
        else {
            let alert = UIAlertController(title: "전체삭제", message: "찜상품을 모두 삭제하시겠습니까?", preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            let cancelAction = UIAlertAction(title: "취소", style: UIAlertActionStyle.Cancel, handler: {(_) in } )
            let deleteAction = UIAlertAction(title: "삭제", style: UIAlertActionStyle.Destructive, handler: {(_) in
                DatabaseManager.removeAll()
                self.collectionView?.reloadData()
                self.emptyText.hidden = false
                self.emptyImage.hidden = false
                }
            )
            
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            
            self.presentViewController(alert, animated: true, completion: {(_) in })
        }
    }
    
    
}
//MARK: - CollectionView Flow Layout

extension SecondViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let spacing: CGFloat = 5
        let itemWidth = (collectionView.frame.size.width / 3) - (spacing * 2)
        let itemHeight = (collectionView.frame.size.width / 2.2)
        return CGSize(width: itemWidth, height: itemHeight)
        
    }
}
