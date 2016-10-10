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
            let location = MKPointAnnotation() as! wifiPin
            location.speed = downSpeed
            location.coordinate = coords
            location.title = title
            location.subtitle = subtitle

            hsMapView.addAnnotation(location)
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if (annotation is MKUserLocation) {
            return nil
        }
        let reuseId = "test"

        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView!.image = UIImage(named:"unlockBlack")
            anView!.canShowCallout = true
            if annotation.isKindOfClass(wifiPin) {
//                if (anView > 1) {
//                    anView?.image = UIImage(named: "unlockBlack")
//                } else {
//                    anView?.image = UIImage(named: "unlockRed")
//                }
                
                
            }
            
            
        } else {
            anView!.annotation = annotation
        }
        
        return anView
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
        hsMapView.delegate = self
        
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
