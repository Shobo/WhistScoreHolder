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
        let alertController = UIAlertController(title: "",//"We will ask permission for camera usage",
                                                message: NSLocalizedString("camera_put_a_face", comment: ""),
                                                preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""),
                                                style: UIAlertActionStyle.default, handler: { (_) in
            handler.alertControllerDidTapOk(alertController)
        }))
        
        return alertController
    }
    
    class func cameraPermissionSettingsAlertView() -> UIAlertController {
        let alertController = UIAlertController(title: NSLocalizedString("go_to_settings", comment: ""),
                                                message: NSLocalizedString("enable_camera_access_settings", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("settings", comment: ""),
                                                style: UIAlertActionStyle.default, handler: { (_) in
            let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)
            if let url = settingsUrl {
                UIApplication.shared.openURL(url)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""),
                                                style: UIAlertActionStyle.cancel, handler: nil))
        
        return alertController
    }
    
}

protocol WSHAlertControllerDelegate: class {
    func alertControllerDidTapOk(_ controller: UIAlertController)
}
