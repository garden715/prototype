//
//  SearchViewController.swift
//  prototype
//
//  Created by seojungwon on 2016. 7. 6..
//  Copyright © 2016년 한상현. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    
    @IBOutlet weak var myContainer: UIView!
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print(searchBar.text!)
        
        let uvc = self.storyboard!.instantiateViewControllerWithIdentifier("myContainer") as! SearchContainerViewController
        
        uvc.searchText = searchBar.text as String!
        uvc.reloadInputViews()
        uvc.collectionView?.reloadData()
        searchBar.endEditing(true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
   
}
