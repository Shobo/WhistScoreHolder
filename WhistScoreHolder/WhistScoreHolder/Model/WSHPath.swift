//
//  WSHPath.swift
//  WhistScoreHolder
//
//  Created by OctavF on 28/08/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

import UIKit

class WSHPath: UIBezierPath {
    class func xPath(_ inRect: CGRect, lineWidth: CGFloat) -> WSHPath {
        let aPath = WSHPath();
        
        //top left
        aPath.move(to: CGPoint.zero)
        //x corner should start equally on L/l (w/h)
        let zeroDeviation = lineWidth / (2.0 * sqrt(2.0))
        //top left +
        aPath.addLine(to: CGPoint(x: zeroDeviation, y: 0.0))
        aPath.addLine(to: CGPoint(x: inRect.width / 2.0, y: inRect.height / 2.0 - zeroDeviation))
        aPath.addLine(to: CGPoint(x: inRect.width - zeroDeviation, y: 0.0))
        aPath.addLine(to: CGPoint(x: inRect.width, y: 0.0))
        aPath.addLine(to: CGPoint(x: inRect.width, y: zeroDeviation))
        aPath.addLine(to: CGPoint(x: inRect.width / 2.0 + zeroDeviation, y: inRect.height / 2.0))
        aPath.addLine(to: CGPoint(x: inRect.width, y: inRect.height - zeroDeviation))
        aPath.addLine(to: CGPoint(x: inRect.width, y: inRect.height))
        aPath.addLine(to: CGPoint(x: inRect.width - zeroDeviation, y: inRect.height))
        aPath.addLine(to: CGPoint(x: inRect.width / 2.0, y: inRect.height / 2.0 + zeroDeviation))
        aPath.addLine(to: CGPoint(x: zeroDeviation, y: inRect.height))
        aPath.addLine(to: CGPoint(x: 0.0, y: inRect.height))
        aPath.addLine(to: CGPoint(x: 0.0, y: inRect.height - zeroDeviation))
        aPath.addLine(to: CGPoint(x: inRect.width / 2.0 - zeroDeviation, y: inRect.height / 2.0))
        aPath.addLine(to: CGPoint(x: 0.0, y: zeroDeviation))
        
        aPath.close()
        
        return aPath
    }
    
    class func xPath(_ inRect: CGRect) -> WSHPath {
        let aPath = WSHPath();
        
        aPath.move(to: CGPoint.zero)
        aPath.addLine(to: CGPoint(x: inRect.width / 2.0, y: inRect.height / 2.0))
        aPath.addLine(to: CGPoint(x: inRect.width, y: 0.0))
        aPath.addLine(to: CGPoint(x: inRect.width / 2.0, y: inRect.height / 2.0))
        aPath.addLine(to: CGPoint(x: inRect.width, y: inRect.height))
        aPath.addLine(to: CGPoint(x: inRect.width / 2.0, y: inRect.height / 2.0))
        aPath.addLine(to: CGPoint(x: 0.0, y: inRect.height))
        aPath.addLine(to: CGPoint(x: inRect.width / 2.0, y: inRect.height / 2.0))
        
        aPath.close()
        
        return aPath
    }
}
