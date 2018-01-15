//
//  UIImage+Extension.swift
//
//  Created by Cheng Zhang on 1/12/16.
//  Copyright © 2016 Cheng Zhang. All rights reserved.
//

import UIKit
import ImageIO

public extension UIImage {
    @objc(cropToRect:)
    public func crop(toRect rect: CGRect) -> UIImage {
        let croppedCGImage = self.cgImage!.cropping(to: rect)!
        let res = UIImage(cgImage: croppedCGImage)
        return res
    }
    
    @objc(cropToSize:)
    public func crop(toSize size: CGSize) -> UIImage {
        var size = size
        let ratio = size.height / size.width
        if  size.width <  size.height {
            size.width = self.size.width * self.scale
            size.height = size.width * ratio
        } else {
            size.height = self.size.height * self.scale
            size.width = size.width * ratio
        }
        let rect = CGRect(origin: CGPoint(x: (self.size.width * self.scale - size.width) / 2,
                                          y: (self.size.height * self.scale - size.height) / 2),
                          size: size)
        return crop(toRect: rect)
    }
    
    // height / width
    @objc(cropToRatio:)
    public func crop(toRatio ratio: CGFloat) -> UIImage {
        var size: CGSize = self.size
        if  ratio < 1 {
            size.width = self.size.width * self.scale
            size.height = size.width * ratio
        } else {
            size.height = self.size.height * self.scale
            size.width = size.height / ratio
        }
        let rect = CGRect(origin: CGPoint(x: (self.size.width * self.scale - size.width) / 2,
                                          y: (self.size.height * self.scale - size.height) / 2),
                          size: size)
        return crop(toRect: rect)
    }
}
