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

class WSHBeginRoundActionViewController: WSHActionViewController {
    @IBOutlet private weak var roundOfLabel: UILabel!
    @IBOutlet private weak var nameOfPlayerLabel: UILabel!
    @IBOutlet private weak var playerScoreLabel: UILabel!
    @IBOutlet private weak var playerImageView: UIImageView!
    
    var player: WSHPlayer? {
        didSet {
            nameOfPlayerLabel?.text = player?.name ?? ""
            playerImageView?.image = player?.image ?? nil
        }
    }
    var round: WSHRoundType? {
        didSet {
            roundOfLabel?.text = "\(kRoundOfString)\(round?.intValue)"
        }
    }
    var playerScore: Int = 0 {
        didSet {
            playerScoreLabel?.text = "\(kScoreString)\(playerScore)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
