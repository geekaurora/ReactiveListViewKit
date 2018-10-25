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
    private lazy var fpsMonitor = FPSMonitor()
    
    private lazy var performanceDetector: KSScrollPerformanceDetector = {
        let performanceDetector = KSScrollPerformanceDetector()
        performanceDetector.delegate = self
        return performanceDetector
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
        
        //KSScrollPerformanceDetector.init
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFeedListView()
        core.add(subscriber: self)
        
        //fpsMonitor.resume()
        performanceDetector.resume()
    }
}

extension FeedListViewController: KSScrollPerformanceDetectorDelegate {
    func framesDropped(_ framesDroppedCount: Int, cumulativeFramesDropped: Int, cumulativeFrameDropEvents: Int) {
        print("framesDroppedCount: \(framesDroppedCount); cumulativeFramesDropped: \(cumulativeFramesDropped); cumulativeFrameDropEvents: \(cumulativeFrameDropEvents)")
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
    }
}


