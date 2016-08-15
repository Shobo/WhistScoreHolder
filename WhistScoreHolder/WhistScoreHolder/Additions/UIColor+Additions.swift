//
//  UIColor+Additions.swift
//  WhistScoreHolder
//
//  Created by OctavF on 17/03/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

import UIKit

extension UIColor {
    func complementaryColor() -> UIColor {
        let componentColors = CGColorGetComponents(self.CGColor)
        
        return UIColor(red: 1.0 - componentColors[0],
                        green: 1.0 - componentColors[1],
                        blue: 1.0 - componentColors[2],
                        alpha: 1.0)
    }
    
    
    //MARK: - Class functions
    
    
    class func randomColor() -> UIColor {
        return UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1.0)
    }
    
    class func colorFromRGB(rgbVal: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbVal & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbVal & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbVal & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0))
    }
    
    class func white() -> UIColor {
        return UIColor.colorFromRGB(0xF7F7F7)
    }
    
}
