//
//  Utils.swift
//  CZUtils
//
//  Created by Cheng Zhang on 2/19/18.
//  Copyright © 2018 Cheng Zhang. All rights reserved.
//

import Foundation

public class CZUtils {
    public static func dbgPrint(_ item: CustomStringConvertible) {
        #if DEBUG
            print(item)
        #endif
    }
}

public func dbgPrint(_ item: CustomStringConvertible) {
    CZUtils.dbgPrint(item)
}
