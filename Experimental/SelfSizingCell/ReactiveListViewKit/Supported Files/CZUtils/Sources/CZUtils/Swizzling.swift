//
//  Swizzling.swift
//
//  Created by Cheng Zhang on 12/9/15.
//  Copyright © 2015 Cheng Zhang. All rights reserved.
//

import Foundation

/// Generic swizzling function - workable for subclasses of NSObject
/// NSObject subclass maintains a DispatchTable which maps between method selector and actural IMP
public func swizzling(_ aClass: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {
    let originalMethod = class_getInstanceMethod(aClass, originalSelector)
    let swizzledMethod = class_getInstanceMethod(aClass, swizzledSelector)
    let didAddMethod = class_addMethod(aClass, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
    if didAddMethod {
        class_replaceMethod(aClass, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!)!)
    } else {
        method_exchangeImplementations(originalMethod!, swizzledMethod!)
    }
}

