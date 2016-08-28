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

    private var circleView: UIView?
    private var intCircleView: UIView?
    private var xLayer: CAShapeLayer! = CAShapeLayer()
    
    @IBInspectable var circleColor: UIColor = UIColor.greenColor() {
        didSet (newValue) {
            self.intCircleView?.backgroundColor = newValue
        }
    }
    @IBInspectable var circleHighlightedColor: UIColor = UIColor.grayColor() {
        didSet (newValue) {
            self.intCircleView?.backgroundColor = newValue
        }
    }
    @IBInspectable var hasX: Bool = false {
        didSet {
            self.xLayer.hidden = !self.hasX
        }
    }
    
    private var bkColor: UIColor = UIColor.white() {
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
    
    override func drawRect(rect: CGRect) {
        self.circleView?.backgroundColor = self.bkColor
        self.circleView?.layer.cornerRadius = min(rect.height, rect.width) / 2.0
        
        self.intCircleView?.backgroundColor = self.highlighted ? self.circleHighlightedColor : self.circleColor
        self.intCircleView?.layer.cornerRadius = min((self.intCircleView?.bounds.height)!, (self.intCircleView?.bounds.width)!) / 2.0
    }
    
    @IBInspectable override var backgroundColor: UIColor? {
        set (newValue) {
            self.bkColor = newValue ?? UIColor.clearColor()
        }
        get {
            return bkColor
        }
    }
    
    override var highlighted: Bool {
        didSet {
            self.intCircleView?.backgroundColor = self.highlighted ? self.circleHighlightedColor : self.circleColor
        }
    }
    
    // MARK: - Private
    
    
    private func setupView() {
        self.setupCircleView()
        self.setupIntCircleView()
    }
    
    private func setupCircleView() {
        self.circleView = UIView()
        self.circleView?.frame = self.bounds
        self.circleView?.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.circleView?.clipsToBounds = true
        self.circleView?.backgroundColor = self.bkColor
        self.circleView?.layer.masksToBounds = true
        self.circleView?.userInteractionEnabled = false
        
        if let asdf = self.circleView {
            self.addSubview(asdf)
        }
    }
    
    private func setupIntCircleView() {
        self.intCircleView = UIView()
        self.intCircleView?.frame = CGRectMake(0.0, 0.0, self.bounds.width - 7.0, self.bounds.height - 7.0)
        self.intCircleView?.center = CGPointMake(self.bounds.width / 2.0, self.bounds.height / 2.0)
        self.intCircleView?.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.intCircleView?.clipsToBounds = true
        self.intCircleView?.backgroundColor = self.circleColor
        self.intCircleView?.layer.masksToBounds = true
        self.intCircleView?.userInteractionEnabled = false
        
        self.setupXLayer()
        self.intCircleView?.layer.addSublayer(self.xLayer)
        
        let dotPath = UIBezierPath(ovalInRect:self.intCircleView?.bounds ?? CGRectZero)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = dotPath.CGPath
        shapeLayer.lineWidth = 4.0
        shapeLayer.strokeColor = UIColor.blackColor().CGColor
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        self.intCircleView?.layer.addSublayer(shapeLayer)
        
        if let asdf = self.intCircleView {
            self.addSubview(asdf)
        }
    }
    
    private func setupXLayer() {
        let dotPath = WSHPath.xPath(self.intCircleView?.bounds ?? CGRectZero, lineWidth: 12.0)
//        let dotPath = WSHPath.xPath(self.intCircleView?.bounds ?? CGRectZero)
        self.xLayer = CAShapeLayer()
        self.xLayer.path = dotPath.CGPath
//        self.xLayer.lineWidth = 6.0
        self.xLayer.strokeColor = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
//        self.xLayer.strokeColor = UIColor.blackColor().colorWithAlphaComponent(0.35).CGColor
        self.xLayer.fillColor = UIColor.blackColor().colorWithAlphaComponent(0.35).CGColor
        self.xLayer.hidden = !self.hasX
    }
    
}
