//
//  WSHGameViewController.swift
//  WhistScoreHolder
//
//  Created by OctavF on 15/03/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

import UIKit

let kScoreCellWidth: CGFloat = 56.0
let kHeaderHeight: CGFloat = 26.0

class WSHGameViewController: UIViewController,
                            UITableViewDataSource, UITableViewDelegate,
                            UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var scoreButton: UIBarButtonItem!
    @IBOutlet weak var tableViewObject: UITableView!
    @IBOutlet weak var collectionViewObject: UICollectionView!
    
    @IBOutlet private weak var collectionViewWidth: NSLayoutConstraint!
    @IBOutlet private weak var tableViewWidth: NSLayoutConstraint!
    
    private var currentGame: WSHGame! {
        get {
            return WSHGameManager.sharedInstance.currentGame ?? WSHGame(players: [])
        }
    }
    private var rowHeight: CGFloat = 0.0
    private var collectionViewOffsetXBeforeScroll: CGFloat = 0.0
    
    
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var userDetailsNIB = UINib(nibName: "WSHScoreCell", bundle: nil)
        collectionViewObject.registerNib(userDetailsNIB, forCellWithReuseIdentifier: "ScoreCell")
        userDetailsNIB = UINib(nibName: "WSHHeaderCell", bundle: nil)
        collectionViewObject.registerNib(userDetailsNIB, forCellWithReuseIdentifier: "HeaderCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setupScoreViewsWidths(forSize: view.bounds.size);
        rowHeight = min((view.frame.height - kHeaderHeight) / 6.0, kMinRowHeight)
        tableViewObject.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
        
        var collectionViewOffsetX = 0.0;
        
        if let round = currentGame.currentRound {
            let x: Double = Double(kScoreCellWidth) * Double(currentGame.rounds.indexOf(round)!) - Double(collectionViewObject.frame.width - kScoreCellWidth)
            let y: Double = Double(tableViewObject.contentOffset.y);
            
            collectionViewOffsetX = min(x, y)
        }
        collectionViewObject.setContentOffset(CGPointMake(CGFloat(collectionViewOffsetX), collectionViewObject.contentOffset.y), animated: true)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        setupScoreViewsWidths(forSize: size)
        rowHeight = min((size.height - kHeaderHeight) / 6.0, kMinRowHeight)
        tableViewObject.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
        collectionViewObject.reloadData()
    }
    
    
    //MARK: - Private
    
    
    private func setupScoreViewsWidths(forSize size: CGSize) {
        let numberOfVisibleCells = Int((size.width - 164.0) / kScoreCellWidth) + 1
        
        collectionViewWidth.constant = kScoreCellWidth * CGFloat(numberOfVisibleCells)
        tableViewWidth.constant = size.width - collectionViewWidth.constant
        
        view.setNeedsLayout()
    }
    
    private func realignCollectionView() {
        if collectionViewObject.contentOffset.x > 0 && collectionViewObject.contentOffset.x <= collectionViewObject.contentSize.width {
            let partOfCell = collectionViewObject.contentOffset.x % kScoreCellWidth
            
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
                collectionViewObject.setContentOffset(CGPointMake(newScrollOffsetX, collectionViewObject.contentOffset.y), animated: true)
            }
        }
    }
    
    
    //MARK: - Scroll view delegates
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y != 0 {
            
            if collectionViewObject == scrollView {
                tableViewObject.delegate = nil;
                tableViewObject.contentOffset = CGPointMake(tableViewObject.contentOffset.x, scrollView.contentOffset.y)
                tableViewObject.delegate = self;
                
            } else {
                collectionViewObject.delegate = nil;
                collectionViewObject.contentOffset = CGPointMake(collectionViewObject.contentOffset.x, scrollView.contentOffset.y)
                collectionViewObject.delegate = self;
            }
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if scrollView == collectionViewObject {
            collectionViewOffsetXBeforeScroll = scrollView.contentOffset.x
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView == collectionViewObject {
            realignCollectionView()
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == collectionViewObject {
            if !decelerate {
                realignCollectionView()
            }
        }
    }
    
    
    //MARK: - Table view delegates
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentGame.players.count ?? 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kHeaderHeight
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.textAlignment = .Center
        label.text = "Player \\ Round"
        label.backgroundColor = UIColor.lightTextColor()
        
        return label
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PlayerCell")
        
        let currentPlayer: WSHPlayer = currentGame.players[indexPath.row]
        
        cell?.textLabel?.lineBreakMode = .ByClipping
        cell?.textLabel?.text = currentPlayer.name
        cell?.imageView?.image = currentPlayer.image?.scale(toSize: CGSizeMake(rowHeight - kMargin, rowHeight - kMargin))
        cell?.backgroundColor = UIColor.clearColor()
        
        return cell!
    }
    
    
    //MARK: - Collection view delegates
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return currentGame.totalNumberOfRounds ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (currentGame.players.count ?? 0) + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell?
        
        let round: WSHRound? = currentGame.rounds[indexPath.section]
        
        if indexPath.row == 0 {
            let headerCell: WSHHeaderCell = (collectionView.dequeueReusableCellWithReuseIdentifier("HeaderCell", forIndexPath: indexPath) as! WSHHeaderCell)
            
            headerCell.mainLabel.text = "\((round?.roundType.intValue)!)"
            headerCell.backgroundColor = UIColor.lightGrayColor()
            
            cell = headerCell
            
        } else {
            let headerCell: WSHScoreCell = (collectionView.dequeueReusableCellWithReuseIdentifier("ScoreCell", forIndexPath: indexPath) as! WSHScoreCell)
            
            var scoreString = "--"
            var betString = "-"
            var handString = "-"
            
            let indexRound: WSHRound = currentGame.rounds[indexPath.section]
            let currentPlayer: WSHPlayer = currentGame.players[indexPath.row - 1]
            
            if let currentRound = currentGame.currentRound {
                let indexOfCurrentRound = currentGame.rounds.indexOf(currentRound)
                let indexOfIndexRound = currentGame.rounds.indexOf(indexRound)
                
                if indexOfCurrentRound > indexOfIndexRound || (indexRound == currentGame.currentRound && indexRound.isRoundComplete) {
                    scoreString = "\(indexRound.playerScores[currentPlayer])"
                }
                
                if indexOfCurrentRound >= indexOfIndexRound {
                    if let (bet, hand) = indexRound.roundInformation[currentPlayer] {
                        betString = "\(bet.intValue)"
                        handString = "\(hand.intValue)"
                    } else {
                        betString = "\(indexRound.roundType.intValue)"
                    }
                }
            }
            
            headerCell.mainLabel.text = scoreString
            headerCell.guessLabel.text = betString
            headerCell.realityLabel.text = handString
            
            headerCell.backgroundColor = UIColor.whiteColor()
            
            cell = headerCell
        }
        
        return cell!
    }
    
    
    //MARK: - Collection view layout
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSizeMake(kScoreCellWidth, kHeaderHeight)
        }
        return CGSizeMake(kScoreCellWidth, rowHeight)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0;
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    
    // MARK: - Actions
    
    
    @IBAction func closeButtonTapped(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
