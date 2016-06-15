//
//  ParallaxHeaderView.swift
//  prototype
//
//  Created by 한상현 on 2016. 5. 23..
//  Copyright © 2016년 한상현. All rights reserved.
//

import Foundation
import UIKit

class ParallaxHeaderView : UIViewController {
    let headerView: ParallaxHeaderView = ParallaxHeaderView.parallaxHeaderViewWithImage(UIImage(named: "YourImageName"), forSize: CGSizeMake(self.tableview.frame.size.height, 300)) as ParallaxHeaderView
    self.tableview.tableHeaderView = headerView
    
    func  scrollViewDidScroll(scrollView: UIScrollView) {
        let header: ParallaxHeaderView = self.tableview.tableHeaderView as ParallaxHeaderView
        header.layoutHeaderViewForScrollViewOffset(scrollView.contentOffset)
        
        self.tableview.tableHeaderView = header
    }
    
}