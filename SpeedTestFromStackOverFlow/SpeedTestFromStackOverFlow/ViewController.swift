//
//  ViewController.swift
//  SpeedTestFromStackOverFlow
//
//  Created by Patrick Cooke on 10/14/16.
//  Copyright © 2016 Patrick Cooke. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDelegate, URLSessionDataDelegate {
    
    @IBAction func buttonPress(_ sender: AnyObject) {
        testSpeed()
    }
    func testSpeed()  {
        
        
        let url = URL(string: "http://appsbypat.com/wp-content/uploads/2016/10/100x100blank.bmp")
        let request = URLRequest(url: url!)
        
        let session = URLSession.shared
        
        let startTime = Date()
        
        let task =  session.dataTask(with: request) { (data, resp, error) in
            
            guard error == nil && data != nil else{
                print("connection error or data is nill")
                
                return
            }
            guard resp != nil else{
                print("respons is nill")
                return
            }
            
            let length  = CGFloat( (resp?.expectedContentLength )!) / 1000000.0
            print("File is \(length) mb")
            let elapsed = CGFloat( Date().timeIntervalSince(startTime))
            print("elapsed: \(elapsed)")
            print("Speed: \(length/elapsed) Mb/sec")
            
        }
        
        
        task.resume()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testSpeed()
    }
    
}

