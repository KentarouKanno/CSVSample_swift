//
//  DetailCollectionViewCell.swift
//  CSVSample_swift
//
//  Created by KentarOu on 2016/01/23.
//  Copyright © 2016年 KentarOu. All rights reserved.
//

import UIKit

class DetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailLabel    : UILabel!
    
    var detailData: DataModel! {
        didSet {
            detailImageView.image = detailData.eventImage
            detailLabel.text = "\(detailData.sectionTitle) \(detailData.eraText) \(detailData.eventText)"
        }
    }
}
