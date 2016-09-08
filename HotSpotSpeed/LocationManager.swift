//
//  LocationManager.swift
//  WalkingToursApp
//
//  Created by Patrick Cooke on 6/16/16.
//  Copyright © 2016 Patrick Cooke. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: NSObject,CLLocationManagerDelegate {
    static let sharedInstance = LocationManager()
    var locManager = CLLocationManager()
    
    
    //MARK: - Location Methods
    
    func turnOnLocationMonitoring() {
        locManager.startUpdatingLocation()
        locManager.startUpdatingHeading()
    }
    
    func setupLocationMonitoring() {
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locManager.startUpdatingLocation()
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager .authorizationStatus() {
            case .AuthorizedAlways:
                turnOnLocationMonitoring()
                break
            case .AuthorizedWhenInUse:
                turnOnLocationMonitoring()
                break
            case .NotDetermined:
                locManager .requestWhenInUseAuthorization()
                locManager .requestAlwaysAuthorization()
                break
            case .Restricted:
                break
            case .Denied:
                break
            }
        } else {
        }
    }
    
}
