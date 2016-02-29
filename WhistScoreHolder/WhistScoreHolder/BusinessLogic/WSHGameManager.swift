//
//  WSHGameManager.swift
//  WhistScoreHolder
//
//  Created by Mihai Costiug on 28/02/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

class WSHGameManager {
    
    static let sharedInstance = WSHGameManager()
    
    private(set) var currentGame: WSHGame?
    private(set) var currentRound: WSHRound?
    
    private(set) var gameStarted: Bool = false
    
    
    
    init() {
        
    }
    
    func startGame(game: WSHGame) {
        self.gameStarted = true
        
        self.currentGame = game
        
    }
    
    func player(player: WSHPlayer, didBet bet: WSHGameBetChoice) {
        
    }
    
    func player(player: WSHPlayer, didTake taken: WSHGameBetChoice) {
        
    }
}
