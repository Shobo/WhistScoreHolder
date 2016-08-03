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
    var bets: [WSHPlayer : Int] = [:]
    
    @IBOutlet weak var gridPlayersView: WSHGridView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.gridPlayersView.views = buttonsForPlayers()
    }

    
    //MARK: - Private functions
    
    
    private func buttonsForPlayers() -> [UIButton] {
        var buttons = [WSHBetButton]()
        var btn: WSHBetButton
        
        for pleya in self.players ?? [] {
            btn = self.configuredStandardChoiceButton(pleya)
            
            buttons.append(btn)
        }
        return buttons
    }
    
    private func configuredStandardChoiceButton(forPlayer: WSHPlayer) -> WSHBetButton {
        let button = WSHBetButton(type: .Custom)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.setBackgroundImage(forPlayer.image, forState: .Normal)
//        button.imageView?.contentMode = .ScaleAspectFit
        button.bottomLabel.text = forPlayer.name
        button.mainLabel.text = "0/\(bets[forPlayer]!)"
        
        button.addTarget(self, action: #selector(self.takeHandButtonPressed(_:)), forControlEvents: .TouchUpInside)
        
        button.tag = (self.players?.indexOf(forPlayer))!
        
        return button
    }
    
    
    //MARK: - Actions
    
    
    func takeHandButtonPressed(button: WSHBetButton) {
        if let delegate = self.delegate {
            if let pleya = self.players?[button.tag] {
                button.mainLabel.text = "\(delegate.handsActionControllerPlayerDidTakeHand(self, player: pleya))/\(bets[pleya]!)"
            }
        }
    }
    
}

protocol WSHHandsActionViewControllerDelegate {
    func handsActionControllerPlayerDidTakeHand(controller: WSHHandsActionViewController, player: WSHPlayer) -> Int
}