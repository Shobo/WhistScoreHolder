//
//  WSHDefinitions.swift
//  WhistScoreHolder
//
//  Created by Mihai Costiug on 10/03/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

let kMIN_NUMBER_OF_PLAYERS = 3
let kMAX_NUMBER_OF_PLAYERS = 6

let kCORRECT_GUESS_POINTS = 5
let kBONUS_VALUE = 10

enum WSHGameManagerErrorType: ErrorType, CustomStringConvertible {
    case InvalidPlayers
    case WrongActionForCurrentGameState(gameState: WSHGameManagerState)
    case Wrong
    
    var description: String {
        switch self {
        case .InvalidPlayers:
            return "Invalid players"
        case let .WrongActionForCurrentGameState(gameState: gameState):
            return "Wrong action for current game state: \(gameState)"
        case .Wrong:
            return "WrongSmth"
        }
    }
}

enum WSHGameManagerState {
    case Idle
    case Shuffling
    case Betting
    case Taking
}

enum WSHGameBetChoice: Int {
    case Zero = 0
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
        case .Zero:
            return 0
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

enum WSHRoundType: Int {
    case One = 1
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


// MARK: - UI

enum WSHUIFilterType: UInt8 {
    case Zero = 0
    case White
    case Black
}
