//
//  TabSwitcherView.swift
//  TabSwitcherViewDemo
//
//  Created by Amornchai Kanokpullwad on 7/26/2558 BE.
//  Copyright (c) 2558 zoonref. All rights reserved.
//

import UIKit

class TabSwitcherView: UIView {
    
    let maxNumberOfTabs = 5
    var focusingIndex = -1
    
    var switching = true
    
    var collectionView: UICollectionView!
    private let layout = TabSwitcherLayout()
    weak var dataSource: TabSwitcherDataSource?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.registerClass(TabViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        addSubview(collectionView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }
    
    // MARK: 
    
    func setSwithingModeEnable(enable: Bool) {
        if dataSource?.numberOfTabs() ?? 0 < 0 {
            return
        }
        
        let index = enable ? -1 : focusingIndex
        layout.setFocusingIndex(index)
    }

}

// MARK: - CollectionView DataSource & Delegate

extension TabSwitcherView: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = dataSource?.numberOfTabs() ?? 0
        focusingIndex = count > 0 ? -1 : -1
        layout.focusingIndex = focusingIndex
        return count
    }
    
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell",
            forIndexPath: indexPath) as! TabViewCell
        return cell
    }
    
}

extension TabSwitcherView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView,
        didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        layout.setFocusingIndex(indexPath.item)
        switching = false
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let count = min(dataSource!.numberOfTabs(), maxNumberOfTabs)
        let height = (bounds.size.height - layout.sectionInset.top - 37) / CGFloat(count)
        return CGSizeMake(bounds.size.width, height)
    }
    
}
