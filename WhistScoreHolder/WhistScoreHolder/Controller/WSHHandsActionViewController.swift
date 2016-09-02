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
    var round: WSHRound?
    
    private var theButtons: [WSHBetButton] = []
    
    @IBOutlet weak var gridPlayersView: WSHGridView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.gridPlayersView.views = buttonsForPlayers()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.refreshButtonsText()
    }
    
    override func undoAction(button: UIButton) {
        super.undoAction(button)
        
        self.refreshButtonsText()
    }
    
    
    //MARK: - Private functions
    
    
    private func buttonsForPlayers() -> [UIButton] {
        var buttons = [WSHBetButton]()
        var btn: WSHBetButton
        
        for pleya in self.round?.players ?? [] {
            btn = self.configuredStandardChoiceButton(pleya)
            
            buttons.append(btn)
        }
        self.theButtons = buttons
        
        return buttons
    }
    
    private func configuredStandardChoiceButton(forPlayer: WSHPlayer) -> WSHBetButton {
        let button = WSHBetButton(type: .Custom)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.setBackgroundImage(forPlayer.presentableImage(), forState: .Normal)
        
        button.bottomLabel.text = forPlayer.name
        if let _ = forPlayer.image {
            button.filter = WSHUIFilterType.White
        } else {
            button.filter = WSHUIFilterType.Zero
        }
        let hands = round?.roundInformation[forPlayer]?.hands.intValue ?? 0
        let bet = round?.roundInformation[forPlayer]?.bet.intValue ?? 0
        
        button.mainLabel.text = "\(hands)/\(bet)"
        
        button.addTarget(self, action: #selector(self.takeHandButtonPressed(_:)), forControlEvents: .TouchUpInside)
        
        button.tag = self.round?.players.indexOf(forPlayer) ?? 0
        
        return button
    }
    
    private func refreshButtonsText() {
        for btn in self.theButtons {
            if let pleya = self.round?.players[btn.tag] {
                let hands = round?.roundInformation[pleya]?.hands.intValue ?? 0
                let bet = round?.roundInformation[pleya]?.bet.intValue ?? 0
                
                btn.mainLabel.text = "\(hands)/\(bet)"
            }
            
        }
    }
    
    
    //MARK: - Actions
    
    
    func takeHandButtonPressed(button: WSHBetButton) {
        if let delegate = self.delegate {
            if let pleya = self.round?.players[button.tag] {
                let bet = round?.roundInformation[pleya]?.bet.intValue ?? 0
                button.mainLabel.text = "\(delegate.handsActionControllerPlayerDidTakeHand(self, player: pleya))/\(bet)"
            }
        }
    }
    
}

protocol WSHHandsActionViewControllerDelegate {
    func handsActionControllerPlayerDidTakeHand(controller: WSHHandsActionViewController, player: WSHPlayer) -> Int
}