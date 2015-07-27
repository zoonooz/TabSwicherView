//
//  TabSwitcherLayout.swift
//  TabSwitcherViewDemo
//
//  Created by Amornchai Kanokpullwad on 7/26/2558 BE.
//  Copyright (c) 2558 zoonref. All rights reserved.
//

import UIKit

class TabSwitcherLayout: UICollectionViewFlowLayout {
    
    var focusingIndex: Int = -1
    
    private var latestTransform3D: CATransform3D?
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return focusingIndex < 0
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
            attr.transform = CGAffineTransformIdentity
            attr.displayTransform = t
            
            return attr
        })
    }
    
    // MARK: - Focusing
    
    func setFocusingIndex(index: Int, animated: Bool = true) {
        if index == focusingIndex {
            return
        }
        
        if index < 0 {
            collectionView!.scrollEnabled = true
            let prevIndex = self.focusingIndex
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                let visibleCells = self.collectionView!.visibleCells() as! [TabViewCell]
                for cell in visibleCells {
                    let cellIndex = self.collectionView!.indexPathForCell(cell)!.item
                    let offset = self.collectionView!.contentOffset.y
                    if cellIndex < prevIndex {
                        cell.transform = CGAffineTransformIdentity
                    } else if cellIndex > prevIndex {
                        cell.transform = CGAffineTransformIdentity
                    } else {
                        cell.transform = CGAffineTransformIdentity
                        cell.displayView.layer.transform = self.latestTransform3D!
                        cell.gradientView.alpha = 1
                    }
                }
                
            }, completion: { (finished) -> Void in
                self.focusingIndex = -1
            })
            return
        }
        
        collectionView!.scrollEnabled = false
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            let visibleCells = self.collectionView!.visibleCells() as! [TabViewCell]
            for cell in visibleCells {
                let cellIndex = self.collectionView!.indexPathForCell(cell)!.item
                let offset = self.collectionView!.contentOffset.y
                if cellIndex < index {
                    let newY = self.collectionView!.bounds.size.height
                    cell.transform = CGAffineTransformMakeTranslation(0, -newY)
                } else if cellIndex > index {
                    let newY = self.collectionView!.bounds.size.height
                    cell.transform = CGAffineTransformMakeTranslation(0, newY)
                } else {
                    let newY = offset - cell.frame.origin.y
                    cell.transform = CGAffineTransformMakeTranslation(0, newY)
                    
                    self.latestTransform3D = cell.displayView.layer.transform
                    cell.displayView.layer.transform = CATransform3DIdentity
                    
                    cell.gradientView.alpha = 0
                }
            }
        }, completion: { (finished) -> Void in
            self.focusingIndex = index
        })
    }
    
}
