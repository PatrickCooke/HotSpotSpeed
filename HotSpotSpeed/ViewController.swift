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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate {

    var locManager = LocationManager.sharedInstance
    var dataManager = DataManager.sharedInstance
    let backendless = Backendless.sharedInstance()
    let optionsManager = Options.sharedInstance
    @IBOutlet private weak var hsTable  :UITableView!
    var hotspotArray = [HotSpot]()
    var locMaxArray = [HotSpot]()
    var locFasArray = [HotSpot]()
    var locMedArray = [HotSpot]()
    var locSloArray = [HotSpot]()
    var locDistArray =   [HotSpot]()
    
    
    
    
    //MARK: - Popover control 
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segue" {
            let destController = segue.destinationViewController as! OptionsPopOverViewController
            destController.popoverPresentationController?.delegate = self
        }
    }
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        dataManager.CalcDistanceToPoint(dataManager.hSArray)
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .None
    }
    
    
    //MARK: - Sort Method
    
    /*
    @IBAction func changeSort(sender:UIBarButtonItem) {
        let sort = optionsManager.sortMethod
        if sort == 0 {
            sort = 1
            reLoadTable()
        } else {
            sort = 0
            reLoadTable()
        }
    }
    */
    //MARK: - Table Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let sort = optionsManager.sortMethod
        switch sort {
        case 0:
            return 4
        case 1:
            return 1
        default:
            return 1
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sort = optionsManager.sortMethod
        switch sort {
        case 0:
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
        case 1:
            return locDistArray.count
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
        let sort = optionsManager.sortMethod
        let cell = tableView.dequeueReusableCellWithIdentifier("cCell", forIndexPath: indexPath) as! wifiTableCell
        
        switch sort {
        case 0:
        
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
            /*
            if let destlat = selectedHP.hpLat  {
                if let destlon = selectedHP.hpLon  {
                    let lattitude : CLLocationDegrees = Double(destlat)!
                    let longitude : CLLocationDegrees = Double(destlon)!
                    let destination :CLLocation = CLLocation(latitude: lattitude, longitude: longitude)
                    if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
                        let myLoc = locManager.locManager.location
                        let distance = destination.distanceFromLocation((myLoc)!)
                        let distInMiles = Double(distance)/1609.344
                        let distString = String(format:"%.1f", distInMiles)
                        cell.distFromMe.text = "\(distString) miles away"
                    }
                    
                    
                }
            }
            */
            if let dist = selectedHP.distanceToSelf {
                let distString = String(format:"%.1f", dist)
                cell.distFromMe.text = "\(distString) miles away"
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
            
            if let dist = selectedHP.distanceToSelf {
                let distString = String(format:"%.1f", dist)
                cell.distFromMe.text = "\(distString) miles away"
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
            
            if let dist = selectedHP.distanceToSelf {
                let distString = String(format:"%.1f", dist)
                cell.distFromMe.text = "\(distString) miles away"
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
            
            if let dist = selectedHP.distanceToSelf {
                let distString = String(format:"%.1f", dist)
                cell.distFromMe.text = "\(distString) miles away"
            }
            
            return cell
        default:
            cell.textLabel?.text = "What What What???"
            return cell
        }
        case 1:
            let selectedHP = locDistArray[indexPath.row]
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
            if let dist = selectedHP.distanceToSelf {
                let distString = String(format:"%.1f", dist)
                cell.distFromMe.text = "\(distString) miles away"
            }
            return cell
        default:
            cell.textLabel!.text = "You Shouldn't see this"
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sort = optionsManager.sortMethod
        switch sort {
        case 0:
            
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
        case 1:
            return ""
        default:
            return ""
        }
    }
    
    //MARK: - Reoccuring Method
    
    func reFetch () {
        dataManager.fetchData()
    }
    
    func reLoadTable() {
        hsTable.reloadData()
    }
    
    func fetchAndReload() {
        self.hotspotArray = dataManager.hSArray
        self.locMaxArray = dataManager.maxArray
        self.locFasArray = dataManager.fasArray
        self.locMedArray = dataManager.medArray
        self.locSloArray = dataManager.sloArray
        self.locDistArray = dataManager.distArray
//        print("array loaded")
        defer {
            hsTable.reloadData()
//            print("table loaded")
        }
        
    }

    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locManager.setupLocationMonitoring()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(fetchAndReload), name: "datarcv", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reFetch), name: "saved", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reFetch), name: "locationOn", object: nil)
        self.navigationController?.navigationBar.barTintColor = UIColor().AquaGreen()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}
/*
extension UIPopoverControllerDelegate {
    //MARK: - Popover methods
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
}
*/
