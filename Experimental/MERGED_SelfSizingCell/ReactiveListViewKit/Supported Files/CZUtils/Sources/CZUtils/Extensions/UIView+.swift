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
        
  func roundToCircle() {
        let width = self.bounds.size.width
        layer.cornerRadius = width / 2
        layer.masksToBounds = true
    }

  func roundCorner(_ cornerRadius: CGFloat = 2,
                            boarderWidth: CGFloat = 0,
                            boarderColor: UIColor = .clear,
                            shadowColor: UIColor = .clear,
                            shadowOffset: CGSize = .zero,
                            shadowRadius: CGFloat = 2,
                            shadowOpacity: Float = 1) {
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
        layer.borderColor = boarderColor.cgColor
        layer.borderWidth = boarderWidth

        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
    }

}

// MARK: - Animations

public extension UIView {
  func fadeIn(animationName: String = UIViewConstants.fadeInAnimationName,
                       duration: TimeInterval = UIViewConstants.fadeInDuration) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        layer.add(transition, forKey: animationName)
    }
}

