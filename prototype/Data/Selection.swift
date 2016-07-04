//
//  Selection.swift
//  prototype
//
//  Created by seojungwon on 2016. 7. 4..
//  Copyright © 2016년 한상현. All rights reserved.
//

import Foundation

struct Section {
    
    var heading : String
    var items : [String]
    
    init(title: String, objects : [String]) {
        
        heading = title
        items = objects
    }
}