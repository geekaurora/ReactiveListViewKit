//
//  FeedListActionHandler.swift
//  ReactiveListViewKitDemo
//
//  Created by Cheng Zhang on 7/14/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit
import CZUtils
import ReactiveListViewKit

protocol FeedListActionHandlerCoordinator {}

/**
 Action handler for `FeedListViewController`

 Coordinator pattern decouples user action handling from ViewController to make it less massive
 */
class FeedListActionHandler: NSObject, StoreObserverProtocol {

  var coordinator: FeedListActionHandlerCoordinator?

  // MARK: - StoreObserverProtocol

  func storeDidUpdate(state: FeedListState,
                      previousState: FeedListState?) {
    // No-op.
  }

  /// Handles the store `action`.
  func didReceiveStoreAction(_ action: CZActionProtocol) {
    dbgPrintWithFunc(self, "\(action)")
    
    switch action {
    case let CZFeedListViewAction.selectedCell(feedModel):
      break
    default:
      break
    }
  }
}
