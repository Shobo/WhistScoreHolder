//
//  WSHActionViewController.swift
//  WhistScoreHolder
//
//  Created by OctavF on 02/04/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

import UIKit

class WSHActionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    // MARK: - Actions
    
    
    @IBAction func closeButtonTapped(sender: AnyObject) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
