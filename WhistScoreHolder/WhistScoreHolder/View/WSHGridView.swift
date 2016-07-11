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
    private func populateWithEqualSizedViews(viewZ: [UIView]) { //views should be already styled, having labels and targets
        
        var numberOfCollumns: Int
        var numberOfRows: Int
        let numberOfViewsOnLastRow:Int
        
        let insideViewSize: CGFloat
        
        (numberOfRows, numberOfCollumns, numberOfViewsOnLastRow, insideViewSize) = self.positioningGenerator(self.bounds.size, numberOfElements: viewZ.count)
        
        let isVerticallyOriented = numberOfRows >= numberOfCollumns
        let frameH = self.frame.height
        let frameW = self.frame.width
        
        let xMargin: CGFloat = (frameW - CGFloat(numberOfCollumns - 1) * kInsideViewsMargin - CGFloat(numberOfCollumns) * insideViewSize) / 2
        let yMargin: CGFloat = (frameH - CGFloat(numberOfRows - 1) * kInsideViewsMargin - CGFloat(numberOfRows) * insideViewSize) / 2
        
        var currentX: CGFloat = xMargin
        var currentY: CGFloat = yMargin
        
        var itemsOnCurrentLine = 0
        var currentLineIndex = 1
        let numberOfItemsOnRow = numberOfCollumns - ((numberOfViewsOnLastRow != 0 && numberOfViewsOnLastRow != min(numberOfRows, numberOfCollumns)) ? Int(!isVerticallyOriented) : 0)
        
        for view in viewZ {
            view.frame = CGRectMake(currentX, currentY, insideViewSize, insideViewSize)
            
            itemsOnCurrentLine += 1
            
            if itemsOnCurrentLine != numberOfItemsOnRow {   //same row
                currentX = view.frame.maxX + kInsideViewsMargin
            } else {    //switch to next row
                currentLineIndex += 1
                itemsOnCurrentLine = 0
                
                if currentLineIndex == numberOfRows && isVerticallyOriented {    //if last row
                    currentX = (frameW - CGFloat(numberOfViewsOnLastRow) * insideViewSize - (CGFloat(numberOfViewsOnLastRow) - 1) * kInsideViewsMargin) / 2
                } else {
                    currentX = xMargin
                }
                
                if !isVerticallyOriented && (numberOfViewsOnLastRow != 0 && viewZ.count - ((currentLineIndex - 1) * numberOfItemsOnRow) == numberOfViewsOnLastRow) {
                    currentX = view.frame.maxX + kInsideViewsMargin
                    currentY = (frameH - CGFloat(numberOfViewsOnLastRow) * insideViewSize - (CGFloat(numberOfViewsOnLastRow) - 1) * kInsideViewsMargin) / 2
                } else {
                    currentY = view.frame.maxY + kInsideViewsMargin
                }
            }
        }
    }
    
    private func positioningGenerator(rectSize: CGSize, numberOfElements: Int) -> (rows: Int, collumns: Int, onLast: Int, size: CGFloat) {
        let squarePositioning = smallestSquareRootWithSquareLargerThan(numberOfElements)
        
        var rez: (rows: Int, collumns: Int, onLast: Int, size: CGFloat) = (0, 0, 0, 0)
        var insideViewSize: CGFloat
        
        for i in 1...squarePositioning {
            let j = Int(ceil(CGFloat(numberOfElements) / CGFloat(i)))
            
            insideViewSize = self.sizeForPositioning((i, j), onSize: rectSize)

            if insideViewSize > rez.size || (insideViewSize == rez.size && abs(rez.rows - rez.collumns) > abs(j - i)) {
                rez.rows = j
                rez.collumns = i
                rez.size = insideViewSize
            }
            
            insideViewSize = self.sizeForPositioning((j, i), onSize: rectSize)
            
            if (insideViewSize > rez.size) || (insideViewSize == rez.size && abs(rez.rows - rez.collumns) > abs(i - j)) {
                rez.rows = i
                rez.collumns = j
                rez.size = insideViewSize
            }
        }
        
        return (rez.rows, rez.collumns, min(rez.rows, rez.collumns) - (rez.rows * rez.collumns - numberOfElements), rez.size)
    }
    
    private func sizeForPositioning(positioning: (collumns: Int, rows: Int), onSize: CGSize) -> CGFloat {
        return min((onSize.width - CGFloat(positioning.collumns + 1) * kInsideViewsMargin) / CGFloat(positioning.collumns),
                   (onSize.height - CGFloat(positioning.rows + 1) * kInsideViewsMargin) / CGFloat(positioning.rows))
    }
    
}
