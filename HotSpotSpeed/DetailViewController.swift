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

    var selectedHotSpot = HotSpot()
    @IBOutlet weak var DetailMapView : GMSMapView!
    
    func setupDetailMap(){
        let lat = Double(selectedHotSpot.hpLat)! as CLLocationDegrees
        let lon = Double(selectedHotSpot.hpLon)! as CLLocationDegrees
        
        let camera = GMSCameraPosition.cameraWithLatitude(lat, longitude: lon, zoom: 14.0)
        self.DetailMapView.camera = camera
        self.DetailMapView.myLocationEnabled = true
        self.DetailMapView.settings.myLocationButton = true
    }
    
    func addHotSpot() {
        let lat = Double(selectedHotSpot.hpLat)! as CLLocationDegrees
        let lon = Double(selectedHotSpot.hpLon)! as CLLocationDegrees
        
        let hotSpotMarker = GMSMarker()
        hotSpotMarker.position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        hotSpotMarker.title = selectedHotSpot.hpLocName
        hotSpotMarker.map = DetailMapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectedHotSpot.hpLocName)
        setupDetailMap()
        addHotSpot()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
