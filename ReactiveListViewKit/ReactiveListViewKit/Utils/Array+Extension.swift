//
//  Array+Extension.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 1/15/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit

extension Array where Element: CZListDiffableObject {
    /// Check whether elements of two involved arrays equal
    public func isEqual(toDiffableObj object: Any) -> Bool {
        guard let object = object as? [Element],
            count == object.count  else {
                return false
        }
        var i = -1
        return object.reduce(true) {
            i += 1
            return $0 && $1.isEqual(toDiffableObj: self[i])
        }
    }
}
