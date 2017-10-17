//
//  FeedListViewModel.swift
//  ReactiveListViewKitDemo
//
//  Created by Cheng Zhang on 7/14/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit
import ReactiveListViewKit

// State
typealias FeedListState = FeedListViewModel

class FeedListViewModel: NSObject, CopyableState {
    fileprivate(set) lazy var feeds: [Feed] = {
        return CZMocker.shared.feeds
    }()
    fileprivate(set) var storyUsers: [User] = {
        return CZMocker.shared.hotUsers
    }()
    fileprivate(set) var suggestedUsers: [User] = {
        return CZMocker.shared.hotUsers
    }()
    
    fileprivate(set) var page: Int = 0
    fileprivate(set) var isLoadingFeeds: Bool = false
    fileprivate(set) var lastMinFeedId: String = "-1"
    var core: Core<FeedListState>?
    var sectionModelsResolver: CZFeedListFacadeView.SectionModelsResolver!
        
    override init() {
        super.init()
        
        /// Initialize sectionModelsResolver, mapping Feeds to SectionModels
        sectionModelsResolver = { (feeds: [Any]) -> [CZSectionModel] in
            guard let feeds = feeds as? [Feed] else { fatalError() }
            var sectionModels = [CZSectionModel]()
            
            // 1. HotUsers section
            let HotUsersFeedModels = self.storyUsers.flatMap { CZFeedModel(viewClass: HotUserCellView.self,
                                                                           viewModel: HotUserCellViewModel($0)) }
            
            let hotUsersSectionModel = CZSectionModel(isHorizontal: true,
                                                      heightForHorizontal: HotUserSection.heightForHorizontal,
                                                      feedModels: HotUsersFeedModels,
                                                      headerModel: CZFeedListSupplementaryTextFeedModel(title: "Stories",
                                                                                                        inset: UIEdgeInsets(top: 8,
                                                                                                                            left: 10,
                                                                                                                            bottom: 1,
                                                                                                                            right: 10)),
                                                      footerModel: CZFeedListSupplementaryLineFeedModel(),
                                                      sectionInset: UIEdgeInsets(top: 0,
                                                                                 left: 3,
                                                                                 bottom: 0,
                                                                                 right: 5))
            sectionModels.append(hotUsersSectionModel)
            
            // 2. Feeds section
            var feedModels = feeds.flatMap { CZFeedModel(viewClass: FeedCellView.self,
                                                         viewModel: FeedCellViewModel($0)) }
            
            // 3. SuggestedUsers - CellViewController
            if feedModels.count > 0 {
                let filteredSuggestedUsers = self.suggestedUsers
                let suggestedUsersFeedModel = CZFeedModel(viewClass: HotUsersCellViewController.self,
                                                          viewModel: HotUsersCellViewModel(filteredSuggestedUsers))
                feedModels.insert(suggestedUsersFeedModel, at: 3)
            }
            let feedsSectionModel = CZSectionModel(feedModels: feedModels)
            
            sectionModels.append(feedsSectionModel)
            return sectionModels
        }
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}

extension FeedListViewModel: State {
    func react(to event: Event) {
        feeds.forEach {$0.react(to: event)}
        
        switch event {
        case let CZFeedListViewEvent.selectedCell(feedModel):
            print(feedModel)
        default:
            break
        }
    }
}

