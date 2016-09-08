//
//  NewHotSpotVC.swift
//  HotSpotSpeed
//
//  Created by Patrick Cooke on 9/7/16.
//  Copyright © 2016 Patrick Cooke. All rights reserved.
//

import UIKit
import CoreLocation

class NewHotSpotVC: UIViewController, UITextFieldDelegate {
    let pageLoc = CLLocationManager()
    let backendless = Backendless.sharedInstance()
    var locManager = LocationManager.sharedInstance
    @IBOutlet weak var ssidTfield: UITextField!
    @IBOutlet weak var locNameTfield: UITextField!
    @IBOutlet weak var dlSpeedTfield: UITextField!
    @IBOutlet weak var upSpeedTfield: UITextField!
    @IBOutlet weak var latTfield: UITextField!
    @IBOutlet weak var lonTfield: UITextField!
    @IBOutlet weak var addressTfield: UITextField!
    @IBOutlet weak var cityTfield: UITextField!
    @IBOutlet weak var zipTfield: UITextField!
    
    @IBAction func savePressed (sender: AnyObject) {
        print("save pressed")
        
    }
    func saveRecordSYNC() {
        let newHS = HotSpot()
        if let ssid = ssidTfield.text {
            newHS.hpSSIDName = ssid
        }
        if let loc = locNameTfield.text {
            newHS.hpLocName = loc
        }
        if let downSpeed = dlSpeedTfield.text {
            newHS.hpDown = Double(downSpeed)
        }
        if let upSpeed = upSpeedTfield.text {
            newHS.hpUp = Double(upSpeed)
        }
        if let lat = latTfield.text {
            newHS.hpLat = lat
        }
        if let lon = lonTfield.text {
            newHS.hpLon = lon
        }
        if let street = addressTfield.text {
            newHS.hpStreet = street
        }
        if let city = cityTfield.text {
            newHS.hpCity = city
        }
        if let zip = zipTfield.text {
            newHS.hpZip = zip
        }
        
        let dataStore = backendless.data.of(HotSpot.ofClass())
        
        // save object synchronously
        var error: Fault?
        let result = dataStore.save(newHS, fault: &error) as? HotSpot
        if error == nil {
            print("Hotspot has been saved: \(result?.hpSSIDName)")
        }
        else {
            print("Server reported an error: \(error)")
        }
        
    }
    
    
    //MARK: - Get GPS Coords from Loc
    
    @IBAction func useCurrent (sender: UIButton) {
        
        if let lat = pageLoc.location?.coordinate.latitude {
            latTfield.text = String(lat)
        }
        if let lon = pageLoc.location?.coordinate.longitude {
            lonTfield.text = String(lon)
        }
        
    }
    
    //MARK: - Get GPS Coords from Address
    
    @IBAction func useAddress (sender: UIButton) {
        guard let street = addressTfield.text else{
            return
        }
        guard let city = cityTfield.text else {
            return
        }
        guard let zip = zipTfield.text else {
            return
        }
        let address = String("\(street) \(city) \(zip)")
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if((error) != nil){
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                self.latTfield.text = "\(coordinates.latitude)"
                self.lonTfield.text = "\(coordinates.longitude)"
            }
        }
        
    }
    
    //MARK: - Use Local Search to fill in address and GPS???
    
    
    //MARK: - Textfield Return button Methods
    
    func makeTextFieldintoDelegrates() {
        ssidTfield.delegate=self
        locNameTfield.delegate=self
        dlSpeedTfield.delegate=self
        upSpeedTfield.delegate=self
        latTfield.delegate=self
        lonTfield.delegate=self
        addressTfield.delegate=self
        cityTfield.delegate=self
        zipTfield.delegate=self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.ssidTfield {
            self.locNameTfield.becomeFirstResponder()
        }
        if textField == self.locNameTfield {
            self.dlSpeedTfield.becomeFirstResponder()
        }
        if textField == self.dlSpeedTfield {
            self.upSpeedTfield.becomeFirstResponder()
        }
        if textField == self.upSpeedTfield {
            self.latTfield.becomeFirstResponder()
        }
        if textField == self.latTfield {
            self.lonTfield.becomeFirstResponder()
        }
        if textField == self.lonTfield {
            self.addressTfield.becomeFirstResponder()
        }
        if textField == self.addressTfield {
            self.cityTfield.becomeFirstResponder()
        }
        if textField == self.cityTfield {
            self.zipTfield.becomeFirstResponder()
        }
        if textField == self.zipTfield {
            self.resignFirstResponder()
        }
        
        return true
    }
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageLoc.startUpdatingLocation()
        makeTextFieldintoDelegrates()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
