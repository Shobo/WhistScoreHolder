//
//  UIAlertController+Additions.swift
//  WhistScoreHolder
//
//  Created by OctavF on 03/03/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    class func prepareForCameraAlertView(handler: WSHAlertControllerDelegate) -> UIAlertController {
        let alertController = UIAlertController(title: "We will ask permission for camera usage", message:
            "Allowing access to camera will enable putting a face near each player's name", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (_) in
            handler.alertControllerDidTapOk(alertController)
        }))
        
        return alertController
    }
    
    class func cameraPermissionSettingsAlertView() -> UIAlertController {
        let alertController = UIAlertController(title: "Access settings", message: "Going to ENABLE camera access", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.Default, handler: { (_) in
            let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
            if let url = settingsUrl {
                UIApplication.sharedApplication().openURL(url)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        return alertController
    }
    
}

protocol WSHAlertControllerDelegate: class {
    func alertControllerDidTapOk(controller: UIAlertController)
}