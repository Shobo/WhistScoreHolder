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

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet private weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var labelFixedHeight: NSLayoutConstraint!
    
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
    
    
    override func drawRect(rect: CGRect) {
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
    
    
    private func xibSetup() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "WSHAddressTheUserView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        self.addSubview(view);
    }
    
    private func setupView() {
        self.imageViewHeight.constant = 0.0
        self.imageViewHeight.active = ((image != nil) ? false : true)
    }
    
    private func refreshImageView() {
        if let asdf = image {
            self.imageView.image = asdf
            self.imageViewHeight?.active = false
            self.labelFixedHeight?.active = true
            
        } else {
            self.imageViewHeight?.active = true
            self.labelFixedHeight?.active = false
        }
    }
    
}
