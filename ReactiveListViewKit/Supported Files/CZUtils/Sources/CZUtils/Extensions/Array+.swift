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
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
    /**
     Pretty formatted description string
     */
    var prettyDescription: String {
        return Pretty.describing(self)
    }
}

public extension Array where Element: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return compactMap{ $0.copy() }
    }
}
