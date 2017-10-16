//
//  FeedListViewController.swift
//  ReactiveListViewKitDemo
//
//  Created by Cheng Zhang on 7/14/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit
import ReactiveListViewKit

class FeedListViewController: UIViewController, FeedListEventHandlerCoordinator {
    fileprivate var feedListFacadeView: CZReactiveFeedListFacadeView<FeedListState>?
    fileprivate var core: Core<FeedListState>
    
    required init?(coder aDecoder: NSCoder) {
        // Setup `Core` of FLUX pattern
        let feedListState = FeedListState()
        let eventHandler = FeedListEventHandler()
        core = Core<FeedListState>(state: feedListState, middlewares: [eventHandler])
        feedListState.core = core
        
        super.init(coder: aDecoder)
        eventHandler.coordinator = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFeedListView()
        core.add(subscriber: self)
    }
}

fileprivate extension FeedListViewController {
    func setupFeedListView() {
        feedListFacadeView = CZReactiveFeedListFacadeView<FeedListState>(core: core,
                                                                         sectionModelsResolver: core.state.sectionModelsResolver)
        feedListFacadeView?.overlayOnSuperViewController(self)
    }
}

extension FeedListViewController: Subscriber {
    func update(with state: FeedListState, prevState: FeedListState?) {
        feedListFacadeView?.batchUpdate(withFeeds: core.state.feeds)
    }
}
