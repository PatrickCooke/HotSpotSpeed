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
    var hSArray    :   [HotSpot]!
    
    func fetchData() {
        print("fetch async")
        let dataStore = backendless.data.of(HotSpot.ofClass())
        dataStore.find(
            { (result: BackendlessCollection!) -> Void in
                let hotspots = result.getCurrentPage()
                self.hSArray = hotspots as! [HotSpot]
//                for obj in hotspots {
////                    print("\(obj)")
//                    self.hSArray.append(obj as! HotSpot)
//                }
                print(self.hSArray.count)
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "datarcv", object: nil))
            },
            error: { (fault: Fault!) -> Void in
                print("Server reported an error: \(fault)")
        })
    }
}
