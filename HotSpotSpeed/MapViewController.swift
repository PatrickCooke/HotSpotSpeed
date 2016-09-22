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
            let location = MKPointAnnotation()
            let pin = wifiPin()
            location.coordinate = coords
            location.title = title
            location.subtitle = subtitle
            if (Int(downSpeed) < 1) {
                pin.image = UIImage(named: "unlockedRed")
                //pin.speed = "slow"
                
            } else if (Int(downSpeed) <  10) {
                pin.image = UIImage(named: "unlockedYellow")
//                pin.speed = "med"
                
            } else if (Int(downSpeed) < 50) {
                pin.image = UIImage(named: "unlockedBlack")
//                pin.speed = "fast"
                
            } else {
                pin.image = UIImage(named: "unlockedBlack")
//                pin.speed = "lightning"
                
            }
            
            
            hsMapView.addAnnotation(location)
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation) {
            //if annotation is not an MKPointAnnotation (eg. MKUserLocation),
            //return nil so map draws default view for it (eg. blue dot)...
            return nil
        }
        
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView!.image = UIImage(named:"unlockBlack")
            anView!.canShowCallout = true
        }
        else {
            //we are re-using a view, update its annotation reference...
            anView!.annotation = annotation
        }
        
        return anView
    }
    
//    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
//        
//        if annotation is MKUserLocation {
//            return nil
//        } else {
//            
//            let reuseId = "pin"
//            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as?
//            wifiPin
//            
//            pinView = wifiPin(annotation: annotation, reuseIdentifier: reuseId)
//            
//            if let speed = pinView!.speed {
//                switch speed {
//                case "slow":
//                    pinView?.image = UIImage(named: "unlockRed")
//                default:
//                    pinView?.image = UIImage(named: "unlockBlack")
//                }
//                //pinView!.annotation = annotation
//                return pinView
//            }
//            return pinView
//        }
//    }
    
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
