//
//  Options.swift
//  HotSpotSpeed
//
//  Created by Patrick Cooke on 1/2/17.
//  Copyright © 2017 Patrick Cooke. All rights reserved.
//

import Foundation

class Options: NSObject {
    static let sharedInstance = Options()
    
    var sortMethod : Int!
    var listRange : Double!
    
    /*
     quick note: 
     sort method 0 = Network Speed
     sort method 1 = Network Distance
     
     listRange 0 = .5 miles
     listRange 1 = 1 mile
     listRange 2 = 5 miles
     listRange 3 = 10 miles
     listRange 4 = 25 miles
 */
    
    
}
