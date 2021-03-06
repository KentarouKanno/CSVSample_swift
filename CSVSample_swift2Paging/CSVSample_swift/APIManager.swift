//
//  A.swift
//  CSVSample_swift
//
//  Created by Kentarou on 2016/07/20.
//  Copyright © 2016年 KentarOu. All rights reserved.
//

import Foundation

class APIManager {
    
    static let dataVersionKey = "Data_Version"
    
    class func csvDownloadCheckAPI(task: (isDownload: Bool) -> ()) {
        
        // CSV DownLoad Check
        let result = setRequest("http://www.kentar0u.sakura.ne.jp/version.json")
        let task = result.session.dataTaskWithRequest(result.request, completionHandler: { (data, response, error) in
            
            if let data = data {
                
                do {
                    // JSONをNSDictionaryに変換
                    let jsonDic = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as! NSDictionary
                    
                    if checkVersion(jsonDic) {
                         task(isDownload: true)
                    } else {
                        task(isDownload: false)
                    }
                    
                } catch {
                    // JSON Parse Error
                    print("JSON Parse Error : \(error)")
                }
            } else {
                // Network Error
                print("VersionCheck - Network Error!")
                
            }
            task(isDownload: false)
        })
        task.resume()
    }
    
    
    class func downloadCSVData(task: (success: Bool) -> ()) {
        
        // CSV DownLoad
        let result = setRequest("http://www.kentar0u.sakura.ne.jp/data.csv")
        let task = result.session.dataTaskWithRequest(result.request, completionHandler: { (data, response, error) in
            
            if let data = data {
                
                // DownLoad Success(DataBase書き込み)
                DataBaseManager.saveDataBase(data)
                self.updateCheckVersion()
                task(success: true)
                
                /*
                if CSVManager().csvDataWriteToFile(data) {
                    // CSVデータファイル保存成功
                    task(success: true)
                } else {
                    task(success: false)
                }
                */
            
            } else {
                // Network Error
                print("DownloadCSV - Network Error!")
                task(success: false)
            }
        })
        task.resume()
    }
    
    class func setRequest(urlString: String) -> (session: NSURLSession, request: NSMutableURLRequest) {
        
        let url = NSURL(string: urlString)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        let request = NSMutableURLRequest(URL: url!)
        request.cachePolicy = .ReloadIgnoringLocalCacheData
        request.timeoutInterval = 15
        return (session, request)
    }
    
    static var version: String = ""
    
    class func checkVersion(dict: NSDictionary) -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let newVersion = dict["data_version"] as? String {
            if let oldVersion = defaults.stringForKey(dataVersionKey) {
                if oldVersion == newVersion {
                    return false
                } else {
                    version = newVersion
                    return true
                }
            } else {
                version = newVersion
                return true
            }
        }
        return false
    }
    
    class func updateCheckVersion() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(version, forKey: dataVersionKey)
        defaults.synchronize()
    }
}