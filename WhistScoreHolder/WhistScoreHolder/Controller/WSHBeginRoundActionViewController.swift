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
    @IBOutlet fileprivate weak var roundOfLabel: UILabel!
    @IBOutlet fileprivate weak var nameOfPlayerLabel: UILabel!
    @IBOutlet fileprivate weak var playerScoreLabel: UILabel!
    @IBOutlet fileprivate weak var playerImageView: UIImageView!
    @IBOutlet fileprivate weak var scoresTableView: UITableView!
    
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
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WSHGameManager.sharedInstance.currentGame?.players.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let currentPlayer: WSHPlayer = WSHGameManager.sharedInstance.currentGame?.players[(indexPath as NSIndexPath).row] {
            let playerCell: WSHPlayerCellSummary = (tableView.dequeueReusableCell(withIdentifier: "SummaryCell", for: indexPath) as! WSHPlayerCellSummary)
            
            var scoreString = "0"
            
            if let currentRound: WSHRound = WSHGameManager.sharedInstance.currentGame?.currentRound {
                let previousIndex = (WSHGameManager.sharedInstance.currentGame?.rounds.index(of: currentRound) ?? 0) - 1
                
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
            
            playerCell.backgroundColor = UIColor.white
            
            return playerCell
        }
        return tableView.dequeueReusableCell(withIdentifier: "SummaryCell", for: indexPath)
    }


    //MARK:- Actions


    @IBAction func didTap(_ sender: AnyObject) {
        delegate?.beginRoundFromActionController(self)
    }
}

protocol WSHBeginRoundActionDelegate: class {
    func beginRoundFromActionController(_ actionViewController: WSHBeginRoundActionViewController)
}
