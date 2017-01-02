//
//  OptionsPopOverViewController.swift
//  HotSpotSpeed
//
//  Created by Patrick Cooke on 1/2/17.
//  Copyright © 2017 Patrick Cooke. All rights reserved.
//

import UIKit

class OptionsPopOverViewController: UIViewController {

    @IBOutlet weak var sortSpeedOrProx: UISegmentedControl!
    @IBOutlet weak var sortDistance: UISegmentedControl!
    var optionManager = Options.sharedInstance
    
    
    @IBAction func setSortByOption(sender: AnyObject) {
        switch sender.selectedSegmentIndex {
        case 0:
            optionManager.sortMethod = 0
        case 1:
            optionManager.sortMethod = 1
        default:
            optionManager.sortMethod = 0
        }
    }
    
    @IBAction func setSortByDistance (sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            optionManager.listRange = 0.5
        case 1:
            optionManager.listRange = 1
        case 2:
            optionManager.listRange = 5
        case 3:
            optionManager.listRange = 10
        case 4:
            optionManager.listRange = 25
        default:
            optionManager.listRange = 25
        }
    }
    
    func setDistanceSegmentedIndex() {
        switch optionManager.listRange {
        case 0.5:
            self.sortDistance.selectedSegmentIndex = 0
        case 1:
            self.sortDistance.selectedSegmentIndex = 1
        case 5:
            self.sortDistance.selectedSegmentIndex = 2
        case 10:
            self.sortDistance.selectedSegmentIndex = 3
        case 25:
            self.sortDistance.selectedSegmentIndex = 4
        default:
            self.sortDistance.selectedSegmentIndex = 4
        }
    }
    
    override func viewDidLayoutSubviews() {
        setDistanceSegmentedIndex()
        self.sortSpeedOrProx.selectedSegmentIndex = optionManager.sortMethod
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSizeMake(375, 150)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
