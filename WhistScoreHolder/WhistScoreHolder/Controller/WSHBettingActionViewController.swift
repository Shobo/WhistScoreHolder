//
//  WSHBettingActionViewController.swift
//  WhistScoreHolder
//
//  Created by Mihai Costiug on 15/04/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

import UIKit

let kPlayerTitleViewWidth: CGFloat = 212.0

class WSHBettingActionViewController: WSHActionViewController {
    
    @IBOutlet private weak var bettingOptionsView: WSHGridView!
    @IBOutlet private weak var playersBetsView: UIView!
    
    var playerName: String?
    var playerImage: UIImage?
    var playerOptions: [UIView] = []
    
    private var playerTitleView : WSHPlayerOneLineView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupPlayerTitleView()
        self.navigationItem.titleView = UIView(frame: CGRectMake(0,0,kPlayerTitleViewWidth, 42.0))
        self.navigationItem.titleView?.addSubview(self.playerTitleView)
        self.setupPlayerTitleViewFrame()
        
        self.bettingOptionsView.views = self.playerOptions
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.playerTitleView.frame = CGRectMake(0, 0, kPlayerTitleViewWidth, (self.navigationController?.navigationBar.frame.height)!)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        //different UI for landscape in storyboard; 3:5 multiplier for width
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        coordinator.animateAlongsideTransition({ (_) in
            self.setupPlayerTitleViewFrame();
            }, completion: nil)
    }
    
    
    //MARK: - Private UI functions
    
    
    private func setupPlayerTitleView() {
        self.playerTitleView = UIView.loadFromNibNamed("WSHPlayerOneLineView") as! WSHPlayerOneLineView
        
        self.playerTitleView.textLabel.text = "\(self.playerName ?? "Player")'s"
        self.playerTitleView.detailsTextLabel.text = "turn to bet"
        self.playerTitleView.imageView.image = playerImage
    }
    
    private func setupPlayerTitleViewFrame() {
        self.playerTitleView.frame = CGRectMake(0, 0, kPlayerTitleViewWidth, self.navigationItem.titleView?.bounds.size.height ?? 24.0)
        self.playerTitleView.center = CGPointMake((self.navigationItem.titleView?.bounds.size.width ?? kPlayerTitleViewWidth) / 2.0,
                                                  (self.navigationItem.titleView?.bounds.size.height ?? 24.0) / 2.0)
    }
    
}
