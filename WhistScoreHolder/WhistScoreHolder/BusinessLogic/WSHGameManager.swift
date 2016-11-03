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
    
    fileprivate(set) var currentGame: WSHGame?
    
    fileprivate(set) var gameState: WSHGameManagerState = .idle
    
    fileprivate var lastTakingOrder: [WSHPlayer] = []
    
    init() {
        
    }
    
    
    // MARK:- Starting and resetting
    
    
    func startGameWithPlayers(_ players: [WSHPlayer]) {
        if self.gameState != .idle {
            return  //cannot start game when game in progress
        }
        if !(kMIN_NUMBER_OF_PLAYERS..<kMAX_NUMBER_OF_PLAYERS + 1).contains(players.count) {
            return  //throw error if number of players is not between 3 and 6
        }
        
        let game = WSHGame(players: players)
        self.currentGame = game
        
        self.advanceToNextRound()
    }
    
    func undo() {
        if let currentRound = self.currentGame?.currentRound {
            if currentRound.roundInformation.count == 0 { // current round just started -- undo to previous round
                if self.lastTakingOrder.count == 0 {
                    return
                }
                self.currentGame?.revertToPreviousRound()
                self.revertLastTaking()
                
                guard let round = self.currentGame?.currentRound else  {
                    return
                }
                self.delegate?.didFinishBettingInRound(round)
                self.gameState = .taking
                
            } else if self.lastTakingOrder.count == 0 { // undo betting
                self.gameState = .betting
                self.revertLastBet()
                
            } else { // undo taking
                self.gameState = .taking
                self.revertLastTaking()
            }
        }
    }
    
    func canUndo() -> Bool {
        if let currentRound = self.currentGame?.currentRound {
            if currentRound.roundInformation.count == 0 { // current round just started -- undo to previous round
                if self.lastTakingOrder.count == 0 {
                    return false
                }
            }
        }
        return true
    }
    
    func resetAllData() {   //everything to default vaue
        self.currentGame = nil  //should release rounds, players and everything; double check with instruments
        self.gameState = .idle
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
        if self.gameState != .shuffling {
            return  //throw error if betting is started when not in shuffling mode
        }
        
        self.gameState = .betting
        
        self.advanceToNextBet()
    }
    
    func startNextRound() {
        self.advanceToNextRound()
    }
        
    func player(_ player: WSHPlayer, didBet bet: WSHGameBetChoice) throws {
        //after saving the bet inside the current round, send another playerTurnToBet:forRoundType:excluding: to the delegate, unless it was the last one, in which case the didFinishBettingInRound: delegate method should be called
        do {
            try self.validateBet(bet, forPlayer: player)
            
            self.currentGame!.currentRound!.addBet(bet, forPlayer: player)
            self.advanceToNextBet()
            
            if lastTakingOrder.count > 0 {
                lastTakingOrder = []
            }
        } catch let error {
            throw error
        }
    }
    
    func playerDidTakeHand(_ player: WSHPlayer) throws {
        //after saving the taken hand inside the current round, check if the round is completed. if it is, send the willBeginRoundOfType:startingPlayer: delegate method
        do {
            try self.validateHandForPlayer(player)
            
            guard let round = self.currentGame!.currentRound else {
                return
            }
            round.addHandForPlayer(player)
            self.lastTakingOrder.append(player)
            
            if round.isRoundComplete {
                self.delegate?.roundDidFinish(round, withBonuses: self.currentGame?.playerBonusesPerRound[round] ?? [:])
            }
        } catch let error {
            throw error
        }
    }
    
    
    // MARK: - Private
    
    
    fileprivate func advanceToNextRound() {
        self.gameState = .shuffling
        
        let lastRound = self.currentGame!.currentRound
        self.currentGame?.advanceToNextRound()
        
        if let round = self.currentGame!.currentRound {
            if lastRound == nil {
                //first round
                round.players = self.currentGame!.players
            } else {
                round.players = self.reorderList(lastRound!.players, index: 1)
            }
            
            self.delegate?.willBeginRoundOfType(round.roundType, startingPlayer: round.players.first!)
        } else {
            //game is over
            self.delegate?.gameManager(self, didEndGame: self.currentGame!)
            self.resetAllData()
        }
    }
    
    fileprivate func advanceToNextBet() {
        //check if all players have placed bets
        guard let round = self.currentGame?.currentRound else {
            return
        }
        
        if round.areAllBetsPlaced {
            self.delegate?.didFinishBettingInRound(round)
            self.gameState = .taking
        } else if let currentPlayer = round.currentBettingPlayer {
            self.delegate?.playerTurnToBet(currentPlayer,
                                           forRoundType: self.currentGame!.currentRound!.roundType,
                                           excluding: self.currentGame!.currentRound!.excludedGameChoiceForPlayer(currentPlayer))   //calculate exluding possibilities
        }
    }
    
    fileprivate func revertLastBet() {
        guard let round = self.currentGame?.currentRound else {
            return
        }
        self.gameState = .betting
        round.revertLastBet()
        
        if let currentPlayer = round.currentBettingPlayer {
            self.delegate?.playerTurnToBet(currentPlayer,
                                           forRoundType: self.currentGame!.currentRound!.roundType,
                                           excluding: self.currentGame!.currentRound!.excludedGameChoiceForPlayer(currentPlayer))   //calculate exluding possibilities
        }
    }
    
    fileprivate func revertLastTaking() {
        guard let round = self.currentGame?.currentRound else {
            return
        }
        if let pleya = self.lastTakingOrder.popLast() {
            round.removeHandFromPlayer(pleya)
        }
    }
    
    fileprivate func validateBet(_ bet: WSHGameBetChoice, forPlayer player: WSHPlayer) throws {
        if self.gameState != .betting {
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
    
    fileprivate func validateHandForPlayer(_ player: WSHPlayer) throws {
        if self.gameState != .taking {
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
    
    
    fileprivate func reorderList<T>(_ list: [T], index: Int) -> [T] {  //returns the ordered list starting from given index
        var i = 0
        let separated = list.split(maxSplits: 2, omittingEmptySubsequences: false) { (_) -> Bool in
            let result = i == index
            i += 1
            return result
        }
        
        return [list[index]] as [T] + separated[1] + separated[0]
    }
}
