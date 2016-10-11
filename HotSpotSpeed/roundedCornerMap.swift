//
//  roundedCornerMap.swift
//  HotSpotSpeed
//
//  Created by Patrick Cooke on 10/11/16.
//  Copyright © 2016 Patrick Cooke. All rights reserved.
//

import UIKit

@IBDesignable
class roundedCornerMap: MKMapView {

    @IBInspectable var cornerRadius : CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor : UIColor? {
        didSet {
            layer.borderColor = borderColor?.CGColor
        }
    }

}
