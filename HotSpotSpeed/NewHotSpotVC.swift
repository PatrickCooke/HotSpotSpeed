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
    var dataManager = DataManager.sharedInstance
    let pageLoc = CLLocationManager()
    let backendless = Backendless.sharedInstance()
    var locManager = LocationManager.sharedInstance
    var placePicker: GMSPlacePicker?
    var currentHS = HotSpot?()
    
//    let chainLocationArray = ["McDonalds", "Starbucks", "BIGGBY COFFEE", "Barnes & Noble", "QDOBA mexican eats", "IHOP", "Panera bread", "Taco Bell", "Burger King", "Chick-fil-A", "Applebee's", "arby's", "einstein bros. bagels", "caribou coffee", "seattle's best coffee"]
    

    @IBOutlet weak var ssidLabel: UILabel!
    @IBOutlet weak var locNameTfield: UILabel!
    @IBOutlet weak var dlSpeedTfield: UITextField!
    @IBOutlet weak var upSpeedTfield: UITextField!
    @IBOutlet weak var addressTView: UITextView!
    @IBOutlet weak var speedTestWebView: UIWebView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    let ownerID = UIDevice.currentDevice().name
    var googlePlaceID = ""
    var saveOrEdit = "save"
    var latCoord = ""
    var lonCoord = ""
    var fullAdd = ""
    var city = ""
    var state = ""
    
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
        if (ssidLabel.text != "" && self.latCoord != "" && self.lonCoord != "" && dlSpeedTfield.text != "" && upSpeedTfield.text != "") {
            saveRecordSYNC()
        } else {
            print("didn't save")
            let alert = UIAlertController(title: "Warning", message: "To Save This Hotspot, Please Enter Hotspot SSID, GPS Coordinates, And Up/Down Speeds", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func saveRecordSYNC() {
        print("save method begin")
        
        if saveOrEdit == "edit" {
            print("updating this record")
            if let downspeed1 = dlSpeedTfield.text {
                if let downspeed2 = currentHS?.hpDown {
                let newDownSpeedsum = Double(downspeed1)! + Double(downspeed2)!
                    let updatedDownspeed = newDownSpeedsum / 2
                    currentHS?.hpDown = String(format: "%.2f",updatedDownspeed)
                }
            }
            if let upspeed1 = upSpeedTfield.text {
                if let upspeed2 = currentHS?.hpUp {
                    let newUpSpeedsum = Double(upspeed1)! + Double(upspeed2)!
                    let updatedUpspeed = newUpSpeedsum / 2
                    currentHS?.hpUp = String(format: "%.2f", updatedUpspeed)
                }
            }
            
            let dataStore = Backendless.sharedInstance().data.of(HotSpot.ofClass())
            var error: Fault?
            
            let updatedHS = dataStore.save(currentHS, fault: &error) as? HotSpot
            if error == nil {
                print("Contact has been updated: \(updatedHS!.objectId)")
                self.navigationController?.popViewControllerAnimated(true)
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "saved", object: nil))
            }
            else {
                print("Server reported an error (2): \(error)")
            }
            
        } else {
            
            let newHS = HotSpot()
            
            print("recording new record")
            if let ssid = ssidLabel.text {
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
            
            newHS.hpAddress = fullAdd
            newHS.hpLat = latCoord
            newHS.hpLon = lonCoord
            newHS.hpCity = city
            newHS.hpState = state
            newHS.ownerId = ownerID
            newHS.placeId = googlePlaceID

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
                
                let gId = place.placeID
                let allArray = self.dataManager.hSArray
                for i in 0...(allArray.count - 1) {
                    if gId == allArray[i].placeId {
                        if self.currentSSID == allArray[i].hpSSIDName{
                            print("Endpoint already exists")
                            self.currentHS = allArray[i]
                        }
                    }
                }
                
                if self.currentHS != nil {
                    print("fill in all the fields")
                    self.setupFields()
                    self.saveButton.title = "Update"
                    
                } else {
                    print("new endpoint!")
                    self.saveButton.title = "Save"
                    self.googlePlaceID = place.placeID
                    print("placeID = \(self.googlePlaceID)")
                    guard let fullAddress = place.formattedAddress else {
                        return
                    }
                    
                    let addressArray = place.formattedAddress?.componentsSeparatedByString(", ")
                    if addressArray?.count >= 4 {
                        print("count is greater than 4")
                        guard let cityAddress = addressArray?[1] else {
                            return
                        }
                        self.city = cityAddress
                        print(cityAddress)
                        guard let stateZipAddress = addressArray?[2] else {
                            return
                        }
                        let stateZipArray = stateZipAddress.componentsSeparatedByString(" ")
                        let stateAddress = stateZipArray[0]
                        self.state = stateAddress
                        print (stateAddress)
                        
                    } else {
                        print("count is less than 4")
                        guard let cityAddress = addressArray?[0] else {
                            return
                        }
                        self.city = cityAddress
                        print(self.city)
                        guard let stateZipAddress = addressArray?[1] else {
                            return
                        }
                        let stateZipArray = stateZipAddress.componentsSeparatedByString(" ")
                        let stateAddress = stateZipArray[0]
                        self.state = stateAddress
                        print (self.state)
                    }
                    
                    self.addressTView.text = fullAddress.stringByReplacingOccurrencesOfString(", ", withString: "\n")
                    self.locNameTfield.text = place.name
                    self.latCoord = "\(place.coordinate.latitude)"
                    self.lonCoord = "\(place.coordinate.longitude)"
                    print("\(self.latCoord) - \(self.lonCoord)")
                    self.fullAdd = fullAddress
                    self.upSpeedTfield.text = ""
                    self.dlSpeedTfield.text = ""
                }
            } else {
                self.locNameTfield.text = "No place selected"
                self.addressTView.text = ""
                
//                self.addressTfield.text = ""
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
        if currentHS != nil {
            guard let hotspot = currentHS else {
                return
            }
            ssidLabel.text = hotspot.hpSSIDName
            locNameTfield.text = hotspot.hpLocName
            dlSpeedTfield.text = hotspot.hpDown
            upSpeedTfield.text = hotspot.hpUp
            addressTView.text = hotspot.hpAddress.stringByReplacingOccurrencesOfString(", ", withString: "\n")
            latCoord = hotspot.hpLat
            lonCoord = hotspot.hpLon
            }
    }
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageLoc.startUpdatingLocation()
        displaySpeedTest()
        hideKeyboardWhenTappedAround()
        amIOnline()
        self.saveButton.title = "Save"
    }
    
    override func viewDidAppear(animated: Bool) {
        setupFields()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        saveOrEdit = "save"
    }
    
}
