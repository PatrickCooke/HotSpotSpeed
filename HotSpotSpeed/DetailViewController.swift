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
    
    var dataManager = DataManager.sharedInstance
    var selectedHotSpot = HotSpot?()
    var hotspotGID : String!
    @IBOutlet weak var DetailMapView : GMSMapView!
    @IBOutlet weak var SSIDLabel: UILabel!
    @IBOutlet weak var downloadLabel: UILabel!
    @IBOutlet weak var uploadLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    
    //MARK: - Segue Method
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "edit" {
            let destController : NewHotSpotVC = segue.destinationViewController as! NewHotSpotVC
            destController.currentHS = selectedHotSpot
            destController.title = selectedHotSpot!.hpLocName
            destController.saveOrEdit = "save"
        }
    }
    
    //MARK: - Setup Page Methods
    
    func setupDetailMap(){
        if let hotspot = selectedHotSpot {
            let lat = Double(hotspot.hpLat)! as CLLocationDegrees
            let lon = Double(hotspot.hpLon)! as CLLocationDegrees
            
            let camera = GMSCameraPosition.cameraWithLatitude(lat, longitude: lon, zoom: 17.0)
            self.DetailMapView.camera = camera
            self.DetailMapView.myLocationEnabled = true
            self.DetailMapView.settings.compassButton = true
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
    
    func setupData () {
        if let ssidName = selectedHotSpot?.hpSSIDName {
            SSIDLabel.text = "Network Name - \(ssidName)"
        }
        if let downloadspeed = selectedHotSpot?.hpDown {
            downloadLabel.text = "Download - \(downloadspeed)Mbps"
        }
        if let uploadspeed = selectedHotSpot?.hpUp {
            uploadLabel.text = "Upload - \(uploadspeed)Mbps"
        }
        guard let street = selectedHotSpot?.hpStreet else {
            return
        }
        guard let city = selectedHotSpot?.hpCity else {
            return
        }
        guard let state = selectedHotSpot?.hpState else {
            return
        }
        guard  let zip = selectedHotSpot?.hpZip else {
            return
        }
        addressLabel.text = "\(street) \n\(city), \(state) \(zip)"
    }
    
    @IBAction func launchMapApp() {
        guard let lat = selectedHotSpot?.hpLat else {
            return
        }
        guard let lon = selectedHotSpot?.hpLon else {
            return
        }
        guard let name = selectedHotSpot?.hpLocName else {
            return
        }
        let coordinate = CLLocationCoordinate2DMake(Double(lat)!, Double(lon)!)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = name
        mapItem.openInMapsWithLaunchOptions([MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsMapTypeKey])
    }

    func reFetch () {
        dataManager.fetchData()
        setupData()
    }
    
    //MARK: - Life Cycle Methods
    
    override func loadView() {
        super.loadView()
        setupDetailMap()
        addHotSpot()
        setupData()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reFetch), name: "saved", object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }
    
}
