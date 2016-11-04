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
    
    @IBOutlet fileprivate weak var cameraWidthConstraint: NSLayoutConstraint!
    
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
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Public functions
    
    
    func keyBoardHeightChanged(_ newHeight: CGFloat) {
        scrollView.contentSize = CGSize(width: self.frame.width, height: self.frame.size.height + newHeight)
        scrollView.setContentOffset(CGPoint(x: 0.0, y: newHeight), animated: true)
    }
    
    func resetToDefault() {
        nameTextField.text = nil
        image = nil
        colorHex = randHEX()
    }
    
    func resignKeyboardIfNeeded() {
        if nameTextField.isFirstResponder {
            nameTextField.resignFirstResponder()
        }
    }
    
    func focusName() {
        nameTextField.becomeFirstResponder()
    }
    
    
    // MARK: - Private
    
    
    fileprivate func xibSetup() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "WSHPlayerView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(view);
    }
    
    fileprivate func setupView() {
        self.nameTextField.placeholder = NSLocalizedString("player_name", comment: "");
        NotificationCenter.default.addObserver(self, selector: #selector(WSHPlayerView.keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        self.backgroundColor = UIColor.colorFromRGB(colorHex)
        self.cameraView.backgroundColor = UIColor.white().withAlphaComponent(0.33)
        self.cameraWidthConstraint.constant = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    }
    
    
    // MARK: - UITextFieldDelegate funcs
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
    // MARK: - UIScrollViewDelegate funcs
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        resignKeyboardIfNeeded()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        resignKeyboardIfNeeded()
    }
    
    
    // MARK: - Notifications
    
    
    func keyboardWillChangeFrame(_ notification: Notification) {
        if let keyboardRect = ((notification as NSNotification).userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.keyBoardHeightChanged(UIScreen.main.bounds.height - keyboardRect.origin.y)
        } else {
            self.keyBoardHeightChanged(0)
        }
    }
    
    
    // MARK: - Actions
    
    
    @IBAction func colourTapped(_ sender: AnyObject) {
        colorHex = randHEX()
    }
    
}
