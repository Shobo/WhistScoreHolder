//
//  WSHGameViewController.swift
//  WhistScoreHolder
//
//  Created by OctavF on 15/03/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


let kScoreCellWidth: CGFloat = 56.0
let kHeaderHeight: CGFloat = 26.0
let kTableViewMinWidth: CGFloat = 164.0

class WSHGameViewController: UIViewController,
                            UITableViewDataSource, UITableViewDelegate,
                            UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,
                            WSHGameManagerDelegate,
                            WSHActionViewControllerDelegate, WSHBeginRoundActionDelegate, WSHHandsActionViewControllerDelegate {
    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var tableViewObject: UITableView!
    @IBOutlet weak var collectionViewObject: UICollectionView!
    
    @IBOutlet fileprivate weak var tableViewWidth: NSLayoutConstraint!
    
    fileprivate var rowHeight: CGFloat = 0.0
    fileprivate var collectionViewOffsetXBeforeScroll: CGFloat = 0.0
    fileprivate var actionViewController: WSHActionViewController? {
        didSet {
            if actionViewController == nil {
                actionButton.isEnabled = false
            } else {
                actionButton.isEnabled = true
            }
        }
    }
    
    fileprivate var _currentGame: WSHGame?
    fileprivate var currentGame: WSHGame! {
        get {
            if let game = _currentGame {
                return game
            } else {
                _currentGame = WSHGameManager.sharedInstance.currentGame
                
                if let game = _currentGame {
                    return game
                } else {
                    return WSHGame(players: [])
                }
            }
        }
        set {
            _currentGame = newValue
        }
    }
    
    
    //MARK: - View lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewObject.tableFooterView = UIView()
        
        var userDetailsNIB = UINib(nibName: "WSHScoreCell", bundle: nil)
        collectionViewObject.register(userDetailsNIB, forCellWithReuseIdentifier: "ScoreCell")
        userDetailsNIB = UINib(nibName: "WSHHeaderCell", bundle: nil)
        collectionViewObject.register(userDetailsNIB, forCellWithReuseIdentifier: "HeaderCell")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setupScoreViewsWidths(forSize: view.bounds.size);
        rowHeight = floor((view.frame.height - kHeaderHeight) / ((self.currentGame.players.count > 0) ?CGFloat(self.currentGame.players.count) : 6.0))
        tableViewObject.reloadSections(IndexSet(integer: 0), with: UITableViewRowAnimation.automatic)
        
        let offsetPoint = collectionViewObject.contentOffset
        
        collectionViewObject.contentSize = CGSize(width: kScoreCellWidth * CGFloat(currentGame.rounds.count), height: view.frame.height)
        collectionViewObject.contentOffset = offsetPoint
        
        collectionViewObject.reloadData()
        collectionViewObject.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableViewObject.reloadData()
        collectionViewObject.reloadData()
    }
    
    
    //MARK: - Private
    
    
    fileprivate func setupScoreViewsWidths(forSize size: CGSize) {
        let numberOfVisibleCells = Int((size.width - kTableViewMinWidth) / kScoreCellWidth) + 1
        
        let scoreCellsWidth = kScoreCellWidth * CGFloat(numberOfVisibleCells)
        tableViewWidth.constant = size.width - scoreCellsWidth
        
        view.setNeedsLayout()
    }
    
    fileprivate func realignCollectionView() {
        if collectionViewObject.contentOffset.x > 0 && collectionViewObject.contentOffset.x <= collectionViewObject.contentSize.width {
            let partOfCell = collectionViewObject.contentOffset.x.truncatingRemainder(dividingBy: kScoreCellWidth)
            
            if partOfCell != 0 {
                var newScrollOffsetX: CGFloat;
                
                if partOfCell < kScoreCellWidth * 0.2 {
                    newScrollOffsetX = collectionViewObject.contentOffset.x - partOfCell
                    
                } else if partOfCell > kScoreCellWidth * 0.8 {
                    newScrollOffsetX = collectionViewObject.contentOffset.x + (kScoreCellWidth - partOfCell)
                    
                } else {
                    if collectionViewOffsetXBeforeScroll > collectionViewObject.contentOffset.x {
                        newScrollOffsetX = collectionViewObject.contentOffset.x - partOfCell
                        
                    } else {
                        newScrollOffsetX = collectionViewObject.contentOffset.x + (kScoreCellWidth - partOfCell)
                    }
                }
                collectionViewObject.setContentOffset(CGPoint(x: newScrollOffsetX, y: collectionViewObject.contentOffset.y), animated: true)
            }
        }
    }
    
    fileprivate func presentActionViewController() {
        let nav = UINavigationController(rootViewController: actionViewController!)
        
        present(nav, animated: true, completion: nil)
    }
    
    fileprivate func resignActionViewController() {
        actionViewController?.navigationController?.dismiss(animated: true, completion: nil)
        actionViewController = nil
    }
    
    fileprivate func setupBeginRoundActionViewController(round roundType: WSHRoundType, fromPlayer player: WSHPlayer, score: Int) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let beginRoundVC = mainStoryboard.instantiateViewController(withIdentifier: "WSHBeginRoundActionViewController") as! WSHBeginRoundActionViewController
        beginRoundVC.actionDelegate = self
        beginRoundVC.player = player
        beginRoundVC.round = roundType
        beginRoundVC.playerScore = score
        beginRoundVC.delegate = self
        
        actionViewController = beginRoundVC
    }
    
    fileprivate func scrollToCurrentRound() {
        var collectionViewOffsetX: CGFloat = 0.0;
        
        if let round = currentGame.currentRound {
            let noScoreCellsAtOnce = Int(collectionViewObject.frame.width / kScoreCellWidth);
            let indexOfCurrentRound = currentGame.rounds.index(of: round)!
            
            let x = CGFloat(indexOfCurrentRound - (noScoreCellsAtOnce - 1/*the current round*/)) * kScoreCellWidth
            
            collectionViewOffsetX = min(max(x, 0), collectionViewObject.contentSize.width - collectionViewObject.frame.width);
        }
        collectionViewObject.setContentOffset(CGPoint(x: collectionViewOffsetX, y: collectionViewObject.contentOffset.y), animated: true)
    }
    
    fileprivate func undoAction() {
        if WSHGameManager.sharedInstance.canUndo() {
            if !self.actionViewController!.isKind(of: WSHHandsActionViewController.self) {
                self.resignActionViewController()
            }
            WSHGameManager.sharedInstance.undo()
            collectionViewObject.reloadData()
        } else {
            self.actionViewController?.undoButton?.isEnabled = false
        }
    }
    
    
    //MARK: - WSHGameManagerDelegate functions
    
    
    func gameManager(_ gameManager: WSHGameManager, didStartGame game: WSHGame) {
        
    }
  
    func willBeginRoundOfType(_ type: WSHRoundType, startingPlayer player: WSHPlayer) {
        setupBeginRoundActionViewController(round: type, fromPlayer: player, score: currentGame.totalPlayerScores[player] ?? 0)
        presentActionViewController()
        
        if let _ = self.collectionViewObject {
            self.scrollToCurrentRound()
        }
    }
    
    func playerTurnToBet(_ player: WSHPlayer, forRoundType roundType: WSHRoundType, excluding choice: WSHGameBetChoice?) {
        var bettingActionViewController: WSHBettingActionViewController
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        bettingActionViewController = mainStoryboard.instantiateViewController(withIdentifier: "WSHBettingActionViewController") as! WSHBettingActionViewController
        bettingActionViewController.actionDelegate = self
        bettingActionViewController.playerImage = player.presentableImage()
        bettingActionViewController.playerName = player.name
        bettingActionViewController.playerOptions = self.bettingChoiceButtonsForRoundType(roundType, excludingChoice: choice)
        
        self.actionViewController = bettingActionViewController
        self.presentActionViewController()
    }
    
    func didFinishBettingInRound(_ round: WSHRound) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let handsActionViewController = mainStoryboard.instantiateViewController(withIdentifier: "WSHHandsActionViewController") as! WSHHandsActionViewController
        handsActionViewController.round = self.currentGame.currentRound
        handsActionViewController.actionDelegate = self
        handsActionViewController.delegate = self
        
        self.actionViewController = handsActionViewController
        self.presentActionViewController()
    }
    
    func roundDidFinish(_ round: WSHRound, withBonuses bonuses: [WSHPlayer : Int]) {
        self.resignActionViewController()
        
        if bonuses.count > 0 {
            // show alert for bonuses
        }
        
        //after bonuses are shown
        WSHGameManager.sharedInstance.startNextRound()
    }

    func gameManager(_ gameManager: WSHGameManager, didEndGame game: WSHGame) {
        currentGame = game
    }
    
    
    //MARK: - WSHBeginRoundActionDelegate functions
    
    
    func beginRoundFromActionController(_ actionViewController: WSHBeginRoundActionViewController) {
        resignActionViewController()
        WSHGameManager.sharedInstance.startBetting()
    }
    
    
    //MARK: - ScrollViewDelegate functions
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y != 0 {
            
            if collectionViewObject == scrollView {
                tableViewObject.delegate = nil;
                tableViewObject.contentOffset = CGPoint(x: tableViewObject.contentOffset.x, y: scrollView.contentOffset.y)
                tableViewObject.delegate = self;
                
            } else {
                collectionViewObject.delegate = nil;
                collectionViewObject.contentOffset = CGPoint(x: collectionViewObject.contentOffset.x, y: scrollView.contentOffset.y)
                collectionViewObject.delegate = self;
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == collectionViewObject {
            collectionViewOffsetXBeforeScroll = scrollView.contentOffset.x
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == collectionViewObject {
            realignCollectionView()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == collectionViewObject {
            if !decelerate {
                realignCollectionView()
            }
        }
    }
    
    
    //MARK: - TableViewDelegate functions
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentGame.players.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Player \\ Round"
        label.backgroundColor = UIColor.lightText
        
        return label
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell")
        
        let currentPlayer: WSHPlayer = currentGame.players[(indexPath as NSIndexPath).row]
        
        cell?.textLabel?.adjustsFontSizeToFitWidth = true
        cell?.textLabel?.text = currentPlayer.name.substring(to: currentPlayer.name.characters.index(currentPlayer.name.startIndex, offsetBy: min(currentPlayer.name.characters.count, 4)))
        cell?.detailTextLabel?.text = "\(currentGame.totalPlayerScores[currentPlayer]!)"
        let cellSize = min(rowHeight * 3.0/4.0, kScoreCellWidth)
        
        cell?.imageView?.image = currentPlayer.presentableImage().scale(toSize: CGSize(width: cellSize, height: cellSize))
        cell?.backgroundColor = UIColor.clear
        
        return cell!
    }
    
    
    //MARK: - Collection view delegates
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return currentGame.totalNumberOfRounds 
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentGame.players.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell?
        
        let round: WSHRound? = currentGame.rounds[(indexPath as NSIndexPath).section]
        
        if (indexPath as NSIndexPath).row == 0 {
            let headerCell: WSHHeaderCell = (collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCell", for: indexPath) as! WSHHeaderCell)
            
            headerCell.mainLabel.text = "\((round?.roundType.intValue)!)"
            headerCell.backgroundColor = UIColor.lightGray
            
            cell = headerCell
            
        } else {
            let scoreCell: WSHScoreCell = (collectionView.dequeueReusableCell(withReuseIdentifier: "ScoreCell", for: indexPath) as! WSHScoreCell)
            scoreCell.backgroundColor = UIColor.white
            
            var scoreString = "?"
            var betString = "?"
            var handString = "?"
            
            let indexRound: WSHRound = currentGame.rounds[(indexPath as NSIndexPath).section]
            let currentPlayer: WSHPlayer = currentGame.players[(indexPath as NSIndexPath).row - 1]
            
            if let currentRound = currentGame.currentRound {
                let indexOfCurrentRound = currentGame.rounds.index(of: currentRound)
                let indexOfIndexRound = currentGame.rounds.index(of: indexRound)
                
                if indexOfCurrentRound > indexOfIndexRound || (indexRound == currentGame.currentRound && indexRound.isRoundComplete) {
                    scoreString = "\(indexRound.playerScores[currentPlayer]!)"
                }
                
                if indexOfCurrentRound >= indexOfIndexRound {
                    if let (bet, hand) = indexRound.roundInformation[currentPlayer] {
                        betString = "\(bet.intValue)"
                        handString = "\(hand.intValue)"
                        
                        if currentRound == round {
                            scoreCell.backgroundColor = UIColor.blue.withAlphaComponent(0.05)
                            
                        } else if bet.intValue == hand.intValue {
                            scoreCell.backgroundColor = UIColor.green.withAlphaComponent(0.05)
                            
                        } else {
                            scoreCell.backgroundColor = UIColor.red.withAlphaComponent(0.05)
                        }
                    }
                }
            } else {
                if let (bet, hand) = indexRound.roundInformation[currentPlayer] {
                    betString = "\(bet.intValue)"
                    handString = "\(hand.intValue)"
                    
                    if bet.intValue == hand.intValue {
                        scoreCell.backgroundColor = UIColor.green.withAlphaComponent(0.05)
                    } else {
                        scoreCell.backgroundColor = UIColor.red.withAlphaComponent(0.05)
                    }
                }
                scoreString = "\(indexRound.playerScores[currentPlayer]!)"
            }
            if let bonus = self.currentGame.playerBonusesPerRound[round!]?[currentPlayer] {
                if bonus < 0 {
                    scoreCell.backgroundColor = UIColor.red.withAlphaComponent(0.2)
                } else {
                    scoreCell.backgroundColor = UIColor.green.withAlphaComponent(0.2)
                }
            }
            
            scoreCell.mainLabel.text = scoreString
            scoreCell.guessLabel.text = betString
            scoreCell.realityLabel.text = handString
            
            cell = scoreCell
        }
        
        return cell!
    }
    
    
    //MARK: - Collection view layout
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (indexPath as NSIndexPath).row == 0 {
            return CGSize(width: kScoreCellWidth, height: kHeaderHeight)
        }
        return CGSize(width: kScoreCellWidth, height: rowHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    
    //MARK: - WSHHandsActionViewControllerDelegate functions
    
    
    func handsActionControllerPlayerDidTakeHand(_ controller: WSHHandsActionViewController, player: WSHPlayer) -> Int {
        do {
            try WSHGameManager.sharedInstance.playerDidTakeHand(player)
        } catch let error {
            presentError(error, fromController: self.navigationController!)
        }
        return currentGame.currentRound?.roundInformation[player]?.hands.intValue ?? 0
    }
    
    
    // MARK: - WSHActionViewControllerDelegate functions
    
    
    func actionControllerUndoAction(_ actionController: WSHActionViewController) {
        self.undoAction()
    }
    
    
    // MARK: - Actions
    
    
    @IBAction func closeButtonTapped(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Game will end", message:
            "Game will be aborted", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            WSHGameManager.sharedInstance.resetAllData()
            _ = self.navigationController?.popViewController(animated: true)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func actionButtonTapped(_ sender: AnyObject) {
        self.presentActionViewController()
    }
    
    func betChoiceButtonPressed(_ button: UIButton) {
        self.resignActionViewController()
        
        if let player = WSHGameManager.sharedInstance.currentGame?.currentRound?.currentBettingPlayer {
            do {
                try WSHGameManager.sharedInstance.player(player, didBet: WSHGameBetChoice(rawValue: button.tag)!)
            } catch let error {
                print("Error found \(error)")
            }
        }
    }
    
    @IBAction func undoButtonPressed(_ sender: UIButton) {
        self.undoAction()
    }
    
    
    // MARK: - Buttons factory
    
    
    fileprivate func bettingChoiceButtonsForRoundType(_ roundType: WSHRoundType, excludingChoice choice: WSHGameBetChoice?) -> [UIButton] {
        var buttons: [UIButton] = []
        
        for betChoice in 0...roundType.intValue {
            let button = self.configuredStandardChoiceButton()
            button.setTitle("\(betChoice)", for: UIControlState())
            button.tag = betChoice
            button.addTarget(self, action: #selector(WSHGameViewController.betChoiceButtonPressed(_:)), for: .touchUpInside)
            
            if let excluded = choice {
                if betChoice == excluded.intValue {
                    button.isEnabled = false
                    button.alpha = 0.5
                }
            }
            
            buttons.append(button)
        }
        
        return buttons
    }
    
    fileprivate func configuredStandardChoiceButton() -> UIButton {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor(red: 127.5 / 255, green: 127.5 / 255, blue: 127.5 / 255, alpha: 0.5)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 100)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5
        button.setTitleColor(UIColor.black.withAlphaComponent(0.85), for: UIControlState())
        
        return button
    }
}
