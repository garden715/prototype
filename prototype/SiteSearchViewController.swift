//
//  siteSearchViewController.swift
//  prototype
//
//  Created by seojungwon on 2016. 7. 8..
//  Copyright © 2016년 한상현. All rights reserved.
//

import UIKit

class SiteSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, CustomSearchControllerDelegate {
    
    @IBOutlet weak var tblSearchResults: UITableView!
    var sites = [Site]()
    var filteredSites = [Site]()
    var shouldShowSearchResults = false
    var searchController: UISearchController!
    var customSearchController: CustomSearchController!
    var pageNumber = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblSearchResults.delegate = self
        tblSearchResults.dataSource = self
        loadListOfCountries()
        configureCustomSearchController()
        customSearchController.customSearchBar.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func dismiss() {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadListOfCountries() {
        tblSearchResults.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            return filteredSites.count
        }
        else {
            return sites.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("idCell", forIndexPath: indexPath)
        
        if shouldShowSearchResults {
            cell.textLabel?.text = filteredSites[indexPath.row].name
        }
        else {
            cell.textLabel?.text = sites[indexPath.row].name
        }
        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    func configureCustomSearchController() {
        customSearchController = CustomSearchController(searchResultsController: self,
                                                        searchBarFrame: CGRectMake(0.0, UIApplication.sharedApplication().statusBarFrame.size.height, tblSearchResults.frame.size.width, 45.0),
                                                        searchBarFont: UIFont.systemFontOfSize(16),
                                                        searchBarTextColor: UIColor.blackColor(),
                                                        searchBarTintColor: UIColor(colorLiteralRed: 1, green: 51/255.0, blue: 0, alpha: 1))
        
        
        customSearchController.customSearchBar.placeholder = "쇼핑몰 이름 검색"
        view.addSubview(customSearchController.customSearchBar)
        
        customSearchController.customDelegate = self
    }
    
    
    // MARK: UISearchBarDelegate functions
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        shouldShowSearchResults = true
        tblSearchResults.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        shouldShowSearchResults = false
        tblSearchResults.reloadData()
        dismiss()
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tblSearchResults.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    
    // MARK: UISearchResultsUpdating delegate function
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else {
            return
        }
        
        // Filter the data array and get only those countries that match the search text.
        filteredSites = sites.filter({ (country) -> Bool in
            let countryText: NSString = country.name
            let base: NSString = country.url
            
            let nameFound = (countryText.rangeOfString(searchString, options: NSStringCompareOptions.CaseInsensitiveSearch).location)
            let urlFound = (base.rangeOfString(searchString, options: NSStringCompareOptions.CaseInsensitiveSearch).location)
            
            return (nameFound  != NSNotFound) || (urlFound != NSNotFound)
        })
        
        // Reload the tableview.
        tblSearchResults.reloadData()
    }
    
    
    // MARK: CustomSearchControllerDelegate functions
    
    func didStartSearching() {
        shouldShowSearchResults = true
        tblSearchResults.reloadData()
    }
    
    
    func didTapOnSearchButton() {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tblSearchResults.reloadData()
        }
    }
    
    
    func didTapOnCancelButton() {
        shouldShowSearchResults = false
        tblSearchResults.reloadData()
        dismiss()
    }
    
    
    func didChangeSearchText(searchText: String) {
        // Filter the data array and get only those countries that match the search text.
        filteredSites = sites.filter({ (country) -> Bool in
            let countryText: NSString = country.name
            let base: NSString = country.url
            
            let nameFound = (countryText.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch).location)
            let urlFound = (base.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch).location)
            
            return (nameFound != NSNotFound) || (urlFound != NSNotFound)
        })
        
        // Reload the tableview.
        tblSearchResults.reloadData()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tblSearchResults.deselectRowAtIndexPath(indexPath, animated: true)
        let shoppingMall = filteredSites[indexPath.row]
        
        let uvc = self.storyboard!.instantiateViewControllerWithIdentifier("PhotoscollectionVC") as! PhotosCollectionViewController
        
        uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        
        print(shoppingMall.url)
        
        
        uvc.baseUrl = shoppingMall.url
        uvc.productPATH = shoppingMall.productPATH
        uvc.productTYPE = shoppingMall.productTYPE
        uvc.name = shoppingMall.name
        uvc.title = shoppingMall.name
        self.presentViewController(uvc, animated: true, completion: {})
        
    }

    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        if(segue.identifier=="siteView2")
//        {
//            let cell = sender as! UITableViewCell
//            
//            let path = self.tblSearchResults.indexPathForCell(cell)
//            
//            let param = self.filteredSites[path!.row]
//            
//            (segue.destinationViewController as? PhotosCollectionViewController)?.baseUrl = param.url
//            
//            (segue.destinationViewController as? PhotosCollectionViewController)?.productPATH = param.productPATH
//            (segue.destinationViewController as? PhotosCollectionViewController)?.productTYPE = param.productTYPE
//            (segue.destinationViewController as? PhotosCollectionViewController)?.title = param.name
//            (segue.destinationViewController as? PhotosCollectionViewController)?.name = param.name
//        }
//    }
}
