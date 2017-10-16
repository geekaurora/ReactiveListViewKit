//
//  Array+Extensoin.swift
//  CZUtils
//
//  Created by Cheng Zhang on 1/26/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit

extension Array where Element: NSCopying {
    public func copy(with zone: NSZone? = nil) -> Any {
        return flatMap{ $0.copy() }
    }
}
