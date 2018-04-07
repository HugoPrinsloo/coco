//
//  UIImage+Extensions.swift
//  Coco
//
//  Created by Hugo Prinsloo on 2018/04/07.
//  Copyright © 2018 Over. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// Image at specified size filled with colors
    /// - parameter color: Color to fill new image with
    /// - parameter size: Size of new image
    /// - returns: Image at specified size filled with color
    class func imageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
        assert(size.width > 0 && size.height > 0, "imageWithColor(:) requires a size larger than 0 x 0")
        
        UIGraphicsBeginImageContext(size)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(origin: CGPoint.zero, size: size))
        
        let output = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return output!
    }
    
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        assert(size.width > 0 && size.height > 0, "UIImage.init(color: size:) requires a size larger than 0 x 0")
        UIGraphicsBeginImageContext(size)
        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    /// Average color from image
    /// Uses core graphics interpolation to draw the full image in a single
    /// 1x1 pixel context and then getting the color in a RGB space with alpha.
    /// - returns: Average UIColor in a RGB space with alpha component.
    func averageColor() -> UIColor {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        var rgba = [UInt8](repeating: 0, count: 4)
        let context = CGContext(data: &rgba, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        let drawRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        context?.draw(cgImage!, in: drawRect)
        
        let max: CGFloat = 255.0
        let r = CGFloat(rgba[0]) / max
        let g = CGFloat(rgba[1]) / max
        let b = CGFloat(rgba[2]) / max
        let a = CGFloat(rgba[3]) / max
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    /// Uses alpha channel of image to draw a new image in a single color
    func withTint(_ color: UIColor) -> UIImage? {
        guard let cgImage = self.cgImage else {
            // We make sure we have this before setting up a context
            return nil
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        context.scaleBy(x: 1, y: -1)
        context.translateBy(x: 0, y: -size.height)
        let clipRect = CGRect(origin: .zero, size: size)
        context.clip(to: clipRect, mask: cgImage)
        context.setFillColor(color.cgColor)
        context.fill(clipRect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
