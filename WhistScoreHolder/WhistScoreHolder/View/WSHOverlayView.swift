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

    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if self.forwardTouchesToSubviews {
            for view in self.subviews {
                if !view.isHidden {
                    let subPoint = view.convert(point, from: self)
                    
                    if view.point(inside: subPoint, with: event) {
                        return true
                    }
                }
            }
        }
        return self.isUserInteractionEnabled
    }
    
}
