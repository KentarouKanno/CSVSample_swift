//
//  CSVManager.swift
//  CSVSample_swift
//
//  Created by KentarOu on 2016/01/23.
//  Copyright © 2016年 KentarOu. All rights reserved.
//

import UIKit

class CSVManager: NSObject {
    
    typealias ArrayType = (sectionTitle: [String],sectionData: [[DataModel]], allDataArray: [DataModel])
    let csvPath = "/data.csv"
    let fileManager = NSFileManager.defaultManager()
    
    func csvDataWriteToFile(data: NSData) -> Bool {
        if let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first {
            let filePath = documentsPath + csvPath
            data.writeToFile(filePath, atomically: true)
            return true
        }
        return false
    }
    
    func CSVFileExistsAtPath() -> Bool {
        if let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first {
            let filePath = documentsPath + csvPath
            return fileManager.fileExistsAtPath(filePath)
        }
        return false
    }
    
    func copyResourceBundleToDocument() {
        
        if let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first {
            let filePath = documentsPath + csvPath
            if !fileManager.fileExistsAtPath(filePath) {
                
                if let csvFile = NSBundle.mainBundle().pathForResource("data", ofType: "csv") {
                    let csvData = NSData(contentsOfFile: csvFile)
                    csvData?.writeToFile(filePath, atomically: true)
                }
            }
        }
    }
    
    func generateCSVDataFromDocument() -> ArrayType {
        
        var sectionTitle = [String]()
        var sectionData  = [[DataModel]]()
        var allDataArray = [DataModel]()
        
        if let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first {
            let csvFile = path + csvPath
            
            if let csvData = NSData(contentsOfFile: csvFile) {
                
                let csv = NSString(data: csvData, encoding: NSShiftJISStringEncoding)
                let lines = csv?.componentsSeparatedByString("\n")
                
                var listDataArray = [DataModel]()
                var title = ""
                
                for row in lines! {
                    
                    let items = row.componentsSeparatedByString(",")
                    
                    let data = DataModel()
                    data.setDataFromArray(items)
                    
                    if title.characters.count == 0 {
                        title = data.sectionTitle
                        sectionTitle.append(title)
                    }
                    
                    if title == data.sectionTitle {
                        listDataArray.append(data)
                    } else {
                        title = data.sectionTitle
                        sectionTitle.append(title)
                        
                        sectionData.append(listDataArray)
                        
                        listDataArray = [DataModel]()
                        listDataArray.append(data)
                    }
                    allDataArray.append(data)
                }
                sectionData.append(listDataArray)
            }
        }
        return (sectionTitle,sectionData,allDataArray)
    }
    
}
