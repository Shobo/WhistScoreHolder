//
//  WSHGameManagerDelegate.swift
//  WhistScoreHolder
//
//  Created by Mihai Costiug on 28/02/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

protocol WSHGameManagerDelegate: class {
    func gameManager(_ gameManager: WSHGameManager, didStartGame game: WSHGame)
    func gameManager(_ gameManager: WSHGameManager, didEndGame game: WSHGame)
    
    func willBeginRoundOfType(_ type: WSHRoundType, startingPlayer player: WSHPlayer)
    func playerTurnToBet(_ player: WSHPlayer, forRoundType roundType: WSHRoundType, excluding choice: WSHGameBetChoice?)
    func didFinishBettingInRound(_ round: WSHRound)
    func roundDidFinish(_ round: WSHRound, withBonuses bonuses: [WSHPlayer: Int])
}
