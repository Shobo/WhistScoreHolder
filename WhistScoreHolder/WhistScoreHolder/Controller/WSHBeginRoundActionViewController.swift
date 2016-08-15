//
//  WSHBeginRoundActionViewController.swift
//  WhistScoreHolder
//
//  Created by OctavF on 03/04/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

import UIKit

let kRoundOfString = "Round of "
let kScoreString = "Score: "

class WSHBeginRoundActionViewController: WSHActionViewController,
                                            UITableViewDelegate, UITableViewDataSource {
    @IBOutlet private weak var roundOfLabel: UILabel!
    @IBOutlet private weak var nameOfPlayerLabel: UILabel!
    @IBOutlet private weak var playerScoreLabel: UILabel!
    @IBOutlet private weak var playerImageView: UIImageView!
    @IBOutlet private weak var scoresTableView: UITableView!
    
    weak var delegate: WSHBeginRoundActionDelegate?
    
    var player: WSHPlayer? {
        didSet {
            nameOfPlayerLabel?.text = player?.name ?? ""
            playerImageView?.image = player?.presentableImage()
        }
    }
    var round: WSHRoundType? {
        didSet {
            if let roundIf = round {
                roundOfLabel?.text = "\(kRoundOfString)\(roundIf.intValue)"
            }
        }
    }
    var playerScore: Int = 0 {
        didSet {
            playerScoreLabel?.text = "\(kScoreString)\(playerScore)"
        }
    }
    
    
    //MARK:- View lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameOfPlayerLabel?.text = player?.name ?? ""
        playerImageView?.image = player?.presentableImage()
        
        if let roundIf = round {
            roundOfLabel?.text = "\(kRoundOfString)\(roundIf.intValue)"
        }
        playerScoreLabel?.text = "\(kScoreString)\(playerScore)"
    }
    
    
    //MARK:- UITableViewDataSource
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WSHGameManager.sharedInstance.currentGame?.players.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let currentPlayer: WSHPlayer = WSHGameManager.sharedInstance.currentGame?.players[indexPath.row] {
            let playerCell: WSHPlayerCellSummary = (tableView.dequeueReusableCellWithIdentifier("SummaryCell", forIndexPath: indexPath) as! WSHPlayerCellSummary)
            
            var scoreString = "0"
            
            if let currentRound: WSHRound = WSHGameManager.sharedInstance.currentGame?.currentRound {
                let previousIndex = (WSHGameManager.sharedInstance.currentGame?.rounds.indexOf(currentRound) ?? 0) - 1
                
                if previousIndex >= 0 {
                    if let prevRound: WSHRound = WSHGameManager.sharedInstance.currentGame?.rounds[previousIndex] {
                        let score = WSHGameManager.sharedInstance.currentGame?.totalPlayerScores[currentPlayer] ?? 0
                        let prevScore = score - (prevRound.playerScores[currentPlayer] ?? 0)
                        let diff = score - prevScore
                        scoreString = "\(prevScore) \(diff > 0 ? "+" : "-") \(abs(diff)) => \(score)"
                    }
                }
            }
            
            playerCell.leftImageView.image = currentPlayer.presentableImage()
            playerCell.mainLabel.text = currentPlayer.name
            playerCell.scoreLabel.text = scoreString
            
            playerCell.backgroundColor = UIColor.whiteColor()
            
            return playerCell
        }
        return tableView.dequeueReusableCellWithIdentifier("SummaryCell", forIndexPath: indexPath)
    }


    //MARK:- Actions


    @IBAction func didTap(sender: AnyObject) {
        delegate?.beginRoundFromActionController(self)
    }
}

protocol WSHBeginRoundActionDelegate: class {
    func beginRoundFromActionController(actionViewController: WSHBeginRoundActionViewController)
}