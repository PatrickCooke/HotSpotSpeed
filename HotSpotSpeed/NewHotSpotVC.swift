//
//  NewHotSpotVC.swift
//  HotSpotSpeed
//
//  Created by Patrick Cooke on 9/7/16.
//  Copyright © 2016 Patrick Cooke. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlacePicker

class NewHotSpotVC: UIViewController, UITextFieldDelegate {
    let pageLoc = CLLocationManager()
    let backendless = Backendless.sharedInstance()
    var locManager = LocationManager.sharedInstance
    var placePicker: GMSPlacePicker?
    
    @IBOutlet weak var ssidTfield: UITextField!
    @IBOutlet weak var locNameTfield: UITextField!
    @IBOutlet weak var dlSpeedTfield: UITextField!
    @IBOutlet weak var upSpeedTfield: UITextField!
    @IBOutlet weak var latTfield: UITextField!
    @IBOutlet weak var lonTfield: UITextField!
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var lonLabel: UILabel!
    @IBOutlet weak var addressTfield: UITextField!
    @IBOutlet weak var cityTfield: UITextField!
    @IBOutlet weak var zipTfield: UITextField!
    
    //MARK: - Save Method
    
    @IBAction func savePressed () {
        print("save pressed")
        if (ssidTfield.text != "" && latLabel.text != "" && lonLabel.text != "" && dlSpeedTfield.text != "" && upSpeedTfield.text != "") {
            saveRecordSYNC()
        } else {
            print("didn't save")
            let alert = UIAlertController(title: "Warning", message: "To Save This Hotspot, Please Enter Hotspot SSID, GPS Coordinates, And Up/Down Speeds", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
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
            newHS.hpDown = downSpeed
        }
        if let upSpeed = upSpeedTfield.text {
            newHS.hpUp = upSpeed
        }
        if let lat = latLabel.text {
            newHS.hpLat = lat
            print("\(lat)")
        }
        if let lon = lonLabel.text {
            newHS.hpLon = lon
            print("\(lon)")
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
            self.navigationController?.popViewControllerAnimated(true)
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "saved", object: nil))
        }
        else {
            print("Server reported an error: \(error)")
        }
        
    }
    
    //MARK: - Use Google Place Picker
    
    @IBAction func UsePlacePicker() {
        let lat = locManager.locManager.location?.coordinate.latitude
        let lon = locManager.locManager.location?.coordinate.longitude
        let center = CLLocationCoordinate2DMake(lat!,lon!)
        let northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001)
        let southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        placePicker = GMSPlacePicker(config: config)
        
        
        
        placePicker?.pickPlaceWithCallback({ (foundPlace, error) -> Void in
            
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let place = foundPlace {
                
                //let street = place.addressComponents["street"]
                //                print(street)
                self.locNameTfield.text = place.name
                //self.addressLabel.text = place.formattedAddress!.components(separatedBy:", ").joined(separator:"\n")
                let addressArray = place.formattedAddress?.componentsSeparatedByString(", ")
                guard let streetAddress = addressArray?[0] else {
                    return
                }
                self.addressTfield.text = streetAddress
                
                guard let cityAddress = addressArray?[1] else {
                    return
                }
                print(cityAddress)
                self.cityTfield.text = cityAddress
                guard let stateZipAddress = addressArray?[2] else {
                    return
                }
                let stateZipArray = stateZipAddress.componentsSeparatedByString(" ")
                let zipAddress = stateZipArray[1]
                self.zipTfield.text = zipAddress
                self.latLabel.text = "\(place.coordinate.latitude)"
                self.lonLabel.text = "\(place.coordinate.longitude)"
                
                
//                print(zipAddress)
//                print("lat: \(place.coordinate.latitude)")
//                print("lon: \(place.coordinate.longitude)")
                
            } else {
                self.locNameTfield.text = "No place selected"
                self.addressTfield.text = ""
            }
        })

    }
    
    //MARK: - Get GPS Coords from Loc
    
    @IBAction func useCurrent (sender: UIButton) {
        
        if let lat = pageLoc.location?.coordinate.latitude {
            latLabel.text = String(lat)
        }
        if let lon = pageLoc.location?.coordinate.longitude {
            lonLabel.text = String(lon)
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
                self.latLabel.text = "\(coordinates.latitude)"
                self.lonLabel.text = "\(coordinates.longitude)"
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
