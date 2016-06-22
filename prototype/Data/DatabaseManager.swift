//
//  DatabaseManager.swift
//  prototype
//
//  Created by seojungwon on 2016. 6. 22..
//  Copyright © 2016년 한상현. All rights reserved.
//

import Foundation
import FMDB

class DatabaseManager {
    
    static func saveData(sender: AnyObject) {
        /*
         연락처 정보 저장
         데이터베이스 파일을 열어 텍스트 필드 3개로부터 텍스트를 추출하고 INSERT SQL문을 구성하여 DB에 저장후 DB를 close처리한다.
         */
        let contactDB = FMDatabase(path: databasePath as String)
        if contactDB.open() {
            print("[Save to DB] Name : \(name.text) | Address : \(address.text) | Phone : \(phone.text)")
            // SQL에 데이터를 입력하기 전 바로 입력하게 되면 "Optional('')"와 같은 문자열이 text문자열을 감싸게 되므로 뒤에 !을 붙여 옵셔널이 되지 않도록 한다.
            let insertSQL = "INSERT INTO CONTACTS (name, address, phone) VALUES ('\(name.text!)', '\(address.text!)', '\(phone.text!)')"
            print("[Save to DB] SQL to Insert => \(insertSQL)")
            let result = contactDB.executeUpdate(insertSQL, withArgumentsInArray: nil)
            
            if !result {
                status.text = "Failed to add contact"
                print("[4] Error : \(contactDB.lastErrorMessage())")
            }else{
                // DB 저장 완료후 모든 TextField 초기화 처리
                status.text = "Contact Added"
                name.text = ""
                address.text = ""
                phone.text = ""
            }
        }else{
            print("[5] Error : \(contactDB.lastErrorMessage())")
        }
    }
    
//    
//    static func findContact(sender: AnyObject) {
//        /*
//         Name textfield로부터 입력받은 이름 문자열 기준으로 DB로부터 해당 데이터 존재하는지 탐색
//         */
//        let contactDB = FMDatabase(path: databasePath as String)
//        if contactDB.open() {
//            // 검색 SQL을 작성할때도 textfield의 text를 바로 입력하게 되면 "Optional('')"와 같은 문자열이 text문자열을 감싸게 되므로 뒤에 !을 붙여 옵셔널이 되지 않도록 한다.
//            let querySQL = "SELECT address, phone FROM CONTACTS WHERE name = '\(name.text!)'"
//            print("[Find from DB] SQL to find => \(querySQL)")
//            let results:FMResultSet? = contactDB.executeQuery(querySQL, withArgumentsInArray: nil)
//            if results?.next() == true {
//                address.text = results?.stringForColumn("address")
//                phone.text = results?.stringForColumn("phone")
//                status.text = "Record Found"
//            }else{
//                status.text = "Record not Found"
//                address.text = ""
//                phone.text = ""
//            }
//            contactDB.close()
//        }else{
//            print("[6] Error : \(contactDB.lastErrorMessage())")
//        }
//        
//    }
    
    static var databasePath = NSString()
    
    static func loadDatabase {
        let filemgr = NSFileManager.defaultManager()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir = dirPaths[0] as String
        databasePath = docsDir.stringByAppendingString("/contacts.db")
        
        if !filemgr.fileExistsAtPath(databasePath as String) {
            
            // FMDB 인스턴스를 이용하여 DB 체크
            let contactDB = FMDatabase(path:databasePath as String)
            if contactDB == nil {
                print("[1] Error : \(contactDB.lastErrorMessage())")
            }
            
            // DB 오픈
            if contactDB.open(){
                // 테이블 생성처리
                let sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS ( ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)"
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