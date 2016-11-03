//
//  UIView+Additions.swift
//  WhistScoreHolder
//
//  Created by OctavF on 29/02/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

import UIKit

let kMargin: CGFloat = 6.0
let kMinRowHeight: CGFloat = 80.0

let kInsideViewsMargin: CGFloat = 25.0

extension UIView {
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> UIView! {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    func removeSubviews() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
    
    func keepSubviews(_ views: [UIView]) {
        let currentSubViewsArray = self.subviews
        
        for view in currentSubViewsArray {
            if !views.contains(view) {
                view.removeFromSuperview()
            }
        }
        for view in views {
            if !currentSubViewsArray.contains(view) {
                self.addSubview(view)
            }
        }
    }
    
}
