//
//  CZListDiffableHelper.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 1/29/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit

public class CZListDiffableHelper: NSObject {
    public class func isEqual(_ obj1: CZListDiffableObject?, _ obj2: CZListDiffableObject?) -> Bool {
        switch(obj1, obj2) {
        case let (obj1 as CZListDiffableObject, obj2 as CZListDiffableObject):
            return obj1.isEqual(toDiffableObj: obj2)
        default:
            return (obj1 == nil && obj2 == nil)
        }
    }
}
