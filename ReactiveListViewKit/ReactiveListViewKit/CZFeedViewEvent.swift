//
//  CZFeedViewEvent.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 1/10/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit

/// Action handler closure
public typealias OnAction = (_ action: Action) -> Void

/// General ViewEvent
public typealias CZViewEvent = Action

public struct BaseState: State {
    public func reduce(action: Action) {}
}

/// ViewEvent for container feedListView
public enum CZFeedListViewEvent: CZViewEvent {
    case selectedCell(CZFeedModel)
    case loadMore
    case pullToRefresh(isFirst: Bool)
    case prefetch([IndexPath])
    case cancelPrefetching([IndexPath])
    case visibleIndexPathsChanged(newValue: [IndexPath])// (oldIndexPaths, newIndexPaths)
}

