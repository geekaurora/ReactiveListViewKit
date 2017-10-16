//
//  Swizzling.swift
//
//  Created by Cheng Zhang on 12/9/15.
//  Copyright © 2015 Cheng Zhang. All rights reserved.
//

import UIKit

/// Generic swizzling function - workable for subclasses of `NSObject`,
/// as `NSObject` subclass maintains a dispatchTable which maps method selector and actural IMP
public func swizzling(_ forClass: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {
    let originalMethod = class_getInstanceMethod(forClass, originalSelector)
    let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector)
    let didAddMethod = class_addMethod(forClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
    if didAddMethod {
        class_replaceMethod(forClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}

