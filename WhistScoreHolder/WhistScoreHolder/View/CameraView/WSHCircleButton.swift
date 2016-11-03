//
//  WSHCircleButton.swift
//  WhistScoreHolder
//
//  Created by OctavF on 28/08/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

import UIKit

@IBDesignable
class WSHCircleButton: UIButton {

    fileprivate var circleView: UIView?
    fileprivate var intCircleView: UIView?
    fileprivate var xLayer: CAShapeLayer! = CAShapeLayer()
    
    @IBInspectable var circleColor: UIColor = UIColor.green {
        didSet (newValue) {
            self.intCircleView?.backgroundColor = newValue
        }
    }
    @IBInspectable var circleHighlightedColor: UIColor = UIColor.gray {
        didSet (newValue) {
            self.intCircleView?.backgroundColor = newValue
        }
    }
    @IBInspectable var hasX: Bool = false {
        didSet {
            self.xLayer.isHidden = !self.hasX
        }
    }
    
    fileprivate var bkColor: UIColor = UIColor.white() {
        didSet {
            self.circleView?.backgroundColor = bkColor
        }
    }
    
    // MARK: - Lifecycle
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    override func draw(_ rect: CGRect) {
        self.circleView?.backgroundColor = self.bkColor
        self.circleView?.layer.cornerRadius = min(rect.height, rect.width) / 2.0
        
        self.intCircleView?.backgroundColor = self.isHighlighted ? self.circleHighlightedColor : self.circleColor
        self.intCircleView?.layer.cornerRadius = min((self.intCircleView?.bounds.height)!, (self.intCircleView?.bounds.width)!) / 2.0
    }
    
    @IBInspectable override var backgroundColor: UIColor? {
        set (newValue) {
            self.bkColor = newValue ?? UIColor.clear
        }
        get {
            return bkColor
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            self.intCircleView?.backgroundColor = self.isHighlighted ? self.circleHighlightedColor : self.circleColor
        }
    }
    
    // MARK: - Private
    
    
    fileprivate func setupView() {
        self.setupCircleView()
        self.setupIntCircleView()
    }
    
    fileprivate func setupCircleView() {
        self.circleView = UIView()
        self.circleView?.frame = self.bounds
        self.circleView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.circleView?.clipsToBounds = true
        self.circleView?.backgroundColor = self.bkColor
        self.circleView?.layer.masksToBounds = true
        self.circleView?.isUserInteractionEnabled = false
        
        if let asdf = self.circleView {
            self.addSubview(asdf)
        }
    }
    
    fileprivate func setupIntCircleView() {
        self.intCircleView = UIView()
        self.intCircleView?.frame = CGRect(x: 0.0, y: 0.0, width: self.bounds.width - 7.0, height: self.bounds.height - 7.0)
        self.intCircleView?.center = CGPoint(x: self.bounds.width / 2.0, y: self.bounds.height / 2.0)
        self.intCircleView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.intCircleView?.clipsToBounds = true
        self.intCircleView?.backgroundColor = self.circleColor
        self.intCircleView?.layer.masksToBounds = true
        self.intCircleView?.isUserInteractionEnabled = false
        
        self.setupXLayer()
        self.intCircleView?.layer.addSublayer(self.xLayer)
        
        let dotPath = UIBezierPath(ovalIn:self.intCircleView?.bounds ?? CGRect.zero)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = dotPath.cgPath
        shapeLayer.lineWidth = 4.0
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        self.intCircleView?.layer.addSublayer(shapeLayer)
        
        if let asdf = self.intCircleView {
            self.addSubview(asdf)
        }
    }
    
    fileprivate func setupXLayer() {
        let dotPath = WSHPath.xPath(self.intCircleView?.bounds ?? CGRect.zero, lineWidth: 12.0)
//        let dotPath = WSHPath.xPath(self.intCircleView?.bounds ?? CGRectZero)
        self.xLayer = CAShapeLayer()
        self.xLayer.path = dotPath.cgPath
//        self.xLayer.lineWidth = 6.0
        self.xLayer.strokeColor = UIColor.black.withAlphaComponent(0.5).cgColor
//        self.xLayer.strokeColor = UIColor.blackColor().colorWithAlphaComponent(0.35).CGColor
        self.xLayer.fillColor = UIColor.black.withAlphaComponent(0.35).cgColor
        self.xLayer.isHidden = !self.hasX
    }
    
}
