//
//  WSHRound.swift
//  WhistScoreHolder
//
//  Created by Mihai Costiug on 29/02/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

class WSHRound {
    
    private(set) var roundType: WSHGameBetChoice
    private(set) var activePlayers: [WSHPlayer] = []    //players that have information regarding betting or taking cards
    
    private(set) var currentlyBettedHands: Int = 0
    private(set) var currentlyTakenHands: Int = 0
    
    var isRoundComplete: Bool {
        get {
            // check if all players have bet and taken information
            return false
        }
    }
    
    init(roundType: WSHGameBetChoice) {
        self.roundType = roundType
    }
    
    
}
