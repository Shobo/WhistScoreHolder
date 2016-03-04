//
//  WSHRound.swift
//  WhistScoreHolder
//
//  Created by Mihai Costiug on 29/02/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

class WSHRound {
    
    private(set) var roundType: WSHGameBetChoice
    var roundInformation: [WSHPlayer: (bets: WSHGameBetChoice, hands: WSHGameBetChoice)] = [:]
    
    init(roundType: WSHGameBetChoice) {
        self.roundType = roundType
    }
    
}
