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
//                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "datarcv", object: nil))
                self.sortForSpeed(hotspotsArray)
            },
            error: { (fault: Fault!) -> Void in
                print("Server reported an error: \(fault)")
        })
    }
    
    func sortForSpeed(array: [HotSpot]){
        defer {
            print("slo \(sloArray.count), med \(medArray.count), fas \(fasArray.count), max \(maxArray.count)")
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "datarcv", object: nil))
        }
        var tempSloArray = [HotSpot]()
        var tempMedArray = [HotSpot]()
        var tempFasArray = [HotSpot]()
        var tempMaxArray = [HotSpot]()
        for spots in array {
            guard let speed = spots.hpDown else {
                return
            }
//            print("speed \(speed)")
            if (Float(speed) < 2) {
                tempSloArray.append(spots)
//                print("slow")
            } else if (Float(speed) < 10) {
                tempMedArray.append(spots)
//                print("med")
            } else if (Float(speed) < 100) {
                tempFasArray.append(spots)
//                print("fast")
            } else {
                tempMaxArray.append(spots)
//                print("wow")
            }
            self.sloArray = tempSloArray
            self.medArray = tempMedArray
            self.fasArray = tempFasArray
            self.maxArray = tempMaxArray
        }
    }
}
