//
//  WSHGameManager.swift
//  WhistScoreHolder
//
//  Created by Mihai Costiug on 28/02/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

class WSHGameManager {
    
    static let sharedInstance = WSHGameManager()
    
    weak var delegate: WSHGameManagerDelegate?
    
    private(set) var currentGame: WSHGame?
    
    private(set) var gameState: WSHGameManagerState = .Idle
    
    init() {
        
    }
    
    // MARK:- Starting and resetting
    
    func startGameWithPlayers(players: [WSHPlayer]) {
        if self.gameState != .Idle {
            return  //cannot start game when game in progress
        }
        if !(kMIN_NUMBER_OF_PLAYERS..<kMAX_NUMBER_OF_PLAYERS + 1).contains(players.count) {
            return  //throw error if number of players is not between 3 and 6
        }
        
        let game = WSHGame(players: players)
        self.currentGame = game
        
        self.advanceToNextRound()
    }
    
    func resetAllData() {   //everything to default vaue
        self.currentGame = nil  //should release rounds, players and everything; double check with instruments
        self.gameState = .Idle
    }
    
    // MARK:- Persistent games
    
    func saveCurrentGameState() {
        // save current game state on disk; should be called if app is closing and game is not over
    }
    
    func loadSavedGame() {
        // load game saved on disk; should be called when starting the app if a game has been saved
    }
    
    // MARK:- Reporting
    
    func startBetting() {
        //start sending delegate messages in order to receive betting information; playerTurnToBet:forRoundType:excluding:
        if self.gameState != .Shuffling {
            return  //throw error if betting is started when not in shuffling mode
        }
        
        self.gameState = .Betting
        
        self.advanceToNextBet()
    }
        
    func player(player: WSHPlayer, didBet bet: WSHGameBetChoice) throws {
        //after saving the bet inside the current round, send another playerTurnToBet:forRoundType:excluding: to the delegate, unless it was the last one, in which case the didFinishBettingInRound: delegate method should be called
        do {
            try self.validateBet(bet, forPlayer: player)
            
            self.currentGame!.currentRound!.addBet(bet, forPlayer: player)
            self.advanceToNextBet()
        } catch let error {
            throw error
        }
    }
    
    func playerDidTakeHand(player: WSHPlayer) throws {
        //after saving the taken hand inside the current round, check if the round is completed. if it is, send the willBeginRoundOfType:startingPlayer: delegate method
        do {
            try self.validateHandForPlayer(player)
            
            self.currentGame!.currentRound!.addHandForPlayer(player)
            
            if self.currentGame!.currentRound!.isRoundComplete {
                self.advanceToNextRound()
            }
        } catch let error {
            throw error
        }
    }
    
    // MARK: - Private
    
    private func advanceToNextRound() {
        self.gameState = .Shuffling
        
        let lastRound = self.currentGame!.currentRound
        self.currentGame?.advanceToNextRound()
        
        if self.currentGame!.currentRound != nil {
            if lastRound == nil {
                //first round
                self.currentGame!.currentRound!.players = self.currentGame!.players
            } else {
                self.currentGame!.currentRound!.players = self.reorderList(lastRound!.players, index: 1)
            }
            
            self.delegate?.willBeginRoundOfType(self.currentGame!.currentRound!.roundType, startingPlayer: self.currentGame!.currentRound!.players.first!)
        } else {
            //game is over
            self.delegate?.gameManager(self, didEndGame: self.currentGame!)
            self.resetAllData()
        }
    }
    
    private func advanceToNextBet() {
        //check if all players have placed bets
        if self.currentGame!.currentRound!.areAllBetsPlaced {
            self.delegate?.didFinishBettingInRound(self.currentGame!.currentRound!)
            self.gameState = .Taking
        } else {
            let currentPlayer = self.currentGame!.currentRound!.currentBettingPlayer!
            self.delegate?.playerTurnToBet(currentPlayer,
                forRoundType: self.currentGame!.currentRound!.roundType,
                excluding: self.currentGame!.currentRound!.excludedGameChoiceForPlayer(currentPlayer))   //calculate exluding possibilities
        }
    }
    
    private func validateBet(bet: WSHGameBetChoice, forPlayer player: WSHPlayer) throws {
        if self.gameState != .Betting {
            //throw error; user cannot bet unlease in betting mode
        }
        
        //throw error if player is not in game
        if !self.currentGame!.players.contains(player) {
            //throw error; player that is not part of the game cannot interact
        }
        
        if self.currentGame!.currentRound!.didPlayerAlreadyBetInCurrentRound(player) {
            // throw error; player cannot bet thwice
        }
        
        if self.currentGame!.currentRound!.currentBettingPlayer != player {
            //throw error; not the turn of this player
        }
    }
    
    private func validateHandForPlayer(player: WSHPlayer) throws {
        if self.gameState != .Taking {
            //throw error; user cannot take unlease in taking mode
        }
        //throw error if taken count exceeds current round type
        if self.currentGame!.currentRound!.takenHands + 1 >= self.currentGame!.currentRound!.roundType.intValue {
            
        }
        //throw error if player is not in game
        if !self.currentGame!.players.contains(player) {
            //throw error; player that is not part of the game cannot interact
        }
    }
    
    //MARK:- Utils
    
    private func reorderList<T>(list: [T], index: Int) -> [T] {  //returns the ordered list starting from given index
        var i = 0
        let separated = list.split(2, allowEmptySlices: true) { (_) -> Bool in
            let result = i == index
            i += 1
            return result
        }
        
        return [list[index]] + separated[1] + separated[0]
    }
}
