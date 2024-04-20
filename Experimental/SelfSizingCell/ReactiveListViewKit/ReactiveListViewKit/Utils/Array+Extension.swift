//
//  Array+Extension.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 1/15/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit

extension Array where Element: CZListDiffableObject {
  /**
   Check whether elements in two arrays equal
   */
  public func isEqual(toDiffableObj object: Any) -> Bool {
    guard let object = object as? [Element],
          count == object.count  else {
      return false
    }
    return (0..<count).allSatisfy { i in
      self[i].isEqual(toDiffableObj: object[i])
    }
  }
}
