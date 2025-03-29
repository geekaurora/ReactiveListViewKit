//
//  NSObject.swift
//  CZUtils
//
//  Created by Cheng Zhang on 5/19/16.
//  Copyright © 2016 Cheng Zhang. All rights reserved.
//

import Foundation

/**
 Convenient methods of NSObject
 */
public extension NSObject {
    var className: String {
        return NSStringFromClass(type(of: self))
    }
}
