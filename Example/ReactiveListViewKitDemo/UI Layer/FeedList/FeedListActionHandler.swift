//
//  FeedListActionHandler.swift
//  ReactiveListViewKitDemo
//
//  Created by Cheng Zhang on 7/14/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit
import ReactiveListViewKit

protocol FeedListActionHandlerCoordinator {}

/// Action handler for `FeedListViewController`, Coordinator pattern decouples user action handling from ViewController to make it less massive
class FeedListActionHandler: NSObject {
    var coordinator: FeedListActionHandlerCoordinator?    
}

extension FeedListActionHandler: Middleware {
    func process(action: Action, state: FeedListState) {
        dbgPrint("Received action: \(action)")
    }
}
