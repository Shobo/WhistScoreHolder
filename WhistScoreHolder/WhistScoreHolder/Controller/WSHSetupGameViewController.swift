//
//  WSHSetupGameViewController.swift
//  WhistScoreHolder
//
//  Created by OctavF on 29/02/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

import UIKit

class WSHSetupGameViewController: UIViewController {
    @IBOutlet weak var playerView: WSHPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.redColor()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func playButtonTapped(sender: AnyObject) {
        // TODO: (foc) start the game
    }
    
    @IBAction func addButtonTapped(sender: AnyObject) {
        // TODO: (foc) add player to the game
    }
    
    // MARK: - Notifications
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.playerView.keyBoardHeightChanged(keyboardSize.height)
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.playerView.keyBoardHeightChanged(0)
    }
}
