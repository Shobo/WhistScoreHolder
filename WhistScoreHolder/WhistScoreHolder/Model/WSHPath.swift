//
//  WSHPath.swift
//  WhistScoreHolder
//
//  Created by OctavF on 28/08/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

import UIKit

class WSHPath: UIBezierPath {
    class func xPath(inRect: CGRect, lineWidth: CGFloat) -> WSHPath {
        let aPath = WSHPath();
        
        //top left
        aPath.moveToPoint(CGPointZero)
        //x corner should start equally on L/l (w/h)
        let zeroDeviation = lineWidth / (2.0 * sqrt(2.0))
        //top left +
        aPath.addLineToPoint(CGPointMake(zeroDeviation, 0.0))
        aPath.addLineToPoint(CGPointMake(inRect.width / 2.0, inRect.height / 2.0 - zeroDeviation))
        aPath.addLineToPoint(CGPointMake(inRect.width - zeroDeviation, 0.0))
        aPath.addLineToPoint(CGPointMake(inRect.width, 0.0))
        aPath.addLineToPoint(CGPointMake(inRect.width, zeroDeviation))
        aPath.addLineToPoint(CGPointMake(inRect.width / 2.0 + zeroDeviation, inRect.height / 2.0))
        aPath.addLineToPoint(CGPointMake(inRect.width, inRect.height - zeroDeviation))
        aPath.addLineToPoint(CGPointMake(inRect.width, inRect.height))
        aPath.addLineToPoint(CGPointMake(inRect.width - zeroDeviation, inRect.height))
        aPath.addLineToPoint(CGPointMake(inRect.width / 2.0, inRect.height / 2.0 + zeroDeviation))
        aPath.addLineToPoint(CGPointMake(zeroDeviation, inRect.height))
        aPath.addLineToPoint(CGPointMake(0.0, inRect.height))
        aPath.addLineToPoint(CGPointMake(0.0, inRect.height - zeroDeviation))
        aPath.addLineToPoint(CGPointMake(inRect.width / 2.0 - zeroDeviation, inRect.height / 2.0))
        aPath.addLineToPoint(CGPointMake(0.0, zeroDeviation))
        
        aPath.closePath()
        
        return aPath
    }
    
    class func xPath(inRect: CGRect) -> WSHPath {
        let aPath = WSHPath();
        
        aPath.moveToPoint(CGPointZero)
        aPath.addLineToPoint(CGPointMake(inRect.width / 2.0, inRect.height / 2.0))
        aPath.addLineToPoint(CGPointMake(inRect.width, 0.0))
        aPath.addLineToPoint(CGPointMake(inRect.width / 2.0, inRect.height / 2.0))
        aPath.addLineToPoint(CGPointMake(inRect.width, inRect.height))
        aPath.addLineToPoint(CGPointMake(inRect.width / 2.0, inRect.height / 2.0))
        aPath.addLineToPoint(CGPointMake(0.0, inRect.height))
        aPath.addLineToPoint(CGPointMake(inRect.width / 2.0, inRect.height / 2.0))
        
        aPath.closePath()
        
        return aPath
    }
}
