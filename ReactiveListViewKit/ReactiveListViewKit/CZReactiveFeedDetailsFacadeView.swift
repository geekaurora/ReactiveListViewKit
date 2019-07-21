//
//  CZReactiveFeedDetailsFacadeView.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 2/11/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit

private var kViewModelObserverContext: Int = 0

/// Reactive view class of `FeedDetailsFacadeView`, supports FLUX pattern
open class CZReactiveFeedDetailsFacadeView<StateType: CopyableState>: CZFeedDetailsFacadeView {
    var store: Store<StateType>?
    public override var onAction: OnAction? {
        get {
            guard let store = store else {  return super.onAction }
            return {action in store.dispatch(action: action) }
        }
        set { super.onAction = newValue }
    }

    public init(containerViewController: UIViewController? = nil, store: Store<StateType>? = nil, onAction: OnAction? = nil) {
        super.init(containerViewController: containerViewController, onAction: onAction)
        self.store = store
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public override func setup() {
        super.setup()
    }
}


