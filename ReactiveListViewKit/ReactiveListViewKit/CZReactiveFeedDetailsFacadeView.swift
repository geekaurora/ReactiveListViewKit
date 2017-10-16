//
//  CZReactiveFeedDetailsFacadeView.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 2/11/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit

private var kViewModelObserverContext: Int = 0

/// Reactive view class of FeedDetailsFacadeView, supports FLUX pattern
open class CZReactiveFeedDetailsFacadeView<StateType: CopyableState>: CZFeedDetailsFacadeView {
    var core: Core<StateType>?
    public override var onEvent: OnEvent? {
        get {
            guard let core = core else {  return super.onEvent }
            return {event in core.fire(event: event) }
        }
        set { super.onEvent = newValue }
    }

    public init(containerViewController: UIViewController? = nil, core: Core<StateType>? = nil, onEvent: OnEvent? = nil) {
        super.init(containerViewController: containerViewController, onEvent: onEvent)
        self.core = core
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public override func setup() {
        super.setup()
    }
}


