//
//  ViewController.swift
//  HotSpotSpeed
//
//  Created by Patrick Cooke on 9/6/16.
//  Copyright © 2016 Patrick Cooke. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var locManager = LocationManager.sharedInstance
    var dataManager = DataManager.sharedInstance
    let backendless = Backendless.sharedInstance()
    @IBOutlet private weak var hsTable  :UITableView!
    var hotspotArray = [HotSpot]()
    
    //MARK: - Table Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotspotArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let selectedHP = hotspotArray[indexPath.row]
        if let ssidName = selectedHP.hpSSIDName {
        cell.textLabel!.text = ssidName
        }
        if let down = selectedHP.hpDown {
        cell.detailTextLabel!.text = "Down: " + down + " mbps"
        }
        return cell
    }
    
    //MARK: - Reoccuring Method
    
    func fetchAndReload() {
        self.hotspotArray = dataManager.hSArray
        print("array loaded")
        defer {
            hsTable.reloadData()
            print("table loaded")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locManager.setupLocationMonitoring()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(fetchAndReload), name: "datarcv", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

