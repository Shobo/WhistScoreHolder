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

let kAnimationDuration = 0.25

enum WSHGameManagerErrorType: Error, CustomStringConvertible {
    case invalidPlayers
    case wrongActionForCurrentGameState(gameState: WSHGameManagerState)
    case wrong
    
    var description: String {
        switch self {
        case .invalidPlayers:
            return "Invalid players"
        case let .wrongActionForCurrentGameState(gameState: gameState):
            return "Wrong action for current game state: \(gameState)"
        case .wrong:
            return "WrongSmth"
        }
    }
}

enum WSHGameManagerState {
    case idle
    case shuffling
    case betting
    case taking
}

enum WSHGameBetChoice: Int {
    case zero = 0
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    
    var intValue: Int {
        switch self {
        case .zero:
            return 0
        case .one:
            return 1
        case .two:
            return 2
        case .three:
            return 3
        case .four:
            return 4
        case .five:
            return 5
        case .six:
            return 6
        case .seven:
            return 7
        case .eight:
            return 8
        }
    }
}

enum WSHRoundType: Int {
    case one = 1
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    
    var intValue: Int {
        switch self {
        case .one:
            return 1
        case .two:
            return 2
        case .three:
            return 3
        case .four:
            return 4
        case .five:
            return 5
        case .six:
            return 6
        case .seven:
            return 7
        case .eight:
            return 8
        }
    }
}


// MARK: - UI

enum WSHUIFilterType: UInt8 {
    case zero = 0
    case white
    case black
}
