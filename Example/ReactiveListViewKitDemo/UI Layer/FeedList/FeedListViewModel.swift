//
//  FeedListViewModel.swift
//  ReactiveListViewKitDemo
//
//  Created by Cheng Zhang on 7/14/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit
import CZUtils
import ReactiveListViewKit

typealias FeedListState = FeedListViewModel

/// State/ViewModel of `FeedListViewController`, composed of elements needed for UI populating
class FeedListViewModel: NSObject, CopyableState {
    /// List of feeds
    fileprivate(set) lazy var feeds: [Feed] = {       
        return CZMocker.shared.feeds
    }()
    /// List of users with Story
    fileprivate(set) var storyUsers: [User] = {
        return CZMocker.shared.hotUsers
    }()
    /// List of suggested users
    fileprivate(set) var suggestedUsers: [User] = {
        return CZMocker.shared.hotUsers
    }()
    /// Current page number
    fileprivate(set) var page: Int = 0
    /// Indicating whether is loading feeds
    fileprivate(set) var isLoadingFeeds: Bool = false
    /// Last minimum FeedId, used as baseId for feeds request
    fileprivate(set) var lastMinFeedId: String = "-1"
    /// `Core` of FLUX, composed of `Dispatcher` and `Store`
    var core: Core<FeedListState>?
    /// SectionModelsResolver closure -  mapping feeds to sectionModels
    var sectionModelsResolver: CZFeedListFacadeView.SectionModelsResolver!
        
    override init() {
        super.init()
        
        /// SectionModelsResolver closure -  mapping feeds to sectionModels
        sectionModelsResolver = { (feeds: [Any]) -> [CZSectionModel] in
            guard let feeds = feeds as? [Feed] else { fatalError() }
            var sectionModels = [CZSectionModel]()
            
            // HotUsers section
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

            // Feeds section
            var feedModels = feeds.flatMap { CZFeedModel(viewClass: FeedCellView.self,
                                                         viewModel: FeedCellViewModel($0)) }
            
            // SuggestedUsers - CellViewController
            if feedModels.count > 0 {
                let suggestedUsers = self.suggestedUsers
                let suggestedUsersFeedModel = CZFeedModel(viewClass: HotUsersCellViewController.self,
                                                          viewModel: HotUsersCellViewModel(suggestedUsers))
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
    /// Reacts to fired events
    func react(to event: Event) {
        feeds.forEach { $0.react(to: event) }
        switch event {
        case let CZFeedListViewEvent.selectedCell(feedModel):
            break
        default:
            break
        }
    }
}

