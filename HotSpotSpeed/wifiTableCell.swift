//
//  wifiTableCell.swift
//  HotSpotSpeed
//
//  Created by Patrick Cooke on 11/18/16.
//  Copyright © 2016 Patrick Cooke. All rights reserved.
//

import UIKit

class wifiTableCell: UITableViewCell {

    @IBOutlet weak var locTitle : UILabel!
    @IBOutlet weak var SSID : UILabel!
    @IBOutlet weak var downSpeed : UILabel!
    @IBOutlet weak var upSpeed : UILabel!
    @IBOutlet weak var City : UILabel!
    @IBOutlet weak var distFromMe : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
