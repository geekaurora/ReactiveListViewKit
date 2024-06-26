//
//  UserStoryEvent.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 3/28/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit
import ReactiveListViewKit

/// Action that User selects `UserStory`
enum UserStoryAction: CZActionProtocol {
  case selected(user: User)
}
