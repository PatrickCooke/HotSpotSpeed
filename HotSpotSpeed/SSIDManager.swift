//
//  SSIDManager.swift
//  HotSpotSpeed
//
//  Created by Patrick Cooke on 1/10/17.
//  Copyright © 2017 Patrick Cooke. All rights reserved.
//

import UIKit
import SystemConfiguration.CaptiveNetwork

class SSIDManager: NSObject {
    
    var networkSSID : String?
    var currentSSID = ""
    
    func fetchSSIDInfo() ->  String {
        //var currentSSID = ""
        if let interfaces:CFArray = CNCopySupportedInterfaces() {
            for i in 0..<CFArrayGetCount(interfaces){
                let allInterfaceNames = CFArrayGetValueAtIndex(interfaces, i)
                let rec = unsafeBitCast(allInterfaceNames, AnyObject.self)
                let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)" as CFString)
                if unsafeInterfaceData != nil {
                    let interfaceData = unsafeInterfaceData! as Dictionary!
                    for dictData in interfaceData! {
                        if dictData.0 as! String == "SSID" {
                            currentSSID = dictData.1 as! String
                        }
                    }
                }
            }
        }
        networkSSID = currentSSID
        if let ssid = networkSSID {
            print("Inside FetchSSIDInfo function \(ssid)")
        } else {
            print("no network found")
        }
        return currentSSID
    }
    
    func printSSID() {
        defer {
            print("Inside printSSID func - \(currentSSID)")
        }
        fetchSSIDInfo()
    }
}
