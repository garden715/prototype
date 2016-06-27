//
//  DatabaseManager.swift
//  prototype
//
//  Created by seojungwon on 2016. 6. 22..
//  Copyright © 2016년 한상현. All rights reserved.
//

import UIKit
import Foundation
import FMDB

class DatabaseManager {
    
    static func saveData(url: String, type : String, path: String, product: GlacierScenic) -> Int{
        var returnData = 0
        /*
         연락처 정보 저장
         데이터베이스 파일을 열어 텍스트 필드 3개로부터 텍스트를 추출하고 INSERT SQL문을 구성하여 DB에 저장후 DB를 close처리한다.
         */
        let contactDB = FMDatabase(path: databasePath as String)
        if contactDB.open() {
            // SQL에 데이터를 입력하기 전 바로 입력하게 되면 "Optional('')"와 같은 문자열이 text문자열을 감싸게 되므로 뒤에 !을 붙여 옵셔널이 되지 않도록 한다.
            
            /*
             * BASEURL TEXT
             * PRODUCTTYPE TEXT,
             * PRODUCTPATH TEXT,
             * NAME TEXT,
             * PRICE TEXT,
             * IMAGEURL TEXT,
             * ID INT
             */
            let querySQL = "SELECT BASEURL, PRODUCTTYPE, PRODUCTPATH FROM FAVORITE WHERE BASEURL = '\(url)' and ID = \(product.product_id)"
            
            let results = contactDB.executeQuery(querySQL, withArgumentsInArray: nil)
            
            // 찜상품에 저장
            if results.next() == false {
                
                let insertSQL = "INSERT INTO FAVORITE (BASEURL, PRODUCTTYPE, PRODUCTPATH, NAME, PRICE, IMAGEURL, ID) VALUES ('\(url)', '\(type)', '\(path)', '\(product.name)', '\(product.price)', '\(product.photoURLString)', '\(product.product_id)')"
                
                print("[Save to DB] SQL to Insert => \(insertSQL)")
                let result = contactDB.executeUpdate(insertSQL, withArgumentsInArray: nil)
                
                if !result {
                    print("[4] Error : \(contactDB.lastErrorMessage())")
                } else {
                    // DB 저장 완료
                    print("[4] Success")
                    returnData = 1
                }
                
                
            }
            // 찜상품에서 삭제
            else {
                let deleteSQL = "DELETE FROM FAVORITE WHERE BASEURL = '\(url)' and ID = \(product.product_id)"
                
                let deleteResults = contactDB.executeUpdate(deleteSQL, withArgumentsInArray: nil)
                
                if !deleteResults {
                    print("[4] Error : \(contactDB.lastErrorMessage())")
                    
                } else {
                    // DB 저장 완료
                    print("[4] Success")
                    returnData = 2
                }
            }
            
            
        } else {
            print("[5] Error : \(contactDB.lastErrorMessage())")
        }
        
        return returnData
    }
    
    
    static func findContact() -> [GlacierScenic]  {
        var favoriteItems = [GlacierScenic]()
        /*
         Name textfield로부터 입력받은 이름 문자열 기준으로 DB로부터 해당 데이터 존재하는지 탐색
         */
        let contactDB = FMDatabase(path: databasePath as String)
        if contactDB.open() {
            // 검색 SQL을 작성할때도 textfield의 text를 바로 입력하게 되면 "Optional('')"와 같은 문자열이 text문자열을 감싸게 되므로 뒤에 !을 붙여 옵셔널이 되지 않도록 한다.
            let querySQL = "SELECT * FROM FAVORITE"
            
            let results:FMResultSet? = contactDB.executeQuery(querySQL, withArgumentsInArray: nil)
            
            while results?.next() == true {
                let name = results?.stringForColumn("NAME")
                let price = results?.stringForColumn("PRICE")
                let urlString = results?.stringForColumn("IMAGEURL")
                let baseurl = results?.stringForColumn("BASEURL")
                let product_id = Int((results?.intForColumn("ID"))!)
                let glacierScenic = GlacierScenic(name: name!, price: price!, photoURLString: urlString!, product_id: product_id, baseUrl: baseurl!)
                
                favoriteItems.append(glacierScenic)
            }
            contactDB.close()
        }else{
            print("[6] Error : \(contactDB.lastErrorMessage())")
        }
        return favoriteItems
    }
    
    static func findbaseUrl(g : GlacierScenic) -> HomepageInform  {
        var homepageInform : HomepageInform?
        /*
         Name textfield로부터 입력받은 이름 문자열 기준으로 DB로부터 해당 데이터 존재하는지 탐색
         */
        let contactDB = FMDatabase(path: databasePath as String)
        if contactDB.open() {
            // 검색 SQL을 작성할때도 textfield의 text를 바로 입력하게 되면 "Optional('')"와 같은 문자열이 text문자열을 감싸게 되므로 뒤에 !을 붙여 옵셔널이 되지 않도록 한다.
            let querySQL = "SELECT BASEURL, PRODUCTTYPE, PRODUCTPATH FROM FAVORITE WHERE BASEURL = '\(g.baseUrl)' and ID = \(g.product_id)"
            let results:FMResultSet? = contactDB.executeQuery(querySQL, withArgumentsInArray: nil)
            
            if results?.next() == true {
                let baseURL = results?.stringForColumn("BASEURL")
                let proType = results?.stringForColumn("PRODUCTTYPE")
                let proPath = results?.stringForColumn("PRODUCTPATH")
                
                homepageInform = HomepageInform(baseUrl:baseURL!, proType:proType!, proPath:proPath!)
            } else {
                homepageInform = HomepageInform(baseUrl: "AA", proType: "AA", proPath: "AA")
            }
            contactDB.close()
        }else{
            print("[6] Error : \(contactDB.lastErrorMessage())")
        }
        return homepageInform!
    }
    
    static var databasePath = NSString()
    
    static func loadDatabase() {
        let filemgr = NSFileManager.defaultManager()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir = dirPaths[0] as String
        databasePath = docsDir.stringByAppendingString("/favorite.db")
        
        if !filemgr.fileExistsAtPath(databasePath as String) {
            
            // FMDB 인스턴스를 이용하여 DB 체크
            let contactDB = FMDatabase(path:databasePath as String)
            if contactDB == nil {
                print("[1] Error : \(contactDB.lastErrorMessage())")
            }
            
            // DB 오픈
            if contactDB.open(){
                // 테이블 생성처리
                let sql_stmt = "CREATE TABLE IF NOT EXISTS FAVORITE ( BASEURL TEXT , PRODUCTTYPE TEXT, PRODUCTPATH TEXT, NAME TEXT, PRICE TEXT, IMAGEURL TEXT, ID INT)"
                if !contactDB.executeStatements(sql_stmt) {
                    print("[2] Error : \(contactDB.lastErrorMessage())")
                }
                contactDB.close()
            }else{
                print("[3] Error : \(contactDB.lastErrorMessage())")
            }
        }else{
            print("[1] SQLite 파일 존재!!")
        }
        
    }
}