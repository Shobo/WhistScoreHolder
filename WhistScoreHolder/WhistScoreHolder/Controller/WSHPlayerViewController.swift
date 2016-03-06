//
//  WSHPlayerViewController.swift
//  WhistScoreHolder
//
//  Created by OctavF on 03/03/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

import UIKit

protocol WSHPlayerViewControllerDelegate: class {
    func didAddPlayer(sender: WSHPlayerViewController, player: WSHPlayer) -> Int
    func didEditPlayer(sender: WSHPlayerViewController, player: WSHPlayer)
}

class WSHPlayerViewController: UIViewController {
    @IBOutlet private weak var doneButtonItem: UIBarButtonItem!
    @IBOutlet private weak var addButtonItem: UIBarButtonItem!
    @IBOutlet weak var playerView: WSHPlayerView!
    
    weak var delegate: WSHPlayerViewControllerDelegate?
    
    var editPlayer: WSHPlayer? {
        didSet {
            if self.isViewLoaded() && self.view.window != nil {
                playerView.name = editPlayer?.name ?? ""
                playerView.image = editPlayer?.image ?? UIImage.randomColorImage(withSize: CGSizeZero)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if editPlayer != nil {
            navigationItem.rightBarButtonItems = []
            navigationItem.rightBarButtonItem = doneButtonItem
            
            playerView.name = editPlayer?.name ?? ""
            playerView.image = editPlayer?.image ?? UIImage.randomColorImage(withSize: CGSizeZero)
            
        } else {
            navigationItem.rightBarButtonItems = []
            navigationItem.rightBarButtonItem = addButtonItem
        }
    }
    
    
    // MARK: - Private funcs
    
    
    private func presentAddNameAlertView() {
        let alertController = UIAlertController(title: "Add a name", message:
            "Each player should have a name", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
            self.playerView.focusName()
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    private func dismissAnimated() {
        playerView.resignKeyboardIfNeeded()
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - Actions
    
    
    @IBAction func addButtonTapped(sender: AnyObject) {
        if playerView.name.isEmpty {
            presentAddNameAlertView()
            
        } else if delegate?.didAddPlayer(self, player: WSHPlayer(name: playerView.name, image: playerView.image)) < kMAX_NUMBER_OF_PLAYERS  {
            // todo: (foc) show a notification : "cutarica" added
            playerView.resetToDefault()
            
        } else {
            // todo: (foc) show a notification : added enough players
            dismissAnimated()
        }
    }
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        delegate?.didEditPlayer(self, player: WSHPlayer(name: playerView.name, image: playerView.image))
        dismissAnimated()
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        dismissAnimated()
    }
}