//
//  FeedListViewController.swift
//  ReactiveListViewKitDemo
//
//  Created by Cheng Zhang on 7/14/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit
import ReactiveListViewKit

/// ViewController of FeedList, acts as dumb container that mediates nothing
class FeedListViewController: UIViewController, FeedListEventHandlerCoordinator {
    /// Facade list view
    fileprivate var feedListFacadeView: CZReactiveFeedListFacadeView<FeedListState>?
    /// `Core` of FLUX, composed of `Dispatcher` and `Store`
    fileprivate var core: Core<FeedListState>
    
    fileprivate lazy var autoScrollManager: CollectionViewScrollMonitor = {
        let autoScrollManager = CollectionViewScrollMonitor(collectionView: self.feedListFacadeView!.collectionView)
        autoScrollManager.delegate = self
        return autoScrollManager
    }()
    
    fileprivate lazy var fpsMonitor: FPSMonitor = {
        let fpsMonitor = FPSMonitor()
        fpsMonitor.delegate = self
        return fpsMonitor
    }()
    
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
        core.add(subscriber: self)
        
        fpsMonitor.resume()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

// Mark: - Private Methods

fileprivate extension FeedListViewController {
    func setupFeedListView() {
        feedListFacadeView = CZReactiveFeedListFacadeView<FeedListState>(
            core: core,
            sectionModelsResolver: core.state.sectionModelsResolver,
            parentViewController:self)
        feedListFacadeView?.overlayOnSuperViewController(self, insets: Constants.feedListViewInsets)
    }
}

// MARK: - Subscriber

extension FeedListViewController: Subscriber {
    /// Notify FacadeListView to batch update automatically
    func update(with state: FeedListState, prevState: FeedListState?) {
        feedListFacadeView?.batchUpdate(withFeeds: core.state.feeds)
        
        autoScrollManager.refreshIndexPathsForVisibleItems()
    }
}

extension FeedListViewController: FPSMonitorDelegate {
    func framesDropped(_ framesDroppedCount: Double, cumulativeFramesDropped: Double, cumulativeFrameDropEvents: Int) {
        print("[FPSMonitor] framesDroppedCount: \(framesDroppedCount); cumulativeFramesDropped: \(cumulativeFramesDropped); cumulativeFrameDropEvents: \(cumulativeFrameDropEvents)")
    }
}

extension FeedListViewController: CollectionViewScrollMonitorDelegate {
    func indexPathsForVisibleItemsDidChange(_ indexPathsForVisibleItems: [IndexPath]) {
        print("[FPSMonitor] [threshold] Dropped frames: \(fpsMonitor.currentFrameDropCount); indexPathsForVisibleItems:\(indexPathsForVisibleItems)")
        fpsMonitor.reset()
    }
}

