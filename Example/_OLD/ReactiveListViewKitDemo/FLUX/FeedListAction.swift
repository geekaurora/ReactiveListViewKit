//
//  FeedListActions.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 1/4/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import CZUtils
import ReactiveListViewKit

// MARK: - Events

/// Action that User likes one `Feed`
struct LikeFeedAction: CZActionProtocol {
  var feed: Feed
}
