//
//  DataModel.swift
//  CSVSample_swift
//
//  Created by KentarOu on 2016/01/23.
//  Copyright © 2016年 KentarOu. All rights reserved.
//

import UIKit

class DataModel: NSObject {
    
    var sectionTitle = ""
    var eraText      = ""
    var eventText    = ""
    var eventImage: UIImage!

    func setDataFromArray(dataArray: Array<String>) {
        
        for (index, value) in dataArray.enumerate() {
            switch index {
            case 0: sectionTitle = value
            case 1: eraText      = value
            case 2: eventText    = value
            case 3: eventImage   = UIImage(named: value.stringByReplacingOccurrencesOfString("\r", withString: ""))
            default: break
            }
        }
    }
}
