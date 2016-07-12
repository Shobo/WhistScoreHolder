//
//  WSHHandsActionViewController.swift
//  WhistScoreHolder
//
//  Created by OctavF on 11/07/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

import UIKit

class WSHHandsActionViewController: WSHActionViewController {

    var delegate: WSHHandsActionViewControllerDelegate?
    
    var players: [WSHPlayer]?
    
    @IBOutlet weak var gridPlayersView: WSHGridView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.gridPlayersView.views = buttonsForPlayers()
    }

    
    //MARK: - Private functions
    
    
    private func buttonsForPlayers() -> [UIButton] {
        var buttons = [UIButton]()
        var btn: UIButton
        
        for pleya in self.players ?? [] {
            btn = self.configuredStandardChoiceButton(pleya)
            
            buttons.append(btn)
        }
        return buttons
    }
    
    private func configuredStandardChoiceButton(forPlayer: WSHPlayer) -> UIButton {
        let button = UIButton(type: .Custom)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
//        button.backgroundColor = UIColor(red: 127.5 / 255, green: 127.5 / 255, blue: 127.5 / 255, alpha: 0.5)
        button.setBackgroundImage(forPlayer.image, forState: .Normal)
//        button.setImage(forPlayer.image, forState: .Normal)
        button.imageView?.contentMode = .ScaleAspectFit
        button.setTitle(forPlayer.name, forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(100)
        button.titleLabel?.textAlignment = .Center
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.05
        button.setTitleColor(UIColor.blackColor().colorWithAlphaComponent(0.85), forState: .Normal)
        
        button.addTarget(self, action: #selector(self.takeHandButtonPressed(_:)), forControlEvents: .TouchUpInside)
        
        button.tag = (self.players?.indexOf(forPlayer))!
        
        return button
    }
    
    
    //MARK: - Actions
    
    
    func takeHandButtonPressed(button: UIButton) {
        if let delegate = self.delegate {
            delegate.handsActionControllerPlayerDidTakeHand(self, player: (self.players?[button.tag])!)
        }
    }
    
}

protocol WSHHandsActionViewControllerDelegate {
    func handsActionControllerPlayerDidTakeHand(controller: WSHHandsActionViewController, player: WSHPlayer)
}