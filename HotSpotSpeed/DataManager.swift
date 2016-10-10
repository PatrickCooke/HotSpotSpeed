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
    var backendless = Backendless.sharedInstance()
    var hSArray     :   [HotSpot]!
    var sloArray    :   [HotSpot]!
    var medArray    :   [HotSpot]!
    var fasArray    :   [HotSpot]!
    var maxArray    :   [HotSpot]!
    
    func fetchData() {
        print("fetch async")
        let dataStore = backendless.data.of(HotSpot.ofClass())
        dataStore.find(
            { (result: BackendlessCollection!) -> Void in
                let hotspotsArray = result.getCurrentPage() as! [HotSpot]
                self.hSArray = hotspotsArray
                print(self.hSArray.count)
                
                self.sortForSpeed(hotspotsArray)
                
//                for spots in hotspotsArray {
//                    guard let speed = Int(spots.hpDown) else {
//                        return
//                    }
//                    if (Int(speed) < 2) {
//                        self.sloArray.append(spots)
//                    } else if (speed < 5) {
//                        self.medArray.append(spots)
//                    } else if (speed < 20) {
//                        self.fasArray.append(spots)
//                    } else {
//                        self.maxArray.append(spots)
//                    }
//                }
//                print("slo \(self.sloArray), med \(self.medArray), fas \(self.fasArray), max \(self.maxArray)")
                
                
//                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "datarcv", object: nil))
            },
            error: { (fault: Fault!) -> Void in
                print("Server reported an error: \(fault)")
        })
    }
    
    func sortForSpeed(array: [HotSpot]){
        for spots in array {
            guard let speed = spots.hpDown else {
                return}
                print("speed \(speed)")
                if (Int(speed) < 2) {
                    sloArray.append(spots)
                } else if (Int(speed) < 5) {
                    medArray.append(spots)
                } else if (Int(speed) < 20) {
                    fasArray.append(spots)
                } else {
                    maxArray.append(spots)
            }
            
        }
        print("slo \(self.sloArray), med \(self.medArray), fas \(self.fasArray), max \(self.maxArray)")
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "datarcv", object: nil))
    }
}
