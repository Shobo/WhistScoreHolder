//
//  WSHGame.swift
//  WhistScoreHolder
//
//  Created by Mihai Costiug on 28/02/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

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
    
    init(withSettings settings: WSHGameSettings) {
        self.players = settings.players
    }
    
}
