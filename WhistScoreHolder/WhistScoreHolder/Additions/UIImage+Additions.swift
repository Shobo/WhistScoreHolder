//
//  UIImage+Additions.swift
//  WhistScoreHolder
//
//  Created by OctavF on 01/03/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

import UIKit

extension UIImage {
    
    func scale(toSize targetSize: CGSize) -> (UIImage) {
        let size = self.size
        
        let widthRatio  = targetSize.width  / self.size.width
        let heightRatio = targetSize.height / self.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func averageColour() -> UIColor {
        let rgba = UnsafeMutablePointer<CUnsignedChar>.alloc(4)
        let colorSpace: CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()!
        let info = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue)
        let context: CGContextRef = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, info.rawValue)!
        
        CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), self.CGImage)
        
        if rgba[3] > 0 {
            
            let alpha: CGFloat = CGFloat(rgba[3]) / 255.0
            let multiplier: CGFloat = alpha / 255.0
            
            return UIColor(red: CGFloat(rgba[0]) * multiplier, green: CGFloat(rgba[1]) * multiplier, blue: CGFloat(rgba[2]) * multiplier, alpha: alpha)
            
        } else {
            
            return UIColor(red: CGFloat(rgba[0]) / 255.0, green: CGFloat(rgba[1]) / 255.0, blue: CGFloat(rgba[2]) / 255.0, alpha: CGFloat(rgba[3]) / 255.0)
        }
    }
    
    func centerCroppedImage(withSize: CGSize) -> UIImage {
        let x = max((self.size.width - withSize.width) / 2.0, 0.0)
        let y = max((self.size.height - withSize.height) / 2.0, 0.0)
        let rect = CGRectMake(x, y, withSize.width, withSize.height)
        
        let imageRef = CGImageCreateWithImageInRect(self.CGImage, rect)
        
        if let imageR = imageRef {
            return UIImage.init(CGImage: imageR, scale: 1.0, orientation: self.imageOrientation)
        }
        return self
    }
    
    
    //MARK: - Class methods
    
    
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    class func randomColorImage(withSize size: CGSize) -> UIImage {
        return UIImage.imageWithColor(UIColor.randomColor(), size:size)
    }
    
    class func visibleImageFromImageView(imageView: UIImageView) -> UIImage? {
        var image: UIImage?
        
        UIGraphicsBeginImageContext(imageView.bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            CGContextRotateCTM(context, CGFloat(2 * M_PI))
            
            imageView.layer.renderInContext(context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        
        return image
    }
    
}
