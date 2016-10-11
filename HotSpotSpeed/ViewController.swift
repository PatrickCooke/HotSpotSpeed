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
    var locMaxArray = [HotSpot]()
    var locFasArray = [HotSpot]()
    var locMedArray = [HotSpot]()
    var locSloArray = [HotSpot]()
    
    //MARK: - Table Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return locMaxArray.count
        case 1:
            return locFasArray.count
        case 2:
            return locMedArray.count
        case 3:
            return locSloArray.count
        default:
            return 0
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        switch indexPath.section {
        case 0:
            let selectedHP = locMaxArray[indexPath.row]
            if let ssidName = selectedHP.hpSSIDName {
                cell.textLabel!.text = ssidName
            }
            if let down = selectedHP.hpDown {
                cell.detailTextLabel!.text = "Down: " + down + " mbps"
            }
            return cell
        case 1:
            let selectedHP = locFasArray[indexPath.row]
            if let ssidName = selectedHP.hpSSIDName {
                cell.textLabel!.text = ssidName
            }
            if let down = selectedHP.hpDown {
                cell.detailTextLabel!.text = "Down: " + down + " mbps"
            }
            return cell
        case 2:
            let selectedHP = locMedArray[indexPath.row]
            if let ssidName = selectedHP.hpSSIDName {
                cell.textLabel!.text = ssidName
            }
            if let down = selectedHP.hpDown {
                cell.detailTextLabel!.text = "Down: " + down + " mbps"
            }
            return cell
        case 3:
            let selectedHP = locSloArray[indexPath.row]
            if let ssidName = selectedHP.hpSSIDName {
                cell.textLabel!.text = ssidName
            }
            if let down = selectedHP.hpDown {
                cell.detailTextLabel!.text = "Down: " + down + " mbps"
            }
            return cell
        default:
            cell.textLabel?.text = "What What What???"
            return cell
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Max Speed!!!"
        case 1:
            return "Fast Internet"
        case 2:
            return "Merh Internet"
        case 3:
            return "Slow enough to make you hate life"
        default:
            return "How are you seeing this?"
        }
    }
    
 /*
     This is the basic table... use if all else fails
     
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
*/
    //MARK: - Reoccuring Method
    
    func reFetch () {
        dataManager.fetchData()
    }
    
    func fetchAndReload() {
        self.hotspotArray = dataManager.hSArray
        self.locMaxArray = dataManager.maxArray
        self.locFasArray = dataManager.fasArray
        self.locMedArray = dataManager.medArray
        self.locSloArray = dataManager.sloArray
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reFetch), name: "saved", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

