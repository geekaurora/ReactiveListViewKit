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
    var core: Core<StateType>
    
    public init(core: Core<StateType>,
                sectionModelsResolver: @escaping SectionModelsResolver,
                parentViewController: UIViewController? = nil,
                loadMoreThreshold: Int = CZFeedListFacadeView.kLoadMoreThreshold,
                minimumLineSpacing: CGFloat = ReactiveListViewKit.minimumLineSpacing) {
        self.core = core
        let onEvent = { (event: Event) in
            core.fire(event: event)
        }
        super.init(sectionModelsResolver: sectionModelsResolver,
                   onEvent: onEvent,
                   parentViewController: parentViewController,
                   loadMoreThreshold: loadMoreThreshold)
    }

    public required init?(coder: NSCoder) {
        fatalError("Must call designated initializer.")
    }
}

