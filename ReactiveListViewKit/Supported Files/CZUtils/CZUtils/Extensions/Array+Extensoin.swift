//
//  Array+Extensoin.swift
//  CZUtils
//
//  Created by Cheng Zhang on 1/26/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import Foundation

public extension Array {
    /**
     Returns element at specified `safe` index if exists, otherwise nil
     */
    public subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

public extension Array where Element: NSCopying {
    public func copy(with zone: NSZone? = nil) -> Any {
        return compactMap{ $0.copy() }
    }
}
