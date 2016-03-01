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
    
    var name: String {
        get {
            return nameTextField.text ?? "Player"
        }
    }
    var colour: UIColor = UIColor.blueColor() {
        didSet {
            cameraView.backgroundColor = colour
        }
    }
    
    var image: UIImage {
        get {
            return getImageWithColor(colour, size: CGSizeMake(44.0, 44.0))
        }
    }
    
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
        colour = UIColor.blueColor()
    }
    
    func resignKeyboardIfNeeded() {
        if nameTextField.isFirstResponder() {
            nameTextField.resignFirstResponder()
        }
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
    
    func setupView() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardDidShow:"), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
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
        resignKeyboardIfNeeded()
    }
    
    // MARK: - Notifications
    
    func keyboardDidShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.keyBoardHeightChanged(keyboardSize.height)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.keyBoardHeightChanged(0)
    }
    
    // MARK: - Actions
    
    @IBAction func cameraTapped(sender: AnyObject) {
        resignKeyboardIfNeeded()
        colour = UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1.0)
    }
    
}
