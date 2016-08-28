//
//  WSHOverlayView.swift
//  WhistScoreHolder
//
//  Created by OctavF on 13/08/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

import UIKit

@IBDesignable
class WSHOverlayView: UIView {

    @IBInspectable var forwardTouchesToSubviews: Bool = false
    
    
    //MARK: - Private

    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        if self.forwardTouchesToSubviews {
            for view in self.subviews {
                if !view.hidden {
                    let subPoint = view.convertPoint(point, fromView: self)
                    
                    if view.pointInside(subPoint, withEvent: event) {
                        return true
                    }
                }
            }
        }
        return self.userInteractionEnabled
    }
    
}
