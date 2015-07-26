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
        tabSwitcherView.setSwithingModeEnable(!tabSwitcherView.switching)
    }
    
    // MARK: TabSwitcher DataSource
    
    func numberOfTabs() -> Int {
        return 10
    }
    
    func viewForTabAtIndex(index: Int) -> UIView {
        return UIView()
    }
}

