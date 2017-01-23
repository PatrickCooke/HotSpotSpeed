//
//  DetailViewController.swift
//  HotSpotSpeed
//
//  Created by Patrick Cooke on 1/18/17.
//  Copyright © 2017 Patrick Cooke. All rights reserved.
//

import UIKit
import GoogleMaps

class DetailViewController: UIViewController {

    var selectedHotSpot = HotSpot?()
    var hotspotGID : String!
    @IBOutlet weak var DetailMapView : GMSMapView!
    
    func setupDetailMap(){
        if let hotspot = selectedHotSpot {
        let lat = Double(hotspot.hpLat)! as CLLocationDegrees
        let lon = Double(hotspot.hpLon)! as CLLocationDegrees
        
        let camera = GMSCameraPosition.cameraWithLatitude(lat, longitude: lon, zoom: 14.0)
        self.DetailMapView.camera = camera
        self.DetailMapView.myLocationEnabled = true
        self.DetailMapView.settings.myLocationButton = true
        }
    }
    
    func addHotSpot() {
        if let hotspot = selectedHotSpot {
        let lat = Double(hotspot.hpLat)! as CLLocationDegrees
        let lon = Double(hotspot.hpLon)! as CLLocationDegrees
        
        let hotSpotMarker = GMSMarker()
        hotSpotMarker.position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        hotSpotMarker.title = hotspot.hpLocName
        hotSpotMarker.map = DetailMapView
        }
    }
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if let name = selectedHotSpot!.hpLocName {
//        print(name)
//        }
        print("GID = \(hotspotGID)")
        setupDetailMap()
        addHotSpot()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
