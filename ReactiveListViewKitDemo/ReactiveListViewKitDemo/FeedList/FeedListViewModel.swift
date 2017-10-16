//
//  FeedListViewModel.swift
//  ReactiveListViewKitDemo
//
//  Created by Cheng Zhang on 7/14/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit
import ReactiveListViewKit

// Models
typealias Feed = String
typealias User = String

// State
typealias FeedListState = FeedListViewModel

class FeedListViewModel: NSObject {
    fileprivate(set) lazy var feeds: [Feed] = {
        return (0 ..< 30).lazy.flatMap { "Feed" + String($0) }
    }()
    fileprivate(set) lazy var storyUsers: [User] = {
        return (0 ..< 20).lazy.flatMap { "User" + String($0) }
    }()
    fileprivate(set) lazy var suggestedUsers: [User] = {
        return (60 ..< 80).lazy.flatMap { "User" + String($0) }
    }()
    fileprivate(set) var sectionModelsResolver: CZFeedListFacadeView.SectionModelsResolver!
    var core: Core<FeedListState>?
    
    override init() {
        super.init()
        
        sectionModelsResolver = { [weak self] (feeds: [Any]) -> [CZSectionModel] in
            guard let feeds = feeds as? [Feed],
                  let `self` = self else { preconditionFailure() }
            var sectionModels = [CZSectionModel]()
            
            // 1. Horizontal Section: User stories
            let hotUsers = self.storyUsers
            let HotUsersFeedModels: [CZFeedModel] = hotUsers.flatMap { CZSimpleTextFeedModel(text: $0, isHorizontal: true) }
            let tappedWatchAll = { (button: UIButton) in
                print("Tapped WatchAll button")
            }
            let HotUsersCellModel = CZSectionModel(isHorizontal: true,
                                                   heightForHorizontal: Constants.userStoriesSectionHeight + 20,
                                                   feedModels: HotUsersFeedModels,
                                                   headerModel: CZFeedListSupplementaryTextFeedModel(title: "Stories",
                                                                                                     actionButtonText: "Watch All",
                                                                                                     actionButtonClosure: tappedWatchAll),
                                                   footerModel: CZFeedListSupplementaryLineFeedModel())
            sectionModels.append(HotUsersCellModel)
            
            // 2. Vertical Section: Feed list
            var feedModels: [CZFeedModel] = feeds.flatMap { CZSimpleTextFeedModel(text: $0) }
            
            // 3. Horizontal Cell - suggestedUsers: Dynamically inserted horizontalList cell
            if feedModels.count > 0 {
                let tappedSeeAll = { (button: UIButton) in
                    print("Tapped SeeAll button")
                }
                let headerModel = CZFeedListSupplementaryTextFeedModel(title: "Suggestions for You",
                                                                       actionButtonText: "See All",
                                                                       actionButtonClosure: tappedSeeAll)
                let suggestedUsersHorizontalModels = self.suggestedUsers.flatMap { CZSimpleTextFeedModel(text: $0, isHorizontal: true) }
                let horizontalSectionAdapterViewModel = CZHorizontalSectionAdapterViewModel(suggestedUsersHorizontalModels,
                                                                                            headerModel: headerModel,
                                                                                            backgroundColor: Constants.suggestedUsersCellBGColor,
                                                                                            viewHeight: Constants.suggestedUsersCellHeight,
                                                                                            showTopDivider: true,
                                                                                            showBottomDivider: true)
                let suggestedUsersFeedModel: CZFeedModel = CZFeedModel(viewClass: CZHorizontalSectionAdapterCell.self,
                                                                       viewModel: horizontalSectionAdapterViewModel)
                feedModels.insert(suggestedUsersFeedModel, at: feedModels.count / 2)
            }
            sectionModels.append(CZSectionModel(feedModels: feedModels))
            
            return sectionModels
        }
    }
}

extension FeedListViewModel: CopyableState {
    func react(to event: Event) {
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        // TODO: (cheng) Should return deep copy
        return self
    }
}

