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

class FeedListEventHandler: NSObject {
    var coordinator: FeedListEventHandlerCoordinator?    
}

extension FeedListEventHandler: Middleware {
    func process(event: Event, state: FeedListState) {
        print("Received event: \(event)")
    }
}
