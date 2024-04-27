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

/**
 ViewController of FeedList, acts as dumb and thin container that mediates nothing
 */
class FeedListViewController: UIViewController, FeedListActionHandlerCoordinator {
  /// Facade list view
  private var feedListFacadeView: CZReactiveFeedListFacadeView<FeedListState>?
  /// Store that maintains State
  private var store: Store<FeedListState>

  required init?(coder aDecoder: NSCoder) {
    // Set up `Store` for FLUX pattern
    let feedListState = FeedListState()
    // Action handler: coordinator pattern decouples user action handling from ViewController
    let actionHandler = FeedListActionHandler()
    store = Store<FeedListState>(state: feedListState, middlewares: [actionHandler])
    feedListState.store = store

    super.init(coder: aDecoder)
    actionHandler.coordinator = self
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setupFeedListView()
    setupAccessibility()
    store.registerObserver(self)
  }
}

// Mark: - Private Methods

private extension FeedListViewController {
  func setupFeedListView() {
    feedListFacadeView = CZReactiveFeedListFacadeView<FeedListState>(
      store: store,
      sectionModelsTransformer: store.state.sectionModelsTransformer,
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

extension FeedListViewController: StoreObserver {
  /// Notify FacadeListView to batch update automatically
  func storeDidUpdate(state: FeedListState,
                      previousState: FeedListState?) {
    feedListFacadeView?.batchUpdate(withFeeds: store.state.feeds)
  }
}
