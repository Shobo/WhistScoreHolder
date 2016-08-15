//
//  WSHUtils.swift
//  WhistScoreHolder
//
//  Created by OctavF on 11/07/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

import UIKit

func presentError(err: ErrorType, fromController: UINavigationController) {
    let alertController = UIAlertController(title: "ERROR", message:
        "\(err)", preferredStyle: UIAlertControllerStyle.Alert)
    
    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
        fromController.popViewControllerAnimated(true)
    }))
    
    fromController.presentViewController(alertController, animated: true, completion: nil)
}

func randHEX() -> UInt {
    return UInt(drand48() * 0xffffff)
}

func prefferedImageSize() -> CGSize {
    let minWH = min(UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
    
    return CGSizeMake(minWH, minWH)
}