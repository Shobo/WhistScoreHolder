//
//  UIAlertController+Additions.swift
//  WhistScoreHolder
//
//  Created by OctavF on 03/03/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    class func prepareForCameraAlertView(_ handler: WSHAlertControllerDelegate) -> UIAlertController {
        let alertController = UIAlertController(title: "We will ask permission for camera usage", message:
            "Allowing access to camera will enable putting a face near each player's name", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (_) in
            handler.alertControllerDidTapOk(alertController)
        }))
        
        return alertController
    }
    
    class func cameraPermissionSettingsAlertView() -> UIAlertController {
        let alertController = UIAlertController(title: "Access settings", message: "ENABLE camera access from settings", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.default, handler: { (_) in
            let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)
            if let url = settingsUrl {
                UIApplication.shared.openURL(url)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        return alertController
    }
    
}

protocol WSHAlertControllerDelegate: class {
    func alertControllerDidTapOk(_ controller: UIAlertController)
}
