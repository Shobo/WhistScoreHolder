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
    
    var filter: WSHUIFilterType = WSHUIFilterType.zero {
        didSet(asdf) {
            self.refreshFilter()
        }
    }
    
    fileprivate var xiew: UIView?
    fileprivate var backgroundImageView: UIImageView?
    
    
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
    
    
    override func setBackgroundImage(_ image: UIImage?, for state: UIControlState) {
        self.backgroundImageView?.image = image
    }
    

    // MARK: - Private
    
    
    fileprivate func xibSetup() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "WSHBetButton", bundle: bundle)
        self.xiew = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        self.xiew?.frame = bounds
        self.xiew?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.refreshFilter()
        
        if let asdf = self.xiew {
            self.addSubview(asdf);
        }
    }
    
    fileprivate func setupBackgroundImageView() {
        self.backgroundImageView = UIImageView(frame: self.bounds)
        self.backgroundImageView?.contentMode = .scaleAspectFill
        self.backgroundImageView?.backgroundColor = UIColor.clear
        self.backgroundImageView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if let asdf = self.backgroundImageView {
            self.addSubview(asdf)
        }
    }
    
    fileprivate func refreshFilter() {
        switch self.filter {
        case .zero:
            self.xiew?.backgroundColor = UIColor.clear
            break
            
        case .white:
            self.xiew?.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            break
            
        case .black:
            self.xiew?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            break
        }
    }
    
}
