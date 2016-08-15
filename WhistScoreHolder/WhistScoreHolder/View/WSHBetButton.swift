//
//  WSHBetButton.swift
//  WhistScoreHolder
//
//  Created by OctavF on 02/08/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

import UIKit

class WSHBetButton: UIButton {

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    var filter: WSHUIFilterType = WSHUIFilterType.Zero {
        didSet(asdf) {
            self.refreshFilter()
        }
    }
    
    private var xiew: UIView?
    private var backgroundImageView: UIImageView?
    
    
    // MARK: - Lifecycle
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBackgroundImageView()
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupBackgroundImageView()
        xibSetup()
    }
    
    
    // MARK: - Overriden
    
    
    override func setBackgroundImage(image: UIImage?, forState state: UIControlState) {
        self.backgroundImageView?.image = image
    }
    

    // MARK: - Private
    
    
    private func xibSetup() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "WSHBetButton", bundle: bundle)
        self.xiew = nib.instantiateWithOwner(self, options: nil)[0] as? UIView
        self.xiew?.frame = bounds
        self.xiew?.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.refreshFilter()
        
        if let asdf = self.xiew {
            self.addSubview(asdf);
        }
    }
    
    private func setupBackgroundImageView() {
        self.backgroundImageView = UIImageView(frame: self.bounds)
        self.backgroundImageView?.contentMode = .ScaleAspectFill
        self.backgroundImageView?.backgroundColor = UIColor.clearColor()
        self.backgroundImageView?.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        if let asdf = self.backgroundImageView {
            self.addSubview(asdf)
        }
    }
    
    private func refreshFilter() {
        switch self.filter {
        case .Zero:
            self.xiew?.backgroundColor = UIColor.clearColor()
            break
            
        case .White:
            self.xiew?.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
            break
            
        case .Black:
            self.xiew?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
            break
        }
    }
    
}
