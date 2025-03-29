//
//  User.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 1/3/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import CZUtils
import ReactiveListViewKit

/// Model of user
class User: ReactiveListDiffable {
  let userId: String
  let userName: String
  let fullName: String?
  let portraitUrl: String?
  
  enum CodingKeys: String, CodingKey {
    case userId = "id"
    case userName = "username"
    case fullName = "full_name"
    case portraitUrl = "profile_picture"
  }
  
  // MARK: - CZListDiffable
  func isEqual(toDiffableObj object: AnyObject) -> Bool {
    return isEqual(toCodable: object)
  }
  
  // MARK: - NSCopying
  func copy(with zone: NSZone? = nil) -> Any {
    return codableCopy(with: zone)
  }
}
