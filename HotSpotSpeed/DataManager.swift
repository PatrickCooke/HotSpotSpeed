//
//  DataManager.swift
//  HotSpotSpeed
//
//  Created by Patrick Cooke on 9/8/16.
//  Copyright © 2016 Patrick Cooke. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    static let sharedInstance = DataManager()
    let locManager = LocationManager.sharedInstance
    var backendless = Backendless.sharedInstance()
    var optionsManager = Options.sharedInstance
    var hSArray     :   [HotSpot]!
    var sloArray    :   [HotSpot]!
    var medArray    :   [HotSpot]!
    var fasArray    :   [HotSpot]!
    var maxArray    :   [HotSpot]!
    var distArray   :   [HotSpot]!
    
    func fetchData() {
        //        print("fetch async")
        let dataStore = backendless.data.of(HotSpot.ofClass())
        dataStore.find(
            { (result: BackendlessCollection!) -> Void in
                let hotspotsArray = result.getCurrentPage() as! [HotSpot]
                self.hSArray = hotspotsArray
                self.CalcDistanceToPoint(hotspotsArray)
            },
            error: { (fault: Fault!) -> Void in
                print("Server reported an error: \(fault)")
        })
    }
    
    func CalcDistanceToPoint (HSArray: [HotSpot]) {
        defer {
            self.sortForSpeed(HSArray)
        }
        for hotspot in HSArray {
            if let destlat = hotspot.hpLat  {
                if let destlon = hotspot.hpLon  {
                    let lattitude : CLLocationDegrees = Double(destlat)!
                    let longitude : CLLocationDegrees = Double(destlon)!
                    let destination :CLLocation = CLLocation(latitude: lattitude, longitude: longitude)
                    if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
                        let myLoc = locManager.locManager.location
                        let distance = destination.distanceFromLocation((myLoc)!)
                        let distInMiles = Double(distance)/1609.344
                        hotspot.distanceToSelf = distInMiles
                    }
                }
            }
        }
    }
    
    func sortForSpeed(array: [HotSpot]){
        defer {
            //print("slo \(sloArray.count), med \(medArray.count), fas \(fasArray.count), max \(maxArray.count)")
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "datarcv", object: nil))
        }
        var tempSloArray = [HotSpot]()
        var tempMedArray = [HotSpot]()
        var tempFasArray = [HotSpot]()
        var tempMaxArray = [HotSpot]()
        var distSortArray = [HotSpot]()
        
        for hotspots in array {
            if hotspots.distanceToSelf < optionsManager.listRange {
                distSortArray.append(hotspots)
                distSortArray.sortInPlace({$1.distanceToSelf > $0.distanceToSelf})
            }
        }
        
        for spots in array {
            guard let speed = spots.hpDown else {
                return
            }
            if spots.distanceToSelf < optionsManager.listRange {
                if (Float(speed) < 2) {
                    tempSloArray.append(spots)
                    tempSloArray.sortInPlace({$0.hpDown > $1.hpDown})
                } else if (Float(speed) < 10) {
                    tempMedArray.append(spots)
                    tempMedArray.sortInPlace({$0.hpDown > $1.hpDown})
                } else if (Float(speed) < 100) {
                    tempFasArray.append(spots)
                    tempFasArray.sortInPlace({$0.hpDown > $1.hpDown})
                } else {
                    tempMaxArray.append(spots)
                    tempMaxArray.sortInPlace({$0.hpDown > $1.hpDown})
                }
            }
            
            self.sloArray = tempSloArray
            self.medArray = tempMedArray
            self.fasArray = tempFasArray
            self.maxArray = tempMaxArray
        }
        self.distArray = distSortArray
    }
}
