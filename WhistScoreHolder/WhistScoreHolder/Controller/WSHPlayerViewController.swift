//
//  WSHPlayerViewController.swift
//  WhistScoreHolder
//
//  Created by OctavF on 03/03/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

import UIKit
import AVFoundation

protocol WSHPlayerViewControllerDelegate: class {
    func didAddPlayer(sender: WSHPlayerViewController, player: WSHPlayer) -> Int
    func didEditPlayer(sender: WSHPlayerViewController, player: WSHPlayer)
}

class WSHPlayerViewController: UIViewController, WSHAlertControllerDelegate, WSHCameraViewDelegate {
    @IBOutlet private weak var doneButtonItem: UIBarButtonItem!
    @IBOutlet private weak var addButtonItem: UIBarButtonItem!
    @IBOutlet private weak var leftDoneButtonItem: UIBarButtonItem!
    @IBOutlet private weak var cancelButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var playerView: WSHPlayerView!
    
    weak var delegate: WSHPlayerViewControllerDelegate?
    
    var editPlayer: WSHPlayer? {
        didSet {
            if self.isViewLoaded() && self.view.window != nil {
                playerView.name = editPlayer?.name ?? ""
                playerView.image = editPlayer?.image
                playerView.colorHex = (editPlayer?.colour)!
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.checkCameraPermission()
        playerView.cameraView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.rightBarButtonItems = []
        navigationItem.leftBarButtonItems = []
        
        if let player = editPlayer {
            navigationItem.rightBarButtonItem = doneButtonItem
            navigationItem.leftBarButtonItem = cancelButtonItem
            
            playerView.name = player.name ?? ""
            playerView.image = player.image
            playerView.colorHex = player.colour
        } else {
            navigationItem.rightBarButtonItem = addButtonItem
            navigationItem.leftBarButtonItem = leftDoneButtonItem
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
    
    private func checkCameraPermission() {
        let avStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        
        switch avStatus {
        case .Authorized:
            self.playerView.cameraView.permissionGranted = true
            break
            
        case .NotDetermined:
            let alert = UIAlertController.prepareForCameraAlertView(self)
            self.presentViewController(alert, animated: true, completion: nil)
            break
            
        default:
            break
        }
    }
    
    
    // MARK: - WSHAlertControllerDelegate funcs
    
    
    func alertControllerDidTapOk(controller: UIAlertController) {
        AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo) { (granted) in
            if (granted) {
                self.playerView.cameraView.permissionGranted = true
            }
        }
    }
    
    
    // MARK: - WSHCameraViewDelegate funcs
    
    
    func cameraViewWantsToGiveCameraPermission(cameraView: WSHCameraView) {
        let alert = UIAlertController.cameraPermissionSettingsAlertView()
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Actions
    
    
    @IBAction func addButtonTapped(sender: AnyObject) {
        if playerView.name.isEmpty {
            presentAddNameAlertView()
            
        } else {
            let pleya = WSHPlayer(name: playerView.name)
            pleya.image = self.playerView.image
            pleya.colour = self.playerView.colorHex
            
            if delegate?.didAddPlayer(self, player: pleya) < kMAX_NUMBER_OF_PLAYERS  {
                // todo: (foc) show a notification : "cutarica" added
                playerView.resetToDefault()
                
            } else {
                // todo: (foc) show a notification : added enough players
                dismissAnimated()
            }
        }
    }
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        let pleya = WSHPlayer(name: playerView.name)
        pleya.image = self.playerView.image
        pleya.colour = self.playerView.colorHex
        
        delegate?.didEditPlayer(self, player: pleya)
        dismissAnimated()
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        dismissAnimated()
    }
}