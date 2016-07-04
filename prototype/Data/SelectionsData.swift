//
//  SelectionsData.swift
//  prototype
//
//  Created by seojungwon on 2016. 7. 4..
//  Copyright © 2016년 한상현. All rights reserved.
//

import Foundation

class SectionsData {
    
    let support = Section(title: "지원", objects: ["문제신고", "이용가이드"])
    let information = Section(title: "정보", objects: ["공지사항", "앱정보","안뇽"])
    
    
    func getSectionsFromData() -> [Section] {
        
        // you could replace the contents of this function with an HTTP GET, a database fetch request,
        // or anything you like, as long as you return an array of Sections this program will
        // function the same way.
        
        var sectionsArray = [Section]()
        
        sectionsArray.append(support)
        sectionsArray.append(information)

        
        return sectionsArray
    }
}