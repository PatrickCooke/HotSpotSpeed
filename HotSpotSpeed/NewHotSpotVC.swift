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
import SystemConfiguration.CaptiveNetwork

class NewHotSpotVC: UIViewController, UITextFieldDelegate {
    let pageLoc = CLLocationManager()
    let backendless = Backendless.sharedInstance()
    var locManager = LocationManager.sharedInstance
    var placePicker: GMSPlacePicker?
    var newHS = HotSpot?()
    
    let chainLocationArray = ["McDonalds", "Starbucks", "BIGGBY COFFEE", "Barnes & Noble", "QDOBA mexican eats", "IHOP", "Panera bread", "Taco Bell", "Burger King", "Chick-fil-A", "Applebee's", "arby's", "einstein bros. bagels", "caribou coffee", "seattle's best coffee"]
    
//    @IBOutlet weak var ssidTfield: UITextField!
    @IBOutlet weak var ssidLabel: UILabel!
    @IBOutlet weak var locNameTfield: UILabel!
    @IBOutlet weak var dlSpeedTfield: UITextField!
    @IBOutlet weak var upSpeedTfield: UITextField!
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var lonLabel: UILabel!
    @IBOutlet weak var addressTfield: UILabel!
    @IBOutlet weak var cityTfield: UILabel!
    @IBOutlet weak var zipTfield: UILabel!
    @IBOutlet weak var stateTfield: UILabel!
    @IBOutlet weak var speedTestWebView: UIWebView!
    let ownerID = UIDevice.currentDevice().name
    var googlePlaceID = ""

    
    //MARK: - Get SSID
    var networkSSID : String?
    var currentSSID = ""
    
