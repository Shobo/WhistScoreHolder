//
//  WSHActionViewController.swift
//  WhistScoreHolder
//
//  Created by OctavF on 02/04/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

import UIKit

protocol WSHActionViewControllerDelegate : class {
    func actionControllerUndoAction(_ actionController: WSHActionViewController)
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
    
    
    func closeButtonTapped(_ sender: AnyObject) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func undoAction(_ button: UIButton) {
        self.actionDelegate?.actionControllerUndoAction(self)
    }
    
    
    //MARK: - Private UI methods
    
    
    fileprivate func setupNavigationBarButtonItems() {
        let undoBtn = UIButton(type: .system)
        self.undoButton = undoBtn
        undoBtn.setTitle(NSLocalizedString("undo", comment: ""), for: UIControlState())
        undoBtn.setTitleColor(undoBtn.tintColor, for: UIControlState())
        undoBtn.setTitleColor(undoBtn.tintColor.withAlphaComponent(0.75), for: .highlighted)
        undoBtn.setTitleColor(UIColor.gray, for: .disabled)
        undoBtn.addTarget(self, action: #selector(WSHActionViewController.undoAction(_:)), for: .touchUpInside)
        undoBtn.translatesAutoresizingMaskIntoConstraints = false;
        
        let undoView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 64.0, height: 34.0))
        undoView.addSubview(undoBtn)
        
        undoView.addConstraints([
            NSLayoutConstraint(item: undoView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: 64.0),
            NSLayoutConstraint(item: undoView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: 34.0),
            NSLayoutConstraint(item: undoView, attribute: .centerX, relatedBy: .equal, toItem: undoBtn, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: undoView, attribute: .centerY, relatedBy: .equal, toItem: undoBtn, attribute: .centerY, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: undoView, attribute: .width, relatedBy: .equal, toItem: undoBtn, attribute: .width, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: undoView, attribute: .height, relatedBy: .equal, toItem: undoBtn, attribute: .height, multiplier: 1.0, constant: 0.0)
            ])
        
        self.navigationItem.titleView = undoView
        
        let score = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(WSHActionViewController.closeButtonTapped(_:)))
        
        self.navigationItem.rightBarButtonItem = score
    }
    
}
