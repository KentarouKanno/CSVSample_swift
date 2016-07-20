//
//  A.swift
//  CSVSample_swift
//
//  Created by Kentarou on 2016/07/20.
//  Copyright © 2016年 KentarOu. All rights reserved.
//

import Foundation

class APIManager {
    
    class func  downloadCSVData(task: (success: Bool) -> () ) {
        
        // CSVダウンロード
        let url = NSURL(string: "http://www.kentar0u.sakura.ne.jp/data.csv")
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        let req = NSURLRequest(URL: url!)
        
        let task = session.dataTaskWithRequest(req, completionHandler: { (data, response, error) in
            
            if let data = data {
                
                // ダウンロード成功時
                if CSVManager().csvDataWriteToFile(data) {
                    // CSVデータファイル保存成功
                    task(success: true)
                } else {
                    task(success: false)
                }
            
            } else {
                // エラー処理
                print("Error!")
                task(success: false)
            }
        })
        task.resume()
    }
}