//
//  WSHBettingActionViewController.swift
//  WhistScoreHolder
//
//  Created by Mihai Costiug on 15/04/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

import UIKit

class WSHBettingActionViewController: WSHActionViewController {
    
    @IBOutlet private weak var playerImageView: UIImageView!
    @IBOutlet private weak var playerNameLabel: UILabel!
    @IBOutlet private weak var bettingOptionsView: UIView!
    
    var playerName: String?
    var playerImage: UIImage?
    var playerOptions: [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.playerNameLabel.text = "\(self.playerName ?? "Player")'s turn to bet"
        self.playerImageView.image = playerImage
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.bettingOptionsView.populateWithEqualSizedViews(self.playerOptions)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        //different UI for landscape in storyboard; 3:5 multiplier for width
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        coordinator.animateAlongsideTransition({ (_) in
            self.bettingOptionsView.populateWithEqualSizedViews(self.playerOptions)
            }, completion: nil)
    }
    
}
