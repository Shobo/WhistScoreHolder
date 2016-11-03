//
//  WSHBettingActionViewController.swift
//  WhistScoreHolder
//
//  Created by Mihai Costiug on 15/04/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

import UIKit

let kPlayerTitleViewWidth: CGFloat = 212.0

class WSHBettingActionViewController: WSHActionViewController {
    
    @IBOutlet fileprivate weak var bettingOptionsView: WSHGridView!
    @IBOutlet fileprivate weak var playerNameLabel: UILabel!
    @IBOutlet fileprivate weak var playerImageView: UIImageView!
    
    var playerName: String? {
        didSet {
            self.playerNameLabel?.text = "\(self.playerName ?? "Player")'s"
        }
    }
    var playerImage: UIImage? {
        didSet {
            self.playerImageView?.image = playerImage
        }
    }
    var playerOptions: [UIView] = [] {
        didSet {
            self.bettingOptionsView?.views = playerOptions
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.playerNameLabel.text = "\(self.playerName ?? "Player")'s"
        self.playerImageView.image = playerImage
        
        self.bettingOptionsView.views = self.playerOptions
    }
    
    
    //MARK: - Private UI functions
    
    
    
}
