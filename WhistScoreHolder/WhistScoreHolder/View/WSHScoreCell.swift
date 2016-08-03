//
//  WSHScoreCell.swift
//  WhistScoreHolder
//
//  Created by OctavF on 17/03/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

import UIKit

@IBDesignable
class WSHScoreCell: UICollectionViewCell {
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var guessLabel: UILabel!
    @IBOutlet weak var realityLabel: UILabel!
    
    var tintColour: UIColor = UIColor.blackColor() {
        didSet {
            mainLabel.textColor = tintColour
            guessLabel.textColor = tintColour
            realityLabel.textColor = tintColour
            
            setNeedsDisplay()
        }
    }
    
    
    //MARK - Overridden
    
    
    override func drawRect(rect: CGRect) {
        addLine(forRect: rect)
    }
    
//    override var backgroundColor: UIColor? {
//        didSet {
//            tintColour = backgroundColor?.complementaryColor() ?? UIColor.blackColor()
//        }
//    }
    
    
    //MARK - Private
    
    
    private func addLine(forRect rect: CGRect) {
        let aPath = UIBezierPath()
        
        aPath.moveToPoint(guessLabel.frame.origin)
        
        aPath.addLineToPoint(CGPointMake(realityLabel.frame.maxX, realityLabel.frame.maxY))
        
        //Keep using the method addLineToPoint until you get to the one where about to close the path
        
        aPath.closePath()
        
        //If you want to stroke it with a red color
        tintColour.set()
        aPath.stroke()
        //If you want to fill it as well
        aPath.fill()
    }
    
}
