//
//  SelectionsData.swift
//  prototype
//
//  Created by seojungwon on 2016. 7. 4..
//  Copyright © 2016년 한상현. All rights reserved.
//

import Foundation

class SectionsData {
    
    let support = Section(title: "지원", objects: ["공지사항", "이용가이드"])
    
    let report = Section(title: "문의", objects: ["문의/건의사항"])
    
    let information = Section(title: "정보", objects: ["앱정보"])
    

    func getSectionsFromData() -> [Section] {
        
        // you could replace the contents of this function with an HTTP GET, a database fetch request,
        // or anything you like, as long as you return an array of Sections this program will
        // function the same way.
        
        var sectionsArray = [Section]()
        
        sectionsArray.append(support)
        sectionsArray.append(report)
        sectionsArray.append(information)

        
        return sectionsArray
    }
}