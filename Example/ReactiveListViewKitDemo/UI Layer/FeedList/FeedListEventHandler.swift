//
//  FeedListEventHandler.swift
//  ReactiveListViewKitDemo
//
//  Created by Cheng Zhang on 7/14/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit
import ReactiveListViewKit

protocol FeedListEventHandlerCoordinator {}

/// Event handler for `FeedListViewController`, Coordinator pattern decouples user action handling from ViewController to make it less massive
class FeedListEventHandler: NSObject {
    var coordinator: FeedListEventHandlerCoordinator?    
}

extension FeedListEventHandler: Middleware {
    func process(event: Event, state: FeedListState) {
        dbgPrint("Received event: \(event)")
    }
}
