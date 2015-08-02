//
//  ViewController.swift
//  TabSwitcherViewDemo
//
//  Created by Amornchai Kanokpullwad on 7/26/2558 BE.
//  Copyright (c) 2558 zoonref. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TabSwitcherDataSource {
    
    @IBOutlet weak var tabSwitcherView: TabSwitcherView!
    
    private var size = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tabSwitcherView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func modeButtonClick(sender: AnyObject) {
        tabSwitcherView.switching = true
    }
    
    @IBAction func addButtonClick(sender: AnyObject) {
        size++
        tabSwitcherView.addTab()
    }
    
    // MARK: TabSwitcher DataSource
    
    func numberOfTabs() -> Int {
        return size
    }
    
    func viewForTabAtIndex(index: Int) -> UIView {
        return UIView()
    }
}

