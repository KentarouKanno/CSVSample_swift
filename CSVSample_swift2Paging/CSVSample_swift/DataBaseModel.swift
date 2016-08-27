//
//  DataBaseModel.swift
//  CSVSample_swift
//
//  Created by KentarOu on 2016/08/19.
//  Copyright © 2016年 KentarOu. All rights reserved.
//

import Foundation
import RealmSwift

class DataBaseModel: Object {
    
    dynamic var sectionTitle = ""
    dynamic var eraText      = ""
    dynamic var eventText    = ""
    dynamic var eventImage   = ""
    
    func setDataFromArray(dataArray: Array<String>) {
        
        for (index, value) in dataArray.enumerate() {
            switch index {
            case 0: sectionTitle = value
            case 1: eraText      = value
            case 2: eventText    = value
            case 3: eventImage   = value.stringByReplacingOccurrencesOfString("\r", withString: "")
            default: break
            }
        }
    }
}