//
//  Dictionary+Extension.swift
//  CZUtils
//
//  Created by Cheng Zhang on 1/29/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import Foundation

public extension Dictionary {
    /// Retrieve value from `dotedKey`, compatible with multi-dot in keyPath. e.g. "user.profile.fullName"
    func value(forDotedKey dotedKey: String) -> Value? {
        return value(forSegmentedKey: dotedKey)
    }

    /// Retrieve value from `segmentedKey`, compatible with multi-segments separated by `splitter`. e.g. "user.profile.fullName", "user/profile/fullName"
    func value(forSegmentedKey segmentedKey: String, splitter: String = ".") -> Value? {
        var value: Any? = nil
        var dict: Dictionary? = self

        for subkey in segmentedKey.components(separatedBy: splitter) {
            guard dict != nil, let subkey = subkey as? Key else {
                return nil
            }
            value = dict?[subkey]
            dict = value as? Dictionary
        }
        return (value is NSNull) ? nil : (value as? Value)
    }
    
    /// Insert key/value pairs with input Dictionary
    mutating func insert(_ other: Dictionary) {
        for (key, value) in other {
            self[key] = value
        }
    }

    /// Pretty formatted description string
    var prettyDescription: String {
        return Pretty.describing(self)        
    }

}
