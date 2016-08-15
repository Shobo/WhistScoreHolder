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
    @IBOutlet weak var cameraView: WSHCameraView!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet private weak var cameraWidthConstraint: NSLayoutConstraint!
    
    var name: String {
        set(newName) {
            nameTextField.text = newName
        }
        get {
            return nameTextField.text ?? ""
        }
    }
    
    var image: UIImage? {
        set(newImage) {
            cameraView.setFitImage(newImage)
        }
        get {
            return cameraView.image
        }
    }
    
    var colorHex: UInt = randHEX() {
        didSet {
            self.backgroundColor = UIColor.colorFromRGB(colorHex)
        }
    }
    
    
    // MARK: - Lifecycle
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        xibSetup()
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        xibSetup()
        setupView()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    // MARK: - Public functions
    
    
    func keyBoardHeightChanged(newHeight: CGFloat) {
        scrollView.contentSize = CGSizeMake(self.frame.width, self.frame.size.height + newHeight)
        scrollView.setContentOffset(CGPointMake(0.0, newHeight), animated: true)
    }
    
    func resetToDefault() {
        nameTextField.text = nil
        image = nil
        colorHex = randHEX()
    }
    
    func resignKeyboardIfNeeded() {
        if nameTextField.isFirstResponder() {
            nameTextField.resignFirstResponder()
        }
    }
    
    func focusName() {
        nameTextField.becomeFirstResponder()
    }
    
    
    // MARK: - Private
    
    
    private func xibSetup() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "WSHPlayerView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        self.addSubview(view);
    }
    
    private func setupView() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WSHPlayerView.keyboardWillChangeFrame(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        self.backgroundColor = UIColor.colorFromRGB(colorHex)
        self.cameraView.backgroundColor = UIColor.white().colorWithAlphaComponent(0.33)
        self.cameraWidthConstraint.constant = min(UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
    }
    
    
    // MARK: - UITextFieldDelegate funcs
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
    // MARK: - UIScrollViewDelegate funcs
    
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        resignKeyboardIfNeeded()
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        resignKeyboardIfNeeded()
    }
    
    
    // MARK: - Notifications
    
    
    func keyboardWillChangeFrame(notification: NSNotification) {
        if let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
            self.keyBoardHeightChanged(UIScreen.mainScreen().bounds.height - keyboardRect.origin.y)
        } else {
            self.keyBoardHeightChanged(0)
        }
    }
    
    
    // MARK: - Actions
    
    
    @IBAction func colourTapped(sender: AnyObject) {
        colorHex = randHEX()
    }
    
}
