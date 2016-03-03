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
    
    private(set) var gameInProgress: Bool = false
    
    
    init() {
        
    }
    
    func startGame(game: WSHGame) {
        self.gameInProgress = true
        
        self.currentGame = game        
    }
    
    func saveCurrentGameState() {
        // save current game state on disk; should be called if app is closing and game is not over
    }
    
    func loadSavedGame() {
        // load game saved on disk; should be called when starting the app if a game has been saved
    }
    
    func startBetting() {
        //start sending delegate messages in order to receive betting information; playerTurnToBet:forRoundType:excluding:
    }
    
    //TODO: create custom ErrorType; to be used if a player adds a bet/hand when already containing that information within that round
    
    func player(player: WSHPlayer, didBet bet: WSHGameBetChoice) throws {
        //after saving the bet inside the current round, send another playerTurnToBet:forRoundType:excluding: to the delegate, unless it was the last one, in which case the didFinishBettingInRound: delegate method should be called
    }
    
    func player(player: WSHPlayer, didTake taken: WSHGameBetChoice) throws {
        //after saving the taken hand inside the current round, check if the rounds is completed. if it is, send the didFinishRound: delegate call + the willBeginRoundOfType:startingPlayer: method
    }
}
