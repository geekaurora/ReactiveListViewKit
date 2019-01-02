//
//  UIView+Extension.swift
//
//  Created by Cheng Zhang on 1/12/16.
//  Copyright © 2016 Cheng Zhang. All rights reserved.
//

import UIKit

/// Constants for UIView extensions
public enum UIViewConstants {
    public static let fadeInDuration: TimeInterval = 0.4
    public static let fadeInAnimationName = "com.tony.animation.fadein"
}

// MARK: - Corner/Border

public extension UIView {
    public func roundToCircleWithFrame() {
        roundToCircle()
        addGrayFrame()
    }
        
    public func roundToCircle() {
        let width = self.bounds.size.width
        layer.cornerRadius = width / 2
        layer.masksToBounds = true
    }
    
    public func roundCornerWithFrame(cornerRadius: CGFloat = 1, white: CGFloat = CZTheme.greyDividerColor) {
        roundCorner(cornerRadius: cornerRadius)
        addGrayFrame(white)
    }
    
    public func roundCorner(cornerRadius: CGFloat = 2) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }
    
    public func addGrayFrame(_ white: CGFloat = CZTheme.greyDividerColor) {
        layer.borderWidth = 1
        layer.borderColor = UIColor(white: white, alpha: 1).cgColor
    }
}

// MARK: - Animations

public extension UIView {
    public func fadeIn(animationName: String = UIViewConstants.fadeInAnimationName,
                       duration: TimeInterval = UIViewConstants.fadeInDuration) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        layer.add(transition, forKey: animationName)
    }
}

