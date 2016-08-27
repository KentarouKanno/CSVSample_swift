//
//  DataBaseManager.swift
//  CSVSample_swift
//
//  Created by KentarOu on 2016/08/19.
//  Copyright © 2016年 KentarOu. All rights reserved.
//

import UIKit
import RealmSwift

class DataBaseManager: NSObject {
    
    typealias DataArrayType = (sectionTitle: [String],sectionData: [[DataBaseModel]], allDataArray: [DataBaseModel])
    
    // DataBaseに保存
    class func saveDataBase(data: NSData) {
        
        let csv = NSString(data: data, encoding: NSShiftJISStringEncoding)
        let lines = csv?.componentsSeparatedByString("\n")
        
        for row in lines! {
            
            let items = row.componentsSeparatedByString(",")
            
            let realm = try! Realm()
            
            let data =  DataBaseModel()
            data.setDataFromArray(items)
            
            try! realm.write {
                realm.add(data)
            }
        }
    }
    
    // Dataがあるかどうかのチェック
    class func existData() -> Bool {
        let realm = try! Realm()
        return !Array(realm.objects(DataBaseModel)).isEmpty
    }
    
    // DataBaseから読み込み
    class func readDataBase() -> DataArrayType {
        
        var sectionTitle = [String]()
        var sectionData  = [[DataBaseModel]]()
        var allDataArray = [DataBaseModel]()
        
        
        let realm = try! Realm()
        
        // 全てのデータ取得
        allDataArray = Array(realm.objects(DataBaseModel))
        sectionTitle = allDataArray.map({ (value) -> String in
            return value.sectionTitle
        })
        
        // タイトルデータを生成
        let orderedSet = NSOrderedSet(array: sectionTitle)
        sectionTitle = orderedSet.array as! [String]
        
        // タイトルからセクションデータを取得
        for title in sectionTitle {
            sectionData += [Array(realm.objects(DataBaseModel).filter("sectionTitle == '\(title)'"))]
        }
        
        return (sectionTitle,sectionData,allDataArray)
    }
}
