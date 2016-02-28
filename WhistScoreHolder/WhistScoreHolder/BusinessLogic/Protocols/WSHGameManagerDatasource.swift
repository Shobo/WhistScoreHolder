//
//  WSHGameManagerDatasource.swift
//  WhistScoreHolder
//
//  Created by Mihai Costiug on 28/02/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

protocol WSHGameManagerDatasource {
    func currentGame(game: WSHGame, betForPlayer: WSHPlayer, fromPossibleChoices: [WSHGameBetChoice]) -> WSHGameBetChoice
}