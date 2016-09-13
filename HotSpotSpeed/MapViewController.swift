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
    var wifiArray = [HotSpot]()
    @IBOutlet weak var hsMapView    :   MKMapView!
    
    func setupMap() {
        hsMapView.delegate = self
        hsMapView.showsUserLocation = true
        hsMapView.userTrackingMode = .FollowWithHeading
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(hsMapView.userLocation.coordinate,
                                                                  regionRadius*2.0,
                                                                  regionRadius*2.0)
        hsMapView.regionThatFits(coordinateRegion)
    }
    
    func setArray() {
        self.wifiArray = self.dataManager.hSArray
        print("array set with \(self.wifiArray.count) items")
    }
    
    func displayEndpoints(array: [HotSpot]) {
        let location = MKPointAnnotation()
        print("displaying endpoints")
        let count = array.count - 1
        for index in 0...count {
            print("endpoint #\(index)")
            guard let lat = Double(array[index].hpLat) else {
                return
            }
            guard let lon = Double(array[index].hpLon) else {
                return
            }
            guard let title = array[index].hpSSIDName  else {
                return
            }
            guard let downSpeed = array[index].hpDown else {
                return
            }
            guard let upSpeed = array[index].hpUp else {
                return
            }
            let subtitle = "Down: \(downSpeed) Up: \(upSpeed)"
            let coords = CLLocationCoordinate2DMake(lat, lon)
            location.coordinate = coords
            location.title = title
            location.subtitle = subtitle
            
            hsMapView.addAnnotation(location)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hsMapView.showsUserLocation = true
        setArray()
        setupMap()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        displayEndpoints(self.dataManager.hSArray)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
