//
//  WSHGameManager.swift
//  WhistScoreHolder
//
//  Created by Mihai Costiug on 28/02/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

let kMIN_NUMBER_OF_PLAYERS = 3
let kMAX_NUMBER_OF_PLAYERS = 6

enum WSHGameManagerState {
    case Idle
    case Shuffling
    case Betting
    case Taking
}

class WSHGameManager {
    
    static let sharedInstance = WSHGameManager()
    
    weak var delegate: WSHGameManagerDelegate?
    
    private(set) var currentGame: WSHGame?
    private(set) var currentRound: WSHRound?
    
    private var currentRoundIndex = -1
    private var currentStartingPlayerIndex: Int = -1 {
        didSet {
            if currentStartingPlayerIndex >= self.currentGame?.players.count {  //if index exceeds player count, go back to the first one
                currentStartingPlayerIndex -= currentStartingPlayerIndex
            }
        }
    }
    
    private(set) var gameState: WSHGameManagerState = .Idle
    
    init() {
        
    }
    
    func startGameWithPlayers(players: [WSHPlayer]) {
        if !(3..<7).contains(players.count) {
            return  //throw error if number of players is not between 3 and 6
        }
        
        let game = WSHGame(players: players)
        self.currentGame = game
        
        self.advanceToNextRound()
    }
    
    func saveCurrentGameState() {
        // save current game state on disk; should be called if app is closing and game is not over
    }
    
    func loadSavedGame() {
        // load game saved on disk; should be called when starting the app if a game has been saved
    }
    
    func startBetting() {
        //start sending delegate messages in order to receive betting information; playerTurnToBet:forRoundType:excluding:
        if self.gameState != .Shuffling {
            return  //throw error if betting is started when not in shuffling mode
        }
        
        self.gameState = .Betting
        
        //setup betting round and call "advanceToNextBet"
    }
    
    //TODO: create custom ErrorType; to be used if a player adds a bet/hand when already containing that information within that round
    
    func player(player: WSHPlayer, didBet bet: WSHGameBetChoice) throws {
        //after saving the bet inside the current round, send another playerTurnToBet:forRoundType:excluding: to the delegate, unless it was the last one, in which case the didFinishBettingInRound: delegate method should be called
    }
    
    func player(player: WSHPlayer, didTake taken: WSHGameBetChoice) throws {
        //after saving the taken hand inside the current round, check if the rounds is completed. if it is, send the didFinishRound: delegate call + the willBeginRoundOfType:startingPlayer: method
    }
    
    // MARK: - Private
    
    private func advanceToNextRound() {
        self.gameState = .Shuffling
        
        self.currentRoundIndex++
        self.currentStartingPlayerIndex++
        
        self.currentRound = self.currentGame?.rounds[self.currentRoundIndex]
        
        if self.currentRound != nil {
            self.delegate?.willBeginRoundOfType(self.currentRound!.roundType, startingPlayer: self.currentGame!.players[self.currentStartingPlayerIndex]) //change index accordingly
        } else if self.currentRoundIndex >= self.currentGame!.rounds.count {
            //game is over
        }
    }
    
    private func advanveToNextBet() {
        
    }
}
