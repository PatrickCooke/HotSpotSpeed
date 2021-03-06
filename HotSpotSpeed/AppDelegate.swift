//
//  AppDelegate.swift
//  HotSpotSpeed
//
//  Created by Patrick Cooke on 9/6/16.
//  Copyright © 2016 Patrick Cooke. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let APP_ID = "78344749-E1A4-2316-FFF6-1F0E6D11A200"
    let SECRET_KEY = "960102E6-D2E0-110B-FF69-4BBBED912C00"
    let VERSION_NUM = "v1"
    let mapsAPI = "AIzaSyCo36p2PB6wwKHnjLNcEHkmB95r0nIBIZU"
    let placesAPI = "AIzaSyAS166OTTY9ztWc-DDKWCLDk33_ZhfY-4Q"
    let emergencyKey = "AIzaSyBMtIxtyZd9fVu8bxHLWh8PF5D-B8LwHuI"
    
    var backendless = Backendless.sharedInstance()
    var dataManager = DataManager.sharedInstance
    var optionsmanager = Options.sharedInstance
    
    var window: UIWindow?
    
    private func cutomizedAppearance() {
        UITabBar.appearance().barTintColor = UIColor().AquaGreen()
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        
        UINavigationBar.appearance().backgroundColor = UIColor.greenColor()
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        dataManager.fetchData()
        cutomizedAppearance()
        GMSServices.provideAPIKey(emergencyKey)
        GMSPlacesClient.provideAPIKey(emergencyKey)
        Fabric.with([Crashlytics.self])
        optionsmanager.listRange = 4000
        optionsmanager.sortMethod = 0
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

