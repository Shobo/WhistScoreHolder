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
    
    @IBOutlet private weak var bettingOptionsView: WSHGridView!
    @IBOutlet private weak var playerNameLabel: UILabel!
    @IBOutlet private weak var playerImageView: UIImageView!
    
    var playerName: String?
    var playerImage: UIImage?
    var playerOptions: [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.playerNameLabel.text = "\(self.playerName ?? "Player")'s"
        self.playerImageView.image = playerImage
        
        self.bettingOptionsView.views = self.playerOptions
    }
    
    
    //MARK: - Private UI functions
    
    
    
}
