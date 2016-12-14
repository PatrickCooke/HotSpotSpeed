//
//  ViewController.swift
//  HotSpotSpeed
//
//  Created by Patrick Cooke on 9/6/16.
//  Copyright © 2016 Patrick Cooke. All rights reserved.
//

import UIKit
import CoreLocation
import Crashlytics

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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return 99
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerview = UITableViewHeaderFooterView()
        headerview.contentView.backgroundColor = UIColor().AquaGreen()
        
        return headerview
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cCell", forIndexPath: indexPath) as! wifiTableCell
        
        switch indexPath.section {
        case 0:
            let selectedHP = locMaxArray[indexPath.row]

            if let ssidName = selectedHP.hpSSIDName {
                cell.SSID.text = "Network: \(ssidName)"
             }
            if let cityName = selectedHP.hpCity {
                if let stateName = selectedHP.hpState {
                    cell.City.text = "\(cityName), \(stateName)"
                }
            }
            if let locName = selectedHP.hpLocName {
                cell.locTitle.text = locName
            }
            if let down = selectedHP.hpDown {
                cell.downSpeed.text = "Download Speed: " + down + " Mbps"
            }
            if let down = selectedHP.hpUp {
                cell.upSpeed.text = "Upload Speed: " + down + " Mbps"
            }
            
            if let destlat = selectedHP.hpLat  {
                if let destlon = selectedHP.hpLon  {
                    let lattitude : CLLocationDegrees = Double(destlat)!
                    let longitude : CLLocationDegrees = Double(destlon)!
                    let destination :CLLocation = CLLocation(latitude: lattitude, longitude: longitude)
                    let myLoc = locManager.locManager.location
                    let distance = destination.distanceFromLocation(myLoc!)
                    let distInMiles = Double(distance)/1609.344
                    let distString = String(format:"%.1f", distInMiles)
                    cell.distFromMe.text = "\(distString) miles away"
                    
                }
            }
            
            return cell
        case 1:
            let selectedHP = locFasArray[indexPath.row]
            if let ssidName = selectedHP.hpSSIDName {
                cell.SSID.text = "Network: \(ssidName)"
            }
            if let cityName = selectedHP.hpCity {
                if let stateName = selectedHP.hpState {
                    cell.City.text = "\(cityName), \(stateName)"
                }
            }
            if let locName = selectedHP.hpLocName {
                cell.locTitle.text = locName
            }
            if let down = selectedHP.hpDown {
                cell.downSpeed.text = "Download Speed: " + down + " Mbps"
            }
            if let down = selectedHP.hpUp {
                cell.upSpeed.text = "Upload Speed: " + down + " Mbps"
            }
            
            if let destlat = selectedHP.hpLat  {
                if let destlon = selectedHP.hpLon  {
                    let lattitude : CLLocationDegrees = Double(destlat)!
                    let longitude : CLLocationDegrees = Double(destlon)!
                    let destination :CLLocation = CLLocation(latitude: lattitude, longitude: longitude)
                    let myLoc = locManager.locManager.location
                    let distance = destination.distanceFromLocation(myLoc!)
                    let distInMiles = Double(distance)/1609.344
                    let distString = String(format:"%.1f", distInMiles)
                    cell.distFromMe.text = "\(distString) miles away"
                    
                }
            }
            
            return cell

        case 2:
            let selectedHP = locMedArray[indexPath.row]
            if let ssidName = selectedHP.hpSSIDName {
                cell.SSID.text = "Network: \(ssidName)"
            }
            if let cityName = selectedHP.hpCity {
                if let stateName = selectedHP.hpState {
                    cell.City.text = "\(cityName), \(stateName)"
                }
            }
            if let locName = selectedHP.hpLocName {
                cell.locTitle.text = locName
            }
            if let down = selectedHP.hpDown {
                cell.downSpeed.text = "Download Speed: " + down + " Mbps"
            }
            if let down = selectedHP.hpUp {
                cell.upSpeed.text = "Upload Speed: " + down + " Mbps"
            }
            
            if let destlat = selectedHP.hpLat  {
                if let destlon = selectedHP.hpLon  {
                    let lattitude : CLLocationDegrees = Double(destlat)!
                    let longitude : CLLocationDegrees = Double(destlon)!
                    let destination :CLLocation = CLLocation(latitude: lattitude, longitude: longitude)
                    let myLoc = locManager.locManager.location
                    let distance = destination.distanceFromLocation(myLoc!)
                    let distInMiles = Double(distance)/1609.344
                    let distString = String(format:"%.1f", distInMiles)
                    cell.distFromMe.text = "\(distString) miles away"
                    
                }
            }
            
            return cell

        case 3:
            let selectedHP = locSloArray[indexPath.row]
            if let ssidName = selectedHP.hpSSIDName {
                cell.SSID.text = "Network: \(ssidName)"
            }
            if let cityName = selectedHP.hpCity {
                if let stateName = selectedHP.hpState {
                cell.City.text = "\(cityName), \(stateName)"
                }
            }
            if let locName = selectedHP.hpLocName {
                cell.locTitle.text = locName
            }
            if let down = selectedHP.hpDown {
                cell.downSpeed.text = "Download Speed: " + down + " Mbps"
            }
            if let down = selectedHP.hpUp {
                cell.upSpeed.text = "Upload Speed: " + down + " Mbps"
            }
            
            if let destlat = selectedHP.hpLat  {
                if let destlon = selectedHP.hpLon  {
                    let lattitude : CLLocationDegrees = Double(destlat)!
                    let longitude : CLLocationDegrees = Double(destlon)!
                    let destination :CLLocation = CLLocation(latitude: lattitude, longitude: longitude)
                    let myLoc = locManager.locManager.location
                    let distance = destination.distanceFromLocation(myLoc!)
                    let distInMiles = Double(distance)/1609.344
                    let distString = String(format:"%.1f", distInMiles)
                    cell.distFromMe.text = "\(distString) miles away"
                }
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
            return "Max Speed!!! Over 100 Mbps"
        case 1:
            return "Fast Internet 10-100 Mbps"
        case 2:
            return "Merh Internet 2-10 Mbps"
        case 3:
            return "Slow enough to avoid Under 2 Mbps"
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
    
    func amIOnline() {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            
            let alertController = UIAlertController(title: "No Internet Connection", message: "Please Make Sure Your Device Is Connected To The Internet", preferredStyle: .Alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                // ...
            }
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {
                // ...
            }
            
        }
    }
    
    @IBAction func crashButtonTapped(sender: AnyObject) {
        Crashlytics.sharedInstance().crash()
    }
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //amIOnline()
        locManager.setupLocationMonitoring()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(fetchAndReload), name: "datarcv", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reFetch), name: "saved", object: nil)
        self.navigationController?.navigationBar.barTintColor = UIColor().AquaGreen()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()

    }

}

