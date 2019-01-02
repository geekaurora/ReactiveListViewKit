//
//  UIButton+Extension.swift
//  CZUtils
//
//  Created by Cheng Zhang on 3/7/16.
//  Copyright © 2016 Cheng Zhang. All rights reserved.
//

import UIKit

private var controlHandlerKey: Int8 = 0
public extension UIButton {
    /**
      Add self-contained action handler for button
     */
    public func addHandler(for controlEvents: UIControl.Event, handler: @escaping (UIButton) -> ()) {
        if let oldTarget = objc_getAssociatedObject(self, &controlHandlerKey) as? CocoaTarget<UIButton> {
            self.removeTarget(oldTarget, action: #selector(oldTarget.sendNext), for: controlEvents)
        }
        
        let target = CocoaTarget<UIButton>(handler)
        objc_setAssociatedObject(self, &controlHandlerKey, target, .OBJC_ASSOCIATION_RETAIN)
        self.addTarget(target, action: #selector(target.sendNext), for: controlEvents)
    }
    
    /**
      Set image with tintColor for desired controlState
     */
    public func setImage(_ imageName: String, for controlState: UIControl.State = .normal, tintColor: UIColor) {
        let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        setImage(image, for: controlState)
        self.tintColor = tintColor
    }
}

/**
  A target that accepts action messages
 */
public final class CocoaTarget<T>: NSObject {
    private let action: (T) -> ()
    
    public init(_ action: @escaping (T) -> ()) {
        self.action = action
    }
    
    @objc
    public func sendNext(_ receiver: Any?) {
        guard let receiver = receiver as? T else {
            preconditionFailure("`receiver` isn't expected type.")
        }
        action(receiver)
    }
}
