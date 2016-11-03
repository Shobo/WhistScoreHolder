//
//  WSHUtils.swift
//  WhistScoreHolder
//
//  Created by OctavF on 11/07/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

import UIKit

func presentError(_ err: Error, fromController: UINavigationController) {
    let alertController = UIAlertController(title: "ERROR", message:
        "\(err)", preferredStyle: UIAlertControllerStyle.alert)
    
    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
        fromController.popViewController(animated: true)
    }))
    
    fromController.present(alertController, animated: true, completion: nil)
}

func randHEX() -> UInt {
    return UInt(drand48() * 0xffffff)
}

func prefferedImageSize() -> CGSize {
    let minWH = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    
    return CGSize(width: minWH, height: minWH)
}
