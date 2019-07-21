//
//  CZReactiveFeedListFacadeView.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 2/11/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit

/// Reactive view class of `FeedListFacadeView`, supports FLUX pattern
open class CZReactiveFeedListFacadeView<StateType: CopyableState>: CZFeedListFacadeView {
    var store: Store<StateType>
    
    public init(store: Store<StateType>,
                sectionModelsTransformer: @escaping SectionModelsTransformer,
                parentViewController: UIViewController? = nil,
                loadMoreThreshold: Int = CZFeedListFacadeView.kLoadMoreThreshold,
                minimumLineSpacing: CGFloat = ReactiveListViewKit.minimumLineSpacing) {
        self.store = store
        let onAction = { (action: Action) in
            store.dispatch(action: action)
        }
        super.init(sectionModelsTransformer: sectionModelsTransformer,
                   onAction: onAction,
                   parentViewController: parentViewController,
                   loadMoreThreshold: loadMoreThreshold)
    }

    public required init?(coder: NSCoder) {
        fatalError("Must call designated initializer.")
    }
}

