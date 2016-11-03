//
//  WSHAddressTheUserView.swift
//  WhistScoreHolder
//
//  Created by OctavF on 28/08/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

import UIKit

@IBDesignable
class WSHAddressTheUserView: UIView {

    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet fileprivate weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet fileprivate weak var labelFixedHeight: NSLayoutConstraint!
    
    @IBInspectable var image: UIImage? {
        didSet {
            self.refreshImageView()
        }
    }
    @IBInspectable var text: String! = "This is the best title" {
        didSet {
            mainLabel.text = self.text
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
    
    
    // MARK: - Overridden
    
    
    override func draw(_ rect: CGRect) {
        self.mainLabel.textColor = self.tintColor
        self.refreshImageView()
    }
    
    override var tintColor: UIColor! {
        didSet {
            self.imageView.tintColor = tintColor
            self.mainLabel.textColor = tintColor
        }
    }
    
    // MARK: - Private
    
    
    fileprivate func xibSetup() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "WSHAddressTheUserView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(view);
    }
    
    fileprivate func setupView() {
        self.imageViewHeight.constant = 0.0
        self.imageViewHeight.isActive = ((image != nil) ? false : true)
    }
    
    fileprivate func refreshImageView() {
        if let asdf = image {
            self.imageView.image = asdf
            self.imageViewHeight?.isActive = false
            self.labelFixedHeight?.isActive = true
            
        } else {
            self.imageViewHeight?.isActive = true
            self.labelFixedHeight?.isActive = false
        }
    }
    
}
