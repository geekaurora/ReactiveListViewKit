//
//  HotUsersCellViewModel.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 3/4/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit
import ReactiveListViewKit

class HotUsersCellViewModel: NSObject, CZFeedViewModelable {
  var diffId: String {
    return currentClassName
  }
  private(set) var users: [User]
  
  required init(_ users: [User]) {
    self.users = users
    super.init()
  }
  
  func isEqual(toDiffableObj object: AnyObject) -> Bool {
    guard let object = object as? HotUsersCellViewModel else {return false}
    return users.isEqual(toDiffableObj: object.users)
  }
  
  func copy(with zone: NSZone?) -> Any {
    let usersCopy = users.copy() as! [User]
    return HotUsersCellViewModel(usersCopy)
  }
}

extension HotUsersCellViewModel: State {
  func reduce(action: Action) -> Self {
    return self
  }
}
