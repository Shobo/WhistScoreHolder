//
//  WSHActionViewController.swift
//  WhistScoreHolder
//
//  Created by OctavF on 02/04/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

import UIKit

protocol WSHActionViewControllerDelegate : class {
    func actionControllerUndoAction(actionController: WSHActionViewController)
}

class WSHActionViewController: UIViewController {

    var undoButton: UIButton?
    var actionDelegate: WSHActionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigationBarButtonItems()
    }
    
    
    //MARK: - Actions
    
    
    func closeButtonTapped(sender: AnyObject) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func undoAction(button: UIButton) {
        self.actionDelegate?.actionControllerUndoAction(self)
    }
    
    
    //MARK: - Private UI methods
    
    
    private func setupNavigationBarButtonItems() {
        let undoBtn = UIButton(type: .System)
        self.undoButton = undoBtn
        undoBtn.setTitle("Undo", forState: .Normal)
        undoBtn.setTitleColor(undoBtn.tintColor, forState: .Normal)
        undoBtn.setTitleColor(undoBtn.tintColor.colorWithAlphaComponent(0.75), forState: .Highlighted)
        undoBtn.setTitleColor(UIColor.grayColor(), forState: .Disabled)
        undoBtn.addTarget(self, action: #selector(WSHActionViewController.undoAction(_:)), forControlEvents: .TouchUpInside)
        undoBtn.translatesAutoresizingMaskIntoConstraints = false;
        
        let undoView = UIView(frame: CGRectMake(0.0, 0.0, 64.0, 34.0))
        undoView.addSubview(undoBtn)
        
        undoView.addConstraints([
            NSLayoutConstraint(item: undoView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: 64.0),
            NSLayoutConstraint(item: undoView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: 34.0),
            NSLayoutConstraint(item: undoView, attribute: .CenterX, relatedBy: .Equal, toItem: undoBtn, attribute: .CenterX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: undoView, attribute: .CenterY, relatedBy: .Equal, toItem: undoBtn, attribute: .CenterY, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: undoView, attribute: .Width, relatedBy: .Equal, toItem: undoBtn, attribute: .Width, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: undoView, attribute: .Height, relatedBy: .Equal, toItem: undoBtn, attribute: .Height, multiplier: 1.0, constant: 0.0)
            ])
        
        self.navigationItem.titleView = undoView
        
        let score = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: #selector(WSHActionViewController.closeButtonTapped(_:)))
        
        self.navigationItem.rightBarButtonItem = score
    }
    
}
