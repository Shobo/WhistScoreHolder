//
//  WSHRound.swift
//  WhistScoreHolder
//
//  Created by Mihai Costiug on 29/02/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

import Foundation

class WSHRound: NSObject {
    
    fileprivate(set) var roundType: WSHRoundType
    fileprivate(set) var roundInformation: [WSHPlayer: (bet: WSHGameBetChoice, hands: WSHGameBetChoice)] = [:]
    fileprivate(set) var playerScores: [WSHPlayer: Int] = [:]
    var players: [WSHPlayer] = [] {   //array of players in current round, arranged in order
        didSet {
            self.currentBettingPlayer = self.players.first  //when initializing the players array, the first player is the current betting one
            self.initializePlayerScores()
        }
    }
    fileprivate(set) var currentBettingPlayer: WSHPlayer?
    
    var bettedHands: Int {
        get {
            var numberOfHands = 0
            
            for (_, (bet: bet, hands: _)) in self.roundInformation {
                numberOfHands += bet.intValue
            }
            
            return numberOfHands
        }
    }
    
    var takenHands: Int {
        get {
            var numberOfHands = 0
            
            for (_, (bet: _, hands: hands)) in self.roundInformation {
                numberOfHands += hands.intValue
            }
            
            return numberOfHands
        }
    }
    
    var isRoundComplete: Bool {
        get {
            if self.players.count == 0 || !self.areAllBetsPlaced {
                return false
            }
            
            var handsCounter = 0
            
            for player in self.players {
                handsCounter += self.roundInformation[player]!.hands.intValue
            }
            
            return handsCounter == self.roundType.intValue  //round is complete if all hands are declared
        }
    }
    
    var areAllBetsPlaced: Bool {
        get {
            if self.players.count == 0 {
                return false
            }
            
            for player in self.players {
                if self.roundInformation[player] == nil {
                    return false
                }
            }
            
            return true
        }
    }
    
    init(roundType: WSHRoundType) {
        self.roundType = roundType
    }
    
    func reset() {
        self.roundInformation = [:]
        self.playerScores = [:]
        self.currentBettingPlayer = self.players.first  //when initializing the players array, the first player is the current betting one
        self.initializePlayerScores()
    }
    
    func addBet(_ bet: WSHGameBetChoice, forPlayer player: WSHPlayer) {
        //check if bet is added for currentBettingPlayer and switch to next betting player
        if player == self.currentBettingPlayer {
            self.roundInformation[player] = (bet: bet, hands: WSHGameBetChoice.zero)
            
            if player != self.players.last {
                self.currentBettingPlayer = self.players[self.players.index(of: player)! + 1]
            } else {
                self.currentBettingPlayer = nil
            }
        }
    }
    
    func revertLastBet() { // all history of player is lost (you are in WSHRound class)
        if self.areAllBetsPlaced {
            self.currentBettingPlayer = self.players.last
        } else {
            if let currentBetter = self.currentBettingPlayer {
                let currentBetterIndex = self.players.index(of: currentBetter)!
                
                if currentBetterIndex > 0 {
                    self.currentBettingPlayer = self.players[currentBetterIndex - 1]
                }
            }
        }
        guard let player = self.currentBettingPlayer else {
            return
        }
        self.roundInformation[player] = nil
    }
    
    func addHandForPlayer(_ player: WSHPlayer) {
        //increment "hands" for current player
        if let info = self.roundInformation[player] {
            let currentHands = info.hands.intValue
            self.roundInformation[player]?.hands = WSHGameBetChoice(rawValue: currentHands + 1)!
        }
        
        if self.isRoundComplete {
            self.calculateScores()
        }
    }
    
    func removeHandFromPlayer(_ fromPlayer: WSHPlayer) {
        let fromPlayerBet = self.roundInformation[fromPlayer]?.bet ?? WSHGameBetChoice.zero
        var fromPlayerHand = self.roundInformation[fromPlayer]?.hands ?? WSHGameBetChoice.zero
        
        if fromPlayerHand.intValue > 0 {
            fromPlayerHand = WSHGameBetChoice(rawValue: fromPlayerHand.intValue - 1) ?? .zero
        }
        self.roundInformation[fromPlayer] = (bet: fromPlayerBet, hands: fromPlayerHand)
    }
    
    func excludedGameChoiceForPlayer(_ player: WSHPlayer) -> WSHGameBetChoice? {
        if !self.isPlayerLastInCurrentRound(player) {
            return nil
        }
        let notAllowedChoice = self.roundType.intValue - self.currentTotalOfBetsAndHands().betsNumber
        
        if 0..<self.roundType.intValue + 1 ~= notAllowedChoice {    //if notAllowedChoice is in range of 0..roundType then return the excluded choice
            return WSHGameBetChoice(rawValue: notAllowedChoice)
        }
        
        return nil
    }
    
    func didPlayerAlreadyBetInCurrentRound(_ player: WSHPlayer) -> Bool { //rename and maybe move this?
        return self.roundInformation[player]?.bet != nil
    }
    
    // MARK:- Private
    
    fileprivate func currentTotalOfBetsAndHands() -> (betsNumber: Int, handsNumber: Int) {
        var totalBets = 0
        var totalHands = 0
        
        for (_, (bet: bet, hands: hands)) in self.roundInformation {
            totalBets += bet.intValue
            totalHands += hands.intValue
        }
        
        return (totalBets, totalHands)
    }
    
    fileprivate func isPlayerLastInCurrentRound(_ player: WSHPlayer) -> Bool {
        return self.players.last == player
    }
    
    fileprivate func calculateScores() {
        for player in self.players {
            self.playerScores[player] = self.pointsForPlayer(player)
        }
    }
    
    fileprivate func pointsForPlayer(_ player: WSHPlayer) -> Int {
        var points = 0
        
        if self.playerDidGuessCorrectly(player) {
            points += kCORRECT_GUESS_POINTS
            points += self.roundInformation[player]!.bet.intValue
        } else {
            points -= abs(self.roundInformation[player]!.bet.intValue - self.roundInformation[player]!.hands.intValue)
        }
        
        return points
    }
    
    fileprivate func playerDidGuessCorrectly(_ player: WSHPlayer) -> Bool {
        let playerInformation = self.roundInformation[player]
        
        if playerInformation == nil {
            return false
        } else {
            return playerInformation!.bet.intValue == playerInformation!.hands.intValue
        }
    }
    
    fileprivate func initializePlayerScores() {
        for player in self.players {
            self.playerScores[player] = 0
        }
    }
}
