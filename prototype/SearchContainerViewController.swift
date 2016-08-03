//
//  SearchContainerViewController.swift
//  prototype
//
//  Created by seojungwon on 2016. 7. 6..
//  Copyright © 2016년 한상현. All rights reserved.
//

import UIKit
import FMDB

private let PhotoCollectionViewCellIdentifier = "PhotoCell"

class SearchContainerViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate, UIGestureRecognizerDelegate, UISearchBarDelegate{

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    var baseUrl = ""
    var productTYPE = ""
    var productPATH = ""
    var productList = [Product]()
    let emptyImage = UIImageView()
    let emptyText = UILabel()
    var pageNumber = 1
    
    var searchText = "09"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        registerCollectionViewCells()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return PhotosDataManager.sharedManager.allPhotos(2, str: searchText, pageNumber: 1).count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoCollectionViewCellIdentifier, forIndexPath: indexPath) as! PhotoCollectionViewCell
        cell.configure(glacierScenicAtIndex(indexPath))
        cell.layer.cornerRadius = 10
        return cell
    }
    
    func glacierScenicAtIndex(indexPath: NSIndexPath) -> GlacierScenic {
        
        let photos = PhotosDataManager.sharedManager.allPhotos(2, str: searchText, pageNumber: 1)
        return photos[indexPath.row]
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let uvc = self.storyboard!.instantiateViewControllerWithIdentifier("PageDetail") as! PageDetailViewController
        
        uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        
        let photo = PhotosDataManager.sharedManager.allPhotos(2, str: searchText, pageNumber: 1)[indexPath.row]
        print("검색뷰:\(photo.baseUrl)")
        let pageInform = DatabaseManager.findbaseUrl(photo)
        
        uvc.baseUrl = pageInform.baseUrl
        uvc.productTYPE = pageInform.proType
        uvc.productPATH = pageInform.proPath
        
        uvc.selectedItem = photo
        
        self.presentViewController(uvc, animated: true, completion: {})
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == PhotosDataManager.sharedManager.allPhotos(2, str: searchText, pageNumber: pageNumber).count-1) {
            pageNumber+=1
            print("\t\(pageNumber)")
            
            PhotosDataManager.sharedManager.allPhotos(2, str: baseUrl, pageNumber: pageNumber)
            
            dispatch_async(dispatch_get_main_queue()) {
                
                collectionView.reloadData()
            }
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        PhotosDataManager.sharedManager.destroycache()
        searchText = searchBar.text!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        print(searchText)
        
        PhotosDataManager.sharedManager.allPhotos(2, str: searchText, pageNumber: 1)
        collectionView.reloadData()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}


//MARK: - CollectionView Flow Layout

extension SearchContainerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let spacing: CGFloat = 5
        let itemWidth = (collectionView.frame.size.width / 3) - (spacing * 2)
        let itemHeight = (collectionView.frame.size.width / 2.2)
        return CGSize(width: itemWidth, height: itemHeight)
        
    }
}
