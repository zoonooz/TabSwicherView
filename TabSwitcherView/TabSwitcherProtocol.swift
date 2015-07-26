//
//  TabSwitcherProtocol.swift
//  TabSwitcherViewDemo
//
//  Created by Amornchai Kanokpullwad on 7/26/2558 BE.
//  Copyright (c) 2558 zoonref. All rights reserved.
//

import UIKit

@objc protocol TabSwitcherDataSource {
    
    func numberOfTabs() -> Int
    func viewForTabAtIndex(index: Int) -> UIView
    
}
