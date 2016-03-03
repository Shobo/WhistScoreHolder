//
//  WSHGame.swift
//  WhistScoreHolder
//
//  Created by Mihai Costiug on 28/02/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//
import UIKit

enum WSHGameBetChoice { //move this somewhere else?
    case One
    case Two
    case Three
    case Four
    case Five
    case Six
    case Seven
    case Eight
    
    var intValue: Int {
        switch self {
        case .One:
            return 1
        case .Two:
            return 2
        case .Three:
            return 3
        case .Four:
            return 4
        case .Five:
            return 5
        case .Six:
            return 6
        case .Seven:
            return 7
        case .Eight:
            return 8
        }
    }
}

class WSHGame {
    
    private(set) var players:[WSHPlayer]
    private(set) var rounds: [WSHRound] = []
    
    var totalNumberOfRounds: Int {
        get {
            return self.players.count * 3 + 6   //6 intermediary rounds + two sets of rounds of 1 and one of 8
        }
    }
    
    init(players: [WSHPlayer]) {
        self.players = players
        
        self.createRounds()
    }
    
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
    
    private func createRounds(numberOfRounds: Int, ofType type: WSHGameBetChoice) -> [WSHRound] {
        var rounds: [WSHRound] = []
        
        for _ in 0..<numberOfRounds {
            let round = WSHRound(roundType: type)
            rounds.append(round)
        }
        
        return rounds
    }
}
