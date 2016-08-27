//
//  CustomCollectionViewFlowLayout.swift
//  CSVSample_swift
//
//  Created by Kentarou on 2016/08/27.
//  Copyright © 2016年 KentarOu. All rights reserved.
//

import UIKit

class CustomCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    let itemWidth : CGFloat = UIScreen.mainScreen().bounds.width - 100
    let itemLength: CGFloat = 300
    let minInteritemSpacing: CGFloat = 20
    let velocityThreshold   = 0.2
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepare()
    }
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        let currentPage = self.collectionView!.contentOffset.x / pageWidth()
        
        print(velocity.x)
        
        if fabs(Double(velocity.x)) > velocityThreshold {
            let nextPage = (velocity.x > 0.0) ? ceil(currentPage) : floor(currentPage)
            return CGPointMake((nextPage * pageWidth()), proposedContentOffset.y)
            
        } else {
            return CGPointMake((round(currentPage) * pageWidth()), proposedContentOffset.y)
        }
    }
    
    func pageWidth() -> CGFloat {
        return itemSize.width + minimumLineSpacing
    }
    
    func prepare() {
        self.itemSize = CGSizeMake(itemWidth, itemLength);
        self.minimumLineSpacing = minInteritemSpacing;
        self.scrollDirection = .Horizontal
        
        let horizontalInset = (UIScreen.mainScreen().bounds.size.width - itemWidth) / 2
        let verticalInset: CGFloat = 20
        
        self.sectionInset = UIEdgeInsetsMake(verticalInset, horizontalInset, verticalInset, horizontalInset);
    }

}
