//
//  FeedListViewController.swift
//  ReactiveListViewKitDemo
//
//  Created by Cheng Zhang on 7/14/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit
import CZUtils
import ReactiveListViewKit

/// ViewController of FeedList, acts as dumb/thin container - mediates nothing
class FeedListViewController: UIViewController, FeedListEventHandlerCoordinator {
    /// Facade list view
    private var feedListFacadeView: CZReactiveFeedListFacadeView<FeedListState>?
    /// `Core` of FLUX, composed of `Dispatcher` and `Store`
    private var core: Core<FeedListState>

    required init?(coder aDecoder: NSCoder) {
        // Set up `Core` for FLUX pattern
        let feedListState = FeedListState()
        // Event handler: coordinator pattern decouples user action handling from ViewController
        let eventHandler = FeedListEventHandler()
        core = Core<FeedListState>(state: feedListState, middlewares: [eventHandler])
        feedListState.core = core
        
        super.init(coder: aDecoder)
        eventHandler.coordinator = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFeedListView()
        setupAccessibility()
        core.add(subscriber: self)
    }
}

// Mark: - Private Methods

private extension FeedListViewController {
    func setupFeedListView() {
        feedListFacadeView = CZReactiveFeedListFacadeView<FeedListState>(
            core: core,
            sectionModelsTransformer: core.state.sectionModelsTransformer,
            parentViewController: self)
        feedListFacadeView?.overlayOnSuperViewController(self, insets: Constants.feedListViewInsets)
    }
    func setupAccessibility() {
        feedListFacadeView?.collectionView?.accessibilityLabel = AccessibilityLabel.feedListCollectionView
        feedListFacadeView?.collectionView?.accessibilityIdentifier = AccessibilityLabel.feedListCollectionView
        feedListFacadeView?.collectionView?.isAccessibilityElement = true
    }
}

// MARK: - Subscriber

extension FeedListViewController: Subscriber {
    /// Notify FacadeListView to batch update automatically
    func update(with state: FeedListState, prevState: FeedListState?) {
        feedListFacadeView?.batchUpdate(withFeeds: core.state.feeds)
    }
}


