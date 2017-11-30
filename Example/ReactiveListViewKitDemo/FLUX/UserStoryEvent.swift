//
//  UserStoryEvent.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 3/28/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit
import ReactiveListViewKit

/// Event that User selects `UserStory`
enum UserStoryEvent: Event {
    case selected(user: User)
}
