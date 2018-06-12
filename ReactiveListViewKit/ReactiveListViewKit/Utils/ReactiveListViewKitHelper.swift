//
//  ReactiveListViewKitHelper.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 11/6/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import CZUtils

public func dbgPrint(_ item: CustomStringConvertible) {
    guard ReactiveListViewKit.isDebugMode else { return }
    CZUtils.dbgPrint(item)
}

public func PrettyString(_ object: Any) -> String {
    guard let object = object as? CustomStringConvertible else {
        return ""
    }
    if let indexSet = object as? IndexSet {
        return indexSet.reduce("[") { (prevResult, index) -> String in
                    prevResult + String(index) + ", "
                } + "]"
    } else {
        return object.description
    }
}
