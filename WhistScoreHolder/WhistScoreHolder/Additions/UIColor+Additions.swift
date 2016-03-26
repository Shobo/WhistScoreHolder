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
}
