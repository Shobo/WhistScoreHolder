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
    
    weak var delegate: WSHBeginRoundActionDelegate?
    
    var player: WSHPlayer? {
        didSet {
            nameOfPlayerLabel?.text = player?.name ?? ""
            playerImageView?.image = player?.image ?? nil
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
        playerImageView?.image = player?.image ?? nil
        
        if let roundIf = round {
            roundOfLabel?.text = "\(kRoundOfString)\(roundIf.intValue)"
        }
        playerScoreLabel?.text = "\(kScoreString)\(playerScore)"
    }
    
    
    //MARK:- Actions
    
    
    @IBAction func didTap(sender: AnyObject) {
        delegate?.beginRoundFromActionController(self)
    }
}

protocol WSHBeginRoundActionDelegate: class {
    func beginRoundFromActionController(actionViewController: WSHBeginRoundActionViewController)
}