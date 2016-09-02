//
//  WSHGame.swift
//  WhistScoreHolder
//
//  Created by Mihai Costiug on 28/02/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//
import UIKit

class WSHGame {
    
    private(set) var players:[WSHPlayer]
    private(set) var rounds: [WSHRound] = []
    private(set) var currentRound: WSHRound?
    private(set) var totalPlayerScores: [WSHPlayer: Int] = [:]
    private(set) var playerBonusesPerRound: [WSHRound : [WSHPlayer: Int]] = [:]
    private var counterForPlayerRightGuesses: [WSHPlayer: Int] = [:]
    
    var totalNumberOfRounds: Int {
        get {
            return self.players.count * 3 + 6 * 2   //6 intermediary rounds * 2 + two sets of rounds of 1 and one of 8
        }
    }
    
    init(players: [WSHPlayer]) {
        self.players = players
        
        self.createRounds()
        self.initializePlayerScores()
        self.resetCounterForPlayerRightGuesses()
    }
    
    func advanceToNextRound() {
        guard let round = self.currentRound else {
            self.currentRound = self.rounds.first
            return
        }
        
        self.addScoresFromRound(round)
        
        if round != self.rounds.last {
            let indexOfCurrentRound = self.rounds.indexOf(round)!
            self.currentRound = self.rounds[indexOfCurrentRound + 1]
        } else {
            self.currentRound = nil
        }
    }
    
    func revertToPreviousRound() {
        guard let round = self.currentRound else {
            self.currentRound = self.rounds.first
            return
        }
        if round == self.rounds.first {
            return
        }
        //all data of current round will be lost
        self.revertScoresForRound(round)
        round.reset()
        self.currentRound = self.rounds[(self.rounds.indexOf(round) ?? 0) - 1]
        
        if let asdf = self.currentRound {
            self.revertScoresForRound(asdf)
        }
    }
    
    
    //MARK:- Private
    
    
    private func createRounds() {
        //create round objects based on number of players
        self.rounds.appendContentsOf(self.createRounds(self.players.count, ofType: .One))
        self.rounds.appendContentsOf(self.createRounds(1, ofType: .Two))
        self.rounds.appendContentsOf(self.createRounds(1, ofType: .Three))
        self.rounds.appendContentsOf(self.createRounds(1, ofType: .Four))
        self.rounds.appendContentsOf(self.createRounds(1, ofType: .Five))
        self.rounds.appendContentsOf(self.createRounds(1, ofType: .Six))
        self.rounds.appendContentsOf(self.createRounds(1, ofType: .Seven))
        self.rounds.appendContentsOf(self.createRounds(self.players.count, ofType: .Eight))
        self.rounds.appendContentsOf(self.createRounds(1, ofType: .Seven))
        self.rounds.appendContentsOf(self.createRounds(1, ofType: .Six))
        self.rounds.appendContentsOf(self.createRounds(1, ofType: .Five))
        self.rounds.appendContentsOf(self.createRounds(1, ofType: .Four))
        self.rounds.appendContentsOf(self.createRounds(1, ofType: .Three))
        self.rounds.appendContentsOf(self.createRounds(1, ofType: .Two))
        self.rounds.appendContentsOf(self.createRounds(self.players.count, ofType: .One))
    }
    
    private func createRounds(numberOfRounds: Int, ofType type: WSHRoundType) -> [WSHRound] {
        var rounds: [WSHRound] = []
        
        for _ in 0..<numberOfRounds {
            let round = WSHRound(roundType: type)
            rounds.append(round)
        }
        
        return rounds
    }
    
    private func initializePlayerScores() {
        for player in self.players {
            self.totalPlayerScores[player] = 0
        }
    }
    
    private func resetCounterForPlayerRightGuesses() {
        for player in self.players {
            self.counterForPlayerRightGuesses[player] = 0
        }
    }
    
    private func addScoresFromRound(round: WSHRound) {
        for player in self.players {
            self.totalPlayerScores[player]! += round.playerScores[player]!
        }
        
        //check for BONUS points
        if round.roundType == .One {
            self.resetCounterForPlayerRightGuesses()
        } else {
            var bonuses: [WSHPlayer: Int] = [:]
            
            for player in self.players {
                if round.playerScores[player]! > 0 {    //player did guess correctly
                    if self.counterForPlayerRightGuesses[player]! >= 0 {
                        self.counterForPlayerRightGuesses[player]! += 1
                    } else {
                        self.counterForPlayerRightGuesses[player] = 1
                    }
                    
                } else {    //player did not guess correctly
                    if self.counterForPlayerRightGuesses[player]! <= 0 {
                        self.counterForPlayerRightGuesses[player]! -= 1
                    } else {
                        self.counterForPlayerRightGuesses[player] = -1
                    }
                }
                
                if self.counterForPlayerRightGuesses[player]! == 5 {    // 5 correct: +10
                    self.counterForPlayerRightGuesses[player] = 0
                    self.totalPlayerScores[player]! += kBONUS_VALUE
                    bonuses[player] = kBONUS_VALUE
                } else if self.counterForPlayerRightGuesses[player]! == -5 {    //5 wrong: -10
                    self.counterForPlayerRightGuesses[player] = 0
                    self.totalPlayerScores[player]! -= kBONUS_VALUE
                    bonuses[player] = -kBONUS_VALUE
                }
            }
            
            if bonuses.count > 0 {
                self.playerBonusesPerRound[round] = bonuses
            }
        }
    }
    
    private func revertScoresForRound(round: WSHRound) {
        if round.isRoundComplete {
            for player in self.players {
                self.totalPlayerScores[player]! -= round.playerScores[player]!
            }
            if let bonusez = self.playerBonusesPerRound[round] {
                for player in self.players {
                    self.totalPlayerScores[player]! -= bonusez[player] ?? 0
                }
            }
            self.playerBonusesPerRound[round] = nil
        }
    }
    
}
