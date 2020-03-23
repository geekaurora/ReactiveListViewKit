//
//  Error+.swift
//  CZUtils
//
//  Created by Cheng Zhang on 8/10/19.
//  Copyright © 2019 Cheng Zhang. All rights reserved.
//

import Foundation

public extension Error {
    var retrievedCode: Int {
        return (self as NSError).code
    }
}
