//
//  ImageInfo.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 1/4/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import CZUtils
import ReactiveListViewKit

/// Model of image info
class ImageInfo: ReactiveListDiffable {
  let url: String
  let width: Int
  let height: Int
  
  // MARK: - CZListDiffable
  func isEqual(toDiffableObj object: AnyObject) -> Bool {
    return isEqual(toCodable: object)
  }
  
  // MARK: - NSCopying
  func copy(with zone: NSZone? = nil) -> Any {
    return codableCopy(with: zone)
  }
}
