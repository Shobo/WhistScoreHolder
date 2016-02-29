//
//  WSHPlayerView.swift
//  WhistScoreHolder
//
//  Created by OctavF on 29/02/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

import UIKit

@IBDesignable
class WSHPlayerView: UIView, UITextFieldDelegate, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    
    private(set) var player: WSHPlayer!
    
    init(player: WSHPlayer) {
        super.init(frame: CGRectZero)
        
        self.player = player
        xibSetup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        xibSetup()
        self.player = WSHPlayer(name: "", image: UIImage())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        xibSetup()
        self.player = WSHPlayer(name: "", image: UIImage())
    }
    
    // MARK: - Public functions
    
    func keyBoardHeightChanged(newHeight: CGFloat) {
        scrollView.contentSize = CGSizeMake(self.frame.width, self.frame.size.height + newHeight)
        scrollView.setContentOffset(CGPointMake(0.0, newHeight), animated: true)
    }
    
    // MARK: - Private
    
    func xibSetup() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "WSHPlayerView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }
    
    // MARK: - UITextFieldDelegate funcs
    
    func textFieldDidEndEditing(textField: UITextField) {
        scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - UIScrollViewDelegate funcs
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if nameTextField.isFirstResponder() {
            nameTextField.resignFirstResponder()
        }
    }
}
