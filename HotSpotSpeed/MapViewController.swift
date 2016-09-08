//
//  MapViewController.swift
//  HotSpotSpeed
//
//  Created by Patrick Cooke on 9/8/16.
//  Copyright © 2016 Patrick Cooke. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {

    var locManager = LocationManager.sharedInstance
    var dataManager = DataManager.sharedInstance
    @IBOutlet weak var hsMapView    :   MKMapView!
    
    func setupMap() {
        hsMapView.delegate = self
        hsMapView.showsUserLocation = true
        hsMapView.userTrackingMode = .FollowWithHeading
        /* - Map Region not working yet
        let userLoc = hsMapView.userLocation.coordinate
        let mapSize = MKMapSize(width: 100.0, height: 100.0)
        let maprect = MKMapRect(origin: (MKMapPointForCoordinate(userLoc)), size: mapSize)
        hsMapView.mapRectThatFits(maprect)
        */
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hsMapView.showsUserLocation = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
