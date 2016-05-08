//
//  WSHGameManagerDelegate.swift
//  WhistScoreHolder
//
//  Created by Mihai Costiug on 28/02/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

protocol WSHGameManagerDelegate: class {
    func gameManager(gameManager: WSHGameManager, didStartGame game: WSHGame)
    func gameManager(gameManager: WSHGameManager, didEndGame game: WSHGame)
    
    func willBeginRoundOfType(type: WSHRoundType, startingPlayer player: WSHPlayer)
    func playerTurnToBet(player: WSHPlayer, forRoundType roundType: WSHRoundType, excluding choice: WSHGameBetChoice?)
    func didFinishBettingInRound(round: WSHRound)
    func roundDidFinish(round: WSHRound, withBonuses bonuses: [WSHPlayer: Int])
}