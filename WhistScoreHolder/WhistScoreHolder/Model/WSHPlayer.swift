//
//  WSHPlayer.swift
//  WhistScoreHolder
//
//  Created by Mihai Costiug on 28/02/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

import UIKit

class WSHPlayer: NSObject {
    
    var name: String
    var image: UIImage? {
        didSet(newValue) {
            if let avgImageColour = image?.averageColour() {
                complementaryColor = avgImageColour.complementaryColor()
            } else {
                complementaryColor = UIColor.colorFromRGB(colour).complementaryColor()
            }
        }
    }
    fileprivate(set) var complementaryColor: UIColor?
    var colour: UInt = 0 {
        didSet(newValue) {
            if image == nil {
                complementaryColor = UIColor.colorFromRGB(colour).complementaryColor()
            }
        }
    }
    
    init(name: String) {
        self.name = name
        
        super.init()
    }
    
    
    //MARK: - Public
    
    
    func presentableImage() -> UIImage {
        let presentableImageSize = CGSize(width: 100.0, height: 100.0)
        
        return image?.scale(toSize: presentableImageSize) ?? UIImage.imageWithColor(UIColor.colorFromRGB(colour), size: presentableImageSize)
    }
}
