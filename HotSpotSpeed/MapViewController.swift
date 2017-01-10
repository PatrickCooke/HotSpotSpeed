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
import GoogleMaps

class MapViewController: UIViewController, MKMapViewDelegate, GMSMapViewDelegate {

    var locManager = LocationManager.sharedInstance
    var dataManager = DataManager.sharedInstance
    var wifiArray = [HotSpot]()
    //@IBOutlet weak var hsMapView    :   MKMapView!
    @IBOutlet weak var GMapView : GMSMapView!
    
    func setupGMap(){
        if let lat = locManager.locManager.location?.coordinate.latitude {
            if let lon = self.locManager.locManager.location?.coordinate.longitude {
                let camera = GMSCameraPosition.cameraWithLatitude(lat, longitude: lon, zoom: 14.0)
                self.GMapView.camera = camera
                self.GMapView.myLocationEnabled = true
                self.GMapView.settings.myLocationButton = true
            }
        }

    }
   
    func displayGEndpoints() {
        
//        print("displaying endpoints")
        
        for wifi in self.dataManager.hSArray {
//            print("endpoint: \(wifi.hpLocName)")
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
            let subtitle = "Down: \(downSpeed) Up: \(upSpeed) \n Tap For Directions"
            let coords = CLLocationCoordinate2DMake(lat, lon)
            
            
            //let location = MKPointAnnotation()
            let marker = GMSMarker()
            marker.position = coords
            marker.title = title
            marker.snippet = subtitle
            
            if Float(downSpeed) < 2.00 {
                marker.icon = UIImage(named:"unlockRed")
            } else if Float(downSpeed) < 10.00 {
                marker.icon = UIImage(named:"unlockYellow")
            } else if Float(downSpeed) < 100.00 {
                marker.icon = UIImage(named:"unlockGreen")
            } else {
                marker.icon = UIImage(named:"unlockWhite")
            }
            
            marker.map = self.GMapView
        }
    }

    //MARK: - Launch Map from Marker
    
    func mapView(mapView: GMSMapView, didTapInfoWindowOfMarker marker: GMSMarker) {
        launchMapApp(marker.position.latitude, lon: marker.position.longitude, name: marker.title!)
    }
    
    
    func launchMapApp(lat: CLLocationDegrees, lon : CLLocationDegrees, name: String) {
        let coordinate = CLLocationCoordinate2DMake(lat, lon)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = name
        mapItem.openInMapsWithLaunchOptions([MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsMapTypeKey])
    }
    
    
    /*
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
    */
    //http://stackoverflow.com/questions/25631410/swift-different-images-for-annotation
    
    /*
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
            //let location = MKPointAnnotation()
            let location = wifiPin()
            location.coordinate = coords
            location.title = title
            location.subtitle = subtitle
            if Float(downSpeed) < 2.00 {
                location.imageName = "unlockRed"
            } else if Float(downSpeed) < 10.00 {
                location.imageName = "unlockYellow"
            } else if Float(downSpeed) < 100.00 {
                location.imageName = "unlockGreen"
            } else {
                location.imageName = "unlockWhite"
            }
            hsMapView.addAnnotation(location)
        }
    }
    */
    /*
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if (annotation is MKUserLocation) {
            return nil
        }
        let reuseId = "test"

        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            //anView!.image = UIImage(named:"unlockBlack")
            anView!.canShowCallout = true
            
            
        } else {
            anView!.annotation = annotation
        }
        
        let pinImage = annotation as! wifiPin
        anView!.image = UIImage(named:pinImage.imageName)
        
        return anView
    }
    */

    
    //MARK: - reusable methods
    
    func reFetch () {
        dataManager.fetchData()
    }
    
    func reloadMap() {
        self.GMapView.clear()
        setupGMap()
        displayGEndpoints()
    }

    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor().AquaGreen()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reFetch), name: "saved", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reloadMap), name: "datarcv", object: nil)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupGMap()
        displayGEndpoints()
        GMapView.delegate = self
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
