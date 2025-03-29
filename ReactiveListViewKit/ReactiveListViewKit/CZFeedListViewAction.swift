//
//  CZFeedViewAction.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 1/10/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit

/**
 CZActionProtocol handler closure
 */
public typealias OnAction = (_ action: CZActionProtocol) -> Void

/**
 General ViewAction
 */
public typealias CZViewAction = CZActionProtocol

public struct BaseState: StateProtocol {
  public func reduce(action: CZActionProtocol) -> Self {
    return self
  }
}

/**
 ViewAction for container feedListView
 */
public enum CZFeedListViewAction: CZViewAction {
  case selectedCell(IndexPath, CZFeedModel)
  case loadMore
  case pullToRefresh(isFirst: Bool)
  case prefetch([IndexPath])
  case cancelPrefetching([IndexPath])
  case visibleIndexPathsChanged(newValue: [IndexPath])// (oldIndexPaths, newIndexPaths)
}

