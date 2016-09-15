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
        hsMapView.userTrackingMode = .Follow
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(hsMapView.userLocation.coordinate,
                                                                  regionRadius*2.0,
                                                                  regionRadius*2.0)
        hsMapView.regionThatFits(coordinateRegion)
    }
    

    
    func displayEndpoints() {
        print("displaying endpoints")
        //let array = self.dataManager.hSArray
        //let count = array.count - 1
        
        for wifi in self.dataManager.hSArray {
            print("endpoint: \(wifi.hpLocName)")
            guard let lat = Double(wifi.hpLat) else {
                return
            }
            guard let lon = Double(wifi.hpLon) else {
                return
            }
            guard let title = wifi.hpSSIDName  else {
                return
            }
            guard let downSpeed = wifi.hpDown else {
                return
            }
            guard let upSpeed = wifi.hpUp else {
                return
            }
            let subtitle = "Down: \(downSpeed) Up: \(upSpeed)"
            let coords = CLLocationCoordinate2DMake(lat, lon)
            let location = MKPointAnnotation()
            location.coordinate = coords
            location.title = title
            location.subtitle = subtitle
            
            hsMapView.addAnnotation(location)
        }
    }
    
    //MARK: - reusable methods
    
    func reFetch () {
        dataManager.fetchData()
    }
    
    func fetchAndReload() {
        displayEndpoints()
        
    }

    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hsMapView.showsUserLocation = true
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupMap()
        displayEndpoints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
