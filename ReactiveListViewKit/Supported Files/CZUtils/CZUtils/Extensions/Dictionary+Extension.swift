//
//  Dictionary+Extension.swift
//  CZUtils
//
//  Created by Cheng Zhang on 1/29/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit

public extension Dictionary {
    /// Retrieve value from `externalRepresentation` dictionary, dealing with "." in keyPath
    func value(forDotedKey dotedKey: String) -> Value? {
        var value: Any? = nil
        var dict: Dictionary? = self
        for subKey in dotedKey.components(separatedBy: ".") {
            if dict == nil {return nil}
            guard let subKey = subKey as? Key else {return nil}
            value = dict?[subKey]
            dict = value as? Dictionary
        }
        return (value is NSNull) ? nil : (value as? Value)
    }
    
    /// Insert key/value pairs with input Dictionary
    public mutating func insert(_ other: Dictionary) {
        for (key, value) in other {
            self[key] = value
        }
    }
}
