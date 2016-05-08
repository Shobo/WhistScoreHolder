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
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView! {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as! UIView
    }
    
    //Only works for portrait style views
    func populateWithEqualSizedViews(views: [UIView]) { //views should be already styled, having labels and targets
        self.removeSubviews()
        
        let numberOfViewsOnRow: Int
        let numberOfMissingViews:Int
        let numberOfRows: Int
        let numberOfViewsOnLastRow:Int
        
        let insideViewSize: CGFloat
        
        if self.frame.height >= self.frame.width {
            numberOfViewsOnRow = smallestSquareRootWithSquareLargerThan(views.count)
            numberOfMissingViews = (numberOfViewsOnRow ^^ 2) - views.count
            numberOfRows = numberOfViewsOnRow - numberOfMissingViews / numberOfViewsOnRow
            numberOfViewsOnLastRow = numberOfViewsOnRow - (numberOfMissingViews % numberOfViewsOnRow)
            insideViewSize = (self.frame.width - CGFloat(numberOfViewsOnRow + 1) * kInsideViewsMargin) / CGFloat(numberOfViewsOnRow)
        } else {
            return
        }
        
        var currentX: CGFloat = kInsideViewsMargin
        var currentY: CGFloat = (self.frame.height - CGFloat(numberOfRows - 1) * kInsideViewsMargin - CGFloat(numberOfRows) * insideViewSize) / 2
        
        var itemsOnCurrentRow = 0
        var currentRow = 1
        
        for view in views {
            view.frame = CGRectMake(currentX, currentY, insideViewSize, insideViewSize)
            self.addSubview(view)
            
            itemsOnCurrentRow += 1
            
            if itemsOnCurrentRow != numberOfViewsOnRow {   //same row
                currentX = view.frame.maxX + kInsideViewsMargin
            } else {    //switch to next row
                currentRow += 1
                itemsOnCurrentRow = 0
                
                if currentRow == numberOfRows {    //if last row
                    currentX = (self.frame.width - CGFloat(numberOfViewsOnLastRow) * insideViewSize - CGFloat(numberOfViewsOnLastRow - 1) * kInsideViewsMargin) / 2
                } else {
                    currentX = kInsideViewsMargin
                }
                
                currentY = view.frame.maxY + kInsideViewsMargin
            }
        }
    }
    
    func removeSubviews() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
    
}
