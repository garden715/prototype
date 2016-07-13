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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblSearchResults.delegate = self
        tblSearchResults.dataSource = self
        loadListOfCountries()
        print(sites.count)
        configureCustomSearchController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func dismiss(sender: AnyObject) {
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
            print(filteredSites[indexPath.row].name)
        }
        else {
            cell.textLabel?.text = sites[indexPath.row].name
            print(sites[indexPath.row].name)
        }
        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        
        // Place the search bar view to the tableview headerview.
        tblSearchResults.tableHeaderView = searchController.searchBar
    }
    
    
    func configureCustomSearchController() {
        customSearchController = CustomSearchController(searchResultsController: self, searchBarFrame: CGRectMake(0.0, 0.0, tblSearchResults.frame.size.width, 50.0), searchBarFont: UIFont(name: "Futura", size: 16.0)!, searchBarTextColor: UIColor(red: 1, green: 0.3, blue: 0, alpha: 1), searchBarTintColor: UIColor(red: 1, green: 0.3, blue: 0, alpha: 1))
        
        customSearchController.customSearchBar.placeholder = "Search in this awesome bar..."
        tblSearchResults.tableHeaderView = customSearchController.customSearchBar
        
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
            
            var nameFound = (countryText.rangeOfString(searchString, options: NSStringCompareOptions.CaseInsensitiveSearch).location)
            var urlFound = (base.rangeOfString(searchString, options: NSStringCompareOptions.CaseInsensitiveSearch).location)
            
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
    }
    
    
    func didChangeSearchText(searchText: String) {
        // Filter the data array and get only those countries that match the search text.
        filteredSites = sites.filter({ (country) -> Bool in
            let countryText: NSString = country.name
            let base: NSString = country.url
            
            var nameFound = (countryText.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch).location)
            var urlFound = (base.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch).location)
            
            return (nameFound  != NSNotFound) || (urlFound != NSNotFound)
        })
        
        // Reload the tableview.
        tblSearchResults.reloadData()
    }
}
