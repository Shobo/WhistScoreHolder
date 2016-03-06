//
//  UIAlertController+Additions.swift
//  WhistScoreHolder
//
//  Created by OctavF on 03/03/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

import UIKit

extension UIAlertController {
    class func tooManyPlayersAlertView() -> UIAlertController {
        let alertController = UIAlertController(title: "Too many players", message:
            "Maximum number of players: 6", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil))
        
        return alertController
    }
}
