//
//  TabSwitcherLayout.swift
//  TabSwitcherViewDemo
//
//  Created by Amornchai Kanokpullwad on 7/26/2558 BE.
//  Copyright (c) 2558 zoonref. All rights reserved.
//

import UIKit

class TabSwitcherLayout: UICollectionViewFlowLayout {
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        sectionInset = UIEdgeInsetsMake(40, 0, 300, 0)
        itemSize =  CGSizeMake(UIScreen.mainScreen().bounds.size.width, 120)
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override class func layoutAttributesClass() -> AnyClass {
        return TabSwitcherLayoutAttributes.self
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        let attrs = super.layoutAttributesForElementsInRect(rect)
        return attrs?.map({
            let attr = $0 as! TabSwitcherLayoutAttributes
            attr.zIndex = attr.indexPath.item
            
            let distance = attr.frame.origin.y - self.collectionView!.contentOffset.y
            var t: CATransform3D = CATransform3DIdentity
            t.m34 = -1.0 / (500.0)
            
            let distancePercent = distance / self.collectionView!.bounds.size.height
            var angleConstant = 4 * distancePercent
            
            if distancePercent > 0.8 {
                angleConstant += (distancePercent - 0.8) * 5
            } else if distancePercent < 0.0 {
                let scale = 1 + (distancePercent / 5)
                t = CATransform3DScale(t, scale, scale, 1)
                t = CATransform3DTranslate(t, 0, -distancePercent * 100, 0)
            }
            
            t = CATransform3DRotate(t, -CGFloat(M_PI / Double(8 - angleConstant)), 1, 0, 0)
            t = CATransform3DScale(t, 0.95, 0.95, 1)
            attr.displayTransform = t
            return attr
        })
    }
}
