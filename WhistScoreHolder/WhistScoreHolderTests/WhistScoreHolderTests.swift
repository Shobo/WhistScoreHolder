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
    
    private var players: [WSHPlayer] = []
    
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
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[0].roundType == .One)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[1].roundType == .One)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[2].roundType == .One)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[3].roundType == .One)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[4].roundType == .Two)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[5].roundType == .Three)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[6].roundType == .Four)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[7].roundType == .Five)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[8].roundType == .Six)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[9].roundType == .Seven)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[10].roundType == .Eight)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[11].roundType == .Eight)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[12].roundType == .Eight)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[13].roundType == .Eight)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[14].roundType == .Seven)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[15].roundType == .Six)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[16].roundType == .Five)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[17].roundType == .Four)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[18].roundType == .Three)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[19].roundType == .Two)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[20].roundType == .One)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[21].roundType == .One)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[22].roundType == .One)
        XCTAssert(WSHGameManager.sharedInstance.currentGame!.rounds[23].roundType == .One)
    }
    
    func testPlayerBetting() {
        WSHGameManager.sharedInstance.startGameWithPlayers(players)
    }
    
    //MARK:- WSHGameManagerDelegate methods
    
    func gameManager(gameManager: WSHGameManager, didStartGame game: WSHGame) {
        
    }
    
    func gameManager(gameManager: WSHGameManager, didEndGame game: WSHGame) {
        
    }
    
    func willBeginRoundOfType(type: WSHRoundType, startingPlayer player: WSHPlayer) {
        WSHGameManager.sharedInstance.startBetting()
    }
    
    func playerTurnToBet(player: WSHPlayer, forRoundType roundType: WSHRoundType, excluding choice: WSHGameBetChoice?) {
        try! WSHGameManager.sharedInstance.player(player, didBet: .Zero)
    }
    
    func didFinishBettingInRound(round: WSHRound) {
        try! WSHGameManager.sharedInstance.playerDidTakeHand(self.players[0])
        try! WSHGameManager.sharedInstance.playerDidTakeHand(self.players[0])
        try! WSHGameManager.sharedInstance.playerDidTakeHand(self.players[0])
        try! WSHGameManager.sharedInstance.playerDidTakeHand(self.players[0])
    }
}
