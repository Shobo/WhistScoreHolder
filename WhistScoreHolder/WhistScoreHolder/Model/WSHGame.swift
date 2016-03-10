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
    
    private(set) var playerScores: [WSHPlayer: Int] = [:]
    
    var totalNumberOfRounds: Int {
        get {
            return self.players.count * 3 + 6 * 2   //6 intermediary rounds * 2 + two sets of rounds of 1 and one of 8
        }
    }
    
    init(players: [WSHPlayer]) {
        self.players = players
        
        self.createRounds()
        self.initScores()
    }
    
    func advanceToNextRound() {
        if self.currentRound == nil {
            self.currentRound = self.rounds.first
        } else {
            let indexOfCurrentRound = self.rounds.indexOf(self.currentRound!)!
            self.currentRound = self.rounds[indexOfCurrentRound + 1]
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
    
    private func initScores() {
        for player in self.players {
            self.playerScores[player] = 0
        }
    }
}
