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
    var image: UIImage?
    
    init(name: String) {
        self.name = name
        
        super.init()
    }
    
    convenience init(name: String, image: UIImage) {
        self.init(name: name)
        
        self.image = image
    }
    
}
