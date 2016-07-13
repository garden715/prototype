//
//  PhotosDataManager.swift
//  GlacierScenics
//
//  Created by Todd Kramer on 1/30/16.
//  Copyright © 2016 Todd Kramer. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import FMDB

class PhotosDataManager {
    
    static var sharedManager = PhotosDataManager()
    private var photos = [GlacierScenic]()
    private var favoriteItems = [GlacierScenic]()
    private var searchItem = [GlacierScenic]()
    private var pageNum = 0
    private var pageNumberForSearch = 0
    
    let photoCache = AutoPurgingImageCache(
        memoryCapacity: 100 * 1024 * 1024,
        preferredMemoryUsageAfterPurge: 60 * 1024 * 1024
    )
    
    //MARK: - Read Data
    func allPhotos(tab: Int, str: String, pageNumber: Int) -> [GlacierScenic] {
        // 로컬 디비를 가져올 스트링일 경우 로컬의 데이터를 불러와 그 포토를 넘김
        if str=="favoriteItems" {
            return DatabaseManager.findContact()
        }
        
        if tab == 1 {
            if (!photos.isEmpty && pageNum == pageNumber){ return photos }
            
            pageNum = pageNumber;
            
            guard let data = NSData(contentsOfURL: NSURL(string:"http://52.38.132.199:3000/imgurl/\(str)/\(pageNumber)")!) else { return photos }
            
            do {
                let object = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                
                for photoInfo in (object as? [[String: AnyObject]])! {
                    let name = photoInfo["name"] as! String
                    let price = photoInfo["price"] as! Int
                    let urlString = photoInfo["img_thumb"] as! String
                    let baseurl = photoInfo["baseUrl"] as! String
                    let product_id = photoInfo["site_product_id"] as! Int
                    let glacierScenic = GlacierScenic(name: name, price: String(price), photoURLString: urlString, product_id: product_id, baseUrl: baseurl)
                    photos.append(glacierScenic)
                    
                }
            }catch {
                print("에러 ")
            }
            return photos
            
        }else {
            
            if (!searchItem.isEmpty && pageNumberForSearch == pageNumber){ return searchItem }
            
            pageNumberForSearch = pageNumber;
            
            guard let data = NSData(contentsOfURL: NSURL(string:"http://52.38.132.199:3000/search/\(str)")!) else { return searchItem }
            
            do {
                let object = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                
                for photoInfo in (object as? [[String: AnyObject]])! {
                    let name = photoInfo["name"] as! String
                    let price = photoInfo["price"] as! Int
                    let urlString = photoInfo["img_thumb"] as! String
                    let baseurl = photoInfo["baseUrl"] as! String
                    let product_id = photoInfo["site_product_id"] as! Int
                    let glacierScenic = GlacierScenic(name: name, price: String(price), photoURLString: urlString, product_id: product_id, baseUrl: baseurl)
                    searchItem.append(glacierScenic)
                    
                }
            }catch {
                print("에러 ")
            }
            return searchItem
        }
    }
    
    
    
    func dataPath() -> String {
        return NSBundle.mainBundle().pathForResource("GlacierScenics", ofType: "plist")!
    }
    
    //MARK: - Image Downloading
    
    func getNetworkImage(urlString: String, completion: (UIImage -> Void)) -> (Request) {
        return Alamofire.request(.GET, urlString).responseImage { (response) -> Void in
            guard let image = response.result.value else { return }
            completion(image)
            self.cacheImage(image, urlString: urlString)
        }
    }
    
    //MARK: = Image Caching
    
    func cacheImage(image: Image, urlString: String) {
        photoCache.addImage(image, withIdentifier: urlString)
    }
    
    func cachedImage(urlString: String) -> Image? {
        return photoCache.imageWithIdentifier(urlString)
    }
    
    func destroycache(){
        photos = [GlacierScenic]()
        pageNum = 0;
    }
    
    
}
