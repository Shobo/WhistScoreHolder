//
//  WSHGridView.swift
//  WhistScoreHolder
//
//  Created by OctavF on 07/07/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

import UIKit

class WSHGridView: UIView {

    var views: [UIView]? {
        didSet {
            self.keepSubviews(views ?? [])
            self.populateWithEqualSizedViews(views ?? [])
        }
    }
    
    
    //MARK - Overridden
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.populateWithEqualSizedViews(self.views ?? [])
    }
    
    
    //MARK: - Private func
    
    
    //Only works for portrait style views
    func populateWithEqualSizedViews(viewZ: [UIView]) { //views should be already styled, having labels and targets
        
        var numberOfViewsOnRow: Int
        let numberOfMissingViews:Int
        var numberOfRows: Int
        let numberOfViewsOnLastRow:Int
        
        let insideViewSize: CGFloat
        
        let frameH : CGFloat
        let frameW : CGFloat
        
        numberOfViewsOnRow = smallestSquareRootWithSquareLargerThan(viewZ.count)
        numberOfMissingViews = (numberOfViewsOnRow ^^ 2) - viewZ.count
        numberOfRows = numberOfViewsOnRow - numberOfMissingViews / numberOfViewsOnRow
        numberOfViewsOnLastRow = numberOfViewsOnRow - (numberOfMissingViews % numberOfViewsOnRow)
        
        let isVerticallyOriented = self.frame.height >= self.frame.width
        
        if self.frame.height >= self.frame.width {
            frameH = self.frame.height
            frameW = self.frame.width
            
        } else {
            frameW = self.frame.height
            frameH = self.frame.width
            
            swap(&numberOfRows, &numberOfViewsOnRow)
        }
        
        insideViewSize = min((frameW - CGFloat(numberOfViewsOnRow + 1) * kInsideViewsMargin) / CGFloat(numberOfViewsOnRow), (frameH - CGFloat(numberOfRows + 1) * kInsideViewsMargin) / CGFloat(numberOfRows))
        
        var currentX: CGFloat = (frameW - CGFloat(numberOfViewsOnRow - 1) * kInsideViewsMargin - CGFloat(numberOfViewsOnRow) * insideViewSize) / 2
        var currentY: CGFloat = (frameH - CGFloat(numberOfRows - 1) * kInsideViewsMargin - CGFloat(numberOfRows) * insideViewSize) / 2
        
        var itemsOnCurrentRow = 0
        var currentRow = 1
        
        for view in viewZ {
            view.frame = CGRectMake(isVerticallyOriented ? currentX : currentY, isVerticallyOriented ? currentY : currentX, insideViewSize, insideViewSize)
            
            itemsOnCurrentRow += 1
            
            if itemsOnCurrentRow != numberOfViewsOnRow {   //same row
                currentX = (isVerticallyOriented ? view.frame.maxX : view.frame.maxY) + kInsideViewsMargin
            } else {    //switch to next row
                currentRow += 1
                itemsOnCurrentRow = 0
                
                if currentRow == numberOfRows {    //if last row
                    currentX = (frameW - CGFloat(min(numberOfViewsOnLastRow, numberOfViewsOnRow)) * insideViewSize - CGFloat(min(numberOfViewsOnLastRow, numberOfViewsOnRow) - 1) * kInsideViewsMargin) / 2
                } else {
                    currentX = kInsideViewsMargin
                }
                
                currentY = (isVerticallyOriented ? view.frame.maxY : view.frame.maxX) + kInsideViewsMargin
            }
        }
    }
}
