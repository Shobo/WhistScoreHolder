//
//  WSHGameManager.swift
//  WhistScoreHolder
//
//  Created by Mihai Costiug on 28/02/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

class WSHGameManager {
    
    static let sharedInstance = WSHGameManager()
    
    private(set) var currentGame: WSHGame?
    
    private(set) var currentRound: Int = 0  //send message to delegate in didSet method
    private(set) var totalNumberOfRounds: Int = 0
    
    private(set) var gameStarted: Bool = false
    
    
    
    init() {
        
    }
    
    func startGame(game: WSHGame) {
        self.gameStarted = true
        
        self.currentGame = game
        
    }
    
    
}
