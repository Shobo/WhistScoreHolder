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
        setupNavigationBarButtonItems()
    }
    
    
    //MARK: - Actions
    
    
    func closeButtonTapped(sender: AnyObject) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //MARK: - Private UI methods
    
    
    private func setupNavigationBarButtonItems() {
        let score = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: #selector(WSHActionViewController.closeButtonTapped(_:)))
        
        self.navigationItem.rightBarButtonItem = score
    }
    
}
