//
//  WSHUtils.swift
//  WhistScoreHolder
//
//  Created by OctavF on 11/07/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

import UIKit

func presentError(_ err: Error, fromController: UIViewController) {
    let alertController = UIAlertController(title: NSLocalizedString("error", comment: ""), message:
        "\(err)", preferredStyle: UIAlertControllerStyle.alert)
    
    alertController.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: UIAlertActionStyle.default, handler: { action in
        alertController.dismiss(animated: true, completion: nil)
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
