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
        if let locName = selectedHP.hpLocName {
        cell.textLabel!.text = locName
        }
        if let ssidName = selectedHP.hpSSIDName {
        cell.detailTextLabel!.text = ssidName
        }
        return cell
    }
    
    //MARK: - Fetch Method
    
    func findHotSpotsAsync() {
        print("fetch async")
        let dataStore = backendless.data.of(HotSpot.ofClass())
        dataStore.find(
            { (result: BackendlessCollection!) -> Void in
                let hotspots = result.getCurrentPage()
                for obj in hotspots {
                    print("\(obj)")
                    self.hotspotArray.append(obj as! HotSpot)
                }
                print(self.hotspotArray.count)
            },
            error: { (fault: Fault!) -> Void in
                print("Server reported an error: \(fault)")
        })
    }
    
    //MARK: - Reoccuring Method
    
    func fetchAndReload() {
        //hsTable.reloadData()
        findHotSpotsAsync()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAndReload()
        locManager.setupLocationMonitoring()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

