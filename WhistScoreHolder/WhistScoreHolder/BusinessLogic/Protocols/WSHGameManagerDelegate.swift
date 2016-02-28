//
//  WSHGameManagerDelegate.swift
//  WhistScoreHolder
//
//  Created by Mihai Costiug on 28/02/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

protocol WSHGameManagerDelegate {
    func gameManager(gameManager: WSHGameManager, didStartGame game: WSHGame)
    func gameManager(gameManager: WSHGameManager, didEndGame game: WSHGame)
    
    func currentGame(game: WSHGame, didChangeCurrentRoundNumber routeNumber: Int, ofType: WSHGameBetChoice)
}