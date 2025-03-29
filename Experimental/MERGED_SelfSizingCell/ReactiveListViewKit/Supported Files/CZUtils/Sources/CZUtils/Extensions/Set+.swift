//
//  Dictionary+Extension.swift
//  CZUtils
//
//  Created by Cheng Zhang on 1/29/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import Foundation

public extension Set {

  func compactMap<ElementOfResult>(_ transform: (Element) -> ElementOfResult?)  -> [ElementOfResult] {
        return Array(self).compactMap(transform)
    }

}
