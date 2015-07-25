//
//  TabSwitcherLayoutAttributes.swift
//  TabSwitcherViewDemo
//
//  Created by Amornchai Kanokpullwad on 7/26/2558 BE.
//  Copyright (c) 2558 zoonref. All rights reserved.
//

import UIKit

class TabSwitcherLayoutAttributes: UICollectionViewLayoutAttributes {

    var displayTransform: CATransform3D = CATransform3DIdentity
    
    override func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = super.copyWithZone(zone) as! TabSwitcherLayoutAttributes
        copy.displayTransform = displayTransform
        return copy
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        let attr = object as! TabSwitcherLayoutAttributes
        return super.isEqual(object) &&
            CATransform3DEqualToTransform(displayTransform, attr.displayTransform)
    }
    
}
