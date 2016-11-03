//
//  WSHPlayerViewController.swift
//  WhistScoreHolder
//
//  Created by OctavF on 03/03/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

import UIKit
import AVFoundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


protocol WSHPlayerViewControllerDelegate: class {
    func didAddPlayer(_ sender: WSHPlayerViewController, player: WSHPlayer) -> Int
    func didEditPlayer(_ sender: WSHPlayerViewController, player: WSHPlayer)
}

class WSHPlayerViewController: UIViewController, WSHAlertControllerDelegate, WSHCameraViewDelegate {
    @IBOutlet fileprivate weak var doneButtonItem: UIBarButtonItem!
    @IBOutlet fileprivate weak var addButtonItem: UIBarButtonItem!
    @IBOutlet fileprivate weak var leftDoneButtonItem: UIBarButtonItem!
    @IBOutlet fileprivate weak var cancelButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var playerView: WSHPlayerView!
    
    weak var delegate: WSHPlayerViewControllerDelegate?
    
    var editPlayer: WSHPlayer? {
        didSet {
            if self.isViewLoaded && self.view.window != nil {
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
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    
    fileprivate func presentAddNameAlertView() {
        let alertController = UIAlertController(title: "Add a name", message:
            "Each player should have a name", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            self.playerView.focusName()
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func dismissAnimated() {
        playerView.resignKeyboardIfNeeded()
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func checkCameraPermission() {
        let avStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        switch avStatus {
        case .authorized:
            self.playerView.cameraView.permissionGranted = true
            break
            
        case .notDetermined:
            let alert = UIAlertController.prepareForCameraAlertView(self)
            self.present(alert, animated: true, completion: nil)
            break
            
        default:
            break
        }
    }
    
    
    // MARK: - WSHAlertControllerDelegate funcs
    
    
    func alertControllerDidTapOk(_ controller: UIAlertController) {
        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) { (granted) in
            if (granted) {
                self.playerView.cameraView.permissionGranted = true
            }
        }
    }
    
    
    // MARK: - WSHCameraViewDelegate funcs
    
    
    func cameraViewWantsToGiveCameraPermission(_ cameraView: WSHCameraView) {
        let alert = UIAlertController.cameraPermissionSettingsAlertView()
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Actions
    
    
    @IBAction func addButtonTapped(_ sender: AnyObject) {
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
    
    @IBAction func doneButtonTapped(_ sender: AnyObject) {
        let pleya = WSHPlayer(name: playerView.name)
        pleya.image = self.playerView.image
        pleya.colour = self.playerView.colorHex
        
        delegate?.didEditPlayer(self, player: pleya)
        dismissAnimated()
    }
    
    @IBAction func cancelButtonTapped(_ sender: AnyObject) {
        dismissAnimated()
    }
}