    func fetchSSIDInfo() ->  String {
        //var currentSSID = ""
        if let interfaces:CFArray = CNCopySupportedInterfaces() {
            for i in 0..<CFArrayGetCount(interfaces){
                let allInterfaceNames = CFArrayGetValueAtIndex(interfaces, i)
                let rec = unsafeBitCast(allInterfaceNames, AnyObject.self)
                let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)" as CFString)
                if unsafeInterfaceData != nil {
                    let interfaceData = unsafeInterfaceData! as Dictionary!
                    for dictData in interfaceData! {
                        if dictData.0 as! String == "SSID" {
                            currentSSID = dictData.1 as! String
                        }
                    }
                }
            }
        }
        networkSSID = currentSSID
        if let ssid = networkSSID {
            self.ssidLabel.text = ssid
        } else {
            print("no network found")
        }
        return currentSSID
    }
    

    
    
    //MARK: - Save Method
    
    @IBAction func savePressed () {
        print("save pressed")
        if (ssidLabel.text != "" && latLabel.text != "" && lonLabel.text != "" && dlSpeedTfield.text != "" && upSpeedTfield.text != "") {
            saveRecordSYNC()
        } else {
            print("didn't save")
            let alert = UIAlertController(title: "Warning", message: "To Save This Hotspot, Please Enter Hotspot SSID, GPS Coordinates, And Up/Down Speeds", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func saveRecordSYNC() {
        
        //let newHS = HotSpot()
        if newHS != nil {
            if let downspeed1 = dlSpeedTfield.text {
                if let downspeed2 = newHS?.hpDown {
                let newDownSpeedsum = Double(downspeed1)! + Double(downspeed2)!
                    let updatedDownspeed = newDownSpeedsum / 2
                    newHS?.hpDown = String(updatedDownspeed)
                }
            }
            if let upspeed1 = upSpeedTfield.text {
                if let upspeed2 = newHS?.hpUp {
                    let newUpSpeedsum = Double(upspeed1)! + Double(upspeed2)!
                    let updatedUpspeed = newUpSpeedsum / 2
                    newHS?.hpUp = String(updatedUpspeed)
                }
            }
            
            let dataStore = Backendless.sharedInstance().data.of(HotSpot.ofClass())
            var error: Fault?
            
            let updatedHS = dataStore.save(newHS, fault: &error) as? HotSpot
            if error == nil {
                print("Contact has been updated: \(updatedHS!.objectId)")
                self.navigationController?.popViewControllerAnimated(true)
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "saved", object: nil))
            }
            else {
                print("Server reported an error (2): \(error)")
            }
            
        } else {
            if let ssid = ssidLabel.text {
                newHS!.hpSSIDName = ssid
            }
            if let loc = locNameTfield.text {
                newHS!.hpLocName = loc
            }
            if let downSpeed = dlSpeedTfield.text {
                newHS!.hpDown = downSpeed
            }
            if let upSpeed = upSpeedTfield.text {
                newHS!.hpUp = upSpeed
            }
            if let lat = latLabel.text {
                newHS!.hpLat = lat
                print("\(lat)")
            }
            if let lon = lonLabel.text {
                newHS!.hpLon = lon
                print("\(lon)")
            }
            if let street = addressTfield.text {
                newHS!.hpStreet = street
            }
            if let city = cityTfield.text {
                newHS!.hpCity = city
            }
            if let zip = zipTfield.text {
                newHS!.hpZip = zip
            }
            if let state = stateTfield.text {
                newHS!.hpState = state
            }
            newHS!.ownerId = ownerID
            newHS!.placeId = googlePlaceID
            
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
    }
    
    //MARK: - SpeedTest Website Viewer
    
    func displaySpeedTest() {
        let URLString = "http://speedtest.att.com/speedtest/"
        let myURL = NSURL (string: URLString)
        let myURLRequest = NSURLRequest(URL: myURL!)
        
        speedTestWebView.layer.cornerRadius = 8
        speedTestWebView.layer.borderWidth = 2
        //speedTestWebView.layer.borderColor = (UIColor().AquaGreen() as! CGColor)
        speedTestWebView.loadRequest(myURLRequest)
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
                
//                self.locNameTfield.text = place.name
            
                //self.addressLabel.text = place.formattedAddress!.components(separatedBy:", ").joined(separator:"\n")
                let addressArray = place.formattedAddress?.componentsSeparatedByString(", ")
                guard let streetAddress = addressArray?[0] else {
                    return
                }
                self.addressTfield.text  = streetAddress
                
                self.googlePlaceID = place.placeID
                print("placeID = \(self.googlePlaceID)")
                
                guard let cityAddress = addressArray?[1] else {
                    return
                }
                print(cityAddress)
                self.cityTfield.text = cityAddress
                guard let stateZipAddress = addressArray?[2] else {
                    return
                }
                
                
                for i in 0...(self.chainLocationArray.count - 1) {
                    let chainString = self.chainLocationArray[i]
                    if place.name.lowercaseString == chainString.lowercaseString {
                        self.locNameTfield.text = "\(place.name) \(cityAddress)"
                        if place.name.lowercaseString == "qdoba mexican eats" {
                            self.locNameTfield.text = "Qdoba \(cityAddress)"
                        }
                        break
                    } else {
                        self.locNameTfield.text = place.name
                    }
                }
                
                let stateZipArray = stateZipAddress.componentsSeparatedByString(" ")
                let zipAddress = stateZipArray[1]
                let stateAddress = stateZipArray[0]
                self.stateTfield.text = stateAddress
                self.zipTfield.text = zipAddress
                self.latLabel.text = "\(place.coordinate.latitude)"
                self.lonLabel.text = "\(place.coordinate.longitude)"
                
            } else {
                self.locNameTfield.text = "No place selected"
                self.addressTfield.text = ""
            }
        })

    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func amIOnline() {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            fetchSSIDInfo()
        } else {
            print("Internet connection FAILED")
            
            let alertController = UIAlertController(title: "No Wifi Connection", message: "Please Make Sure Your Device Is Connected To A Wifi HotSpot", preferredStyle: .Alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                // ...
            }
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {
                // ...
            }
            
        }
    }
    
    func setupFields() {
        if newHS != nil {
            guard let hotspot = newHS else {
                return
            }
            ssidLabel.text = hotspot.hpSSIDName
            locNameTfield.text = hotspot.hpLocName
            addressTfield.text = hotspot.hpStreet
            cityTfield.text = hotspot.hpCity
            stateTfield.text = hotspot.hpState
            zipTfield.text = hotspot.hpZip
            latLabel.text = hotspot.hpLat
            lonLabel.text = hotspot.hpLon
            dlSpeedTfield.text = hotspot.hpDown
            upSpeedTfield.text = hotspot.hpUp
        }
    }
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageLoc.startUpdatingLocation()
//        makeTextFieldintoDelegrates()
        displaySpeedTest()
        hideKeyboardWhenTappedAround()
        amIOnline()
    }
    
    override func viewDidAppear(animated: Bool) {
        setupFields()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
