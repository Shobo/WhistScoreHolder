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
    @IBOutlet weak var cameraView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    
    var name: String {
        set(newName) {
            nameTextField.text = newName
        }
        get {
            return nameTextField.text ?? ""
        }
    }
    
    var image: UIImage {
        set(newImage) {
            cameraView.image = newImage
        }
        get {
            return cameraView.image ?? UIImage.randomColorImage(withSize: CGSizeMake(100.0, 100.0))
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
        image = UIImage.randomColorImage(withSize: CGSizeMake(100.0, 100.0))
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
        image = UIImage.imageWithColor(UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1.0), size: CGSizeMake(100.0, 100.0))
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
    
    
    @IBAction func cameraTapped(sender: AnyObject) {
        resignKeyboardIfNeeded()
        image = UIImage.randomColorImage(withSize: CGSizeMake(100.0, 100.0))
    }
    
}
