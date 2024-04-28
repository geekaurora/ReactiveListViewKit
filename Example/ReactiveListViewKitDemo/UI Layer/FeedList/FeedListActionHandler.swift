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
class FeedListActionHandler: NSObject, MiddlewareProtocol {

  var coordinator: FeedListActionHandlerCoordinator?

  // MARK: - MiddlewareProtocol

  func process(action: CZActionProtocol, state: FeedListState) {
    dbgPrintWithFunc(self, "Received action: \(action)")
  }
}
