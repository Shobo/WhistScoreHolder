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

let kChoiceButtonsMargin: CGFloat = 25.0

extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView! {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as! UIView
    }
    
    func populateWithEqualSizedViews(views: [UIView]) { //views should be already styled, having labels and targets
        self.removeSubviews()
        
        let numberOfViewsInLine = smallestSquareRootWithSquareLargerThan(views.count)
        
        let choiceButtonSize = (self.frame.width - CGFloat(numberOfViewsInLine + 1) * kChoiceButtonsMargin) / CGFloat(numberOfViewsInLine)
        
        var currentX: CGFloat = kChoiceButtonsMargin
        var currentY: CGFloat = kChoiceButtonsMargin
        
        var itemsOnCurrentRow = 0
        var currentRow = 1
        
        for view in views {
            view.frame = CGRectMake(currentX, currentY, choiceButtonSize, choiceButtonSize)
            self.addSubview(view)
            
            itemsOnCurrentRow += 1
            
            if itemsOnCurrentRow != numberOfViewsInLine {   //same row
                currentX = view.frame.maxX + kChoiceButtonsMargin
            } else {    //switch to next row
                currentRow += 1
                itemsOnCurrentRow = 0
                
                if currentRow == 0 {    //if last row; CHANGE CONDITION
                    //special logic for last row
                } else {
                    currentX = kChoiceButtonsMargin
                    currentY = view.frame.maxY + kChoiceButtonsMargin
                }
            }
        }
    }
    
    func removeSubviews() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
    
}
