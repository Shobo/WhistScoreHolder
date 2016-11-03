//
//  WhistScoreHolderTests.swift
//  WhistScoreHolderTests
//
//  Created by Mihai Costiug on 17/03/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

import XCTest
@testable import WhistScoreHolder

class WhistScoreHolderTests: XCTestCase, WSHGameManagerDelegate {
    
    fileprivate var players: [WSHPlayer] = []
    
    override func setUp() {
        super.setUp()
        
        var player = WSHPlayer(name: "name1")
        players.append(player)
        
        player = WSHPlayer(name: "name2")
        players.append(player)
        
        player = WSHPlayer(name: "name3")
        players.append(player)
        
        player = WSHPlayer(name: "name4")
        players.append(player)
        
        WSHGameManager.sharedInstance.delegate = self        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //MARK:- Tests
    
    func testRoundCreation() {
        WSHGameManager.sharedInstance.startGameWithPlayers(players)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds.count == self.players.count * 3 + 6 * 2) //total number of rounds
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[0].roundType == .one)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[1].roundType == .one)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[2].roundType == .one)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[3].roundType == .one)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[4].roundType == .two)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[5].roundType == .three)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[6].roundType == .four)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[7].roundType == .five)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[8].roundType == .six)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[9].roundType == .seven)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[10].roundType == .eight)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[11].roundType == .eight)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[12].roundType == .eight)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[13].roundType == .eight)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[14].roundType == .seven)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[15].roundType == .six)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[16].roundType == .five)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[17].roundType == .four)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[18].roundType == .three)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[19].roundType == .two)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[20].roundType == .one)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[21].roundType == .one)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[22].roundType == .one)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[23].roundType == .one)
    }
    
    func testPlayerBetting() {
        WSHGameManager.sharedInstance.startGameWithPlayers(players)
    }
    
    //MARK:- WSHGameManagerDelegate methods
    
    func gameManager(_ gameManager: WSHGameManager, didStartGame game: WSHGame) {
        
    }
    
    func gameManager(_ gameManager: WSHGameManager, didEndGame game: WSHGame) {
        
    }
    
    func willBeginRoundOfType(_ type: WSHRoundType, startingPlayer player: WSHPlayer) {
        WSHGameManager.sharedInstance.startBetting()
    }
    
    func playerTurnToBet(_ player: WSHPlayer, forRoundType roundType: WSHRoundType, excluding choice: WSHGameBetChoice?) {
        try! WSHGameManager.sharedInstance.player(player, didBet: .zero)
    }
    
    func didFinishBettingInRound(_ round: WSHRound) {
        try! WSHGameManager.sharedInstance.playerDidTakeHand(self.players[0])
        try! WSHGameManager.sharedInstance.playerDidTakeHand(self.players[0])
        try! WSHGameManager.sharedInstance.playerDidTakeHand(self.players[0])
        try! WSHGameManager.sharedInstance.playerDidTakeHand(self.players[0])
    }
    
    func roundDidFinish(_ round: WSHRound, withBonuses bonuses: [WSHPlayer: Int]) {
        WSHGameManager.sharedInstance.startNextRound()
    }
}
