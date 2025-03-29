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

/**
 State/ViewModel of `FeedListViewController`, composed of elements needed for UI populating
 */
class FeedListViewModel: NSObject, CopyableStateProtocol {
  /// List of feeds
  private(set) lazy var feeds: [Feed] = {
    return CZMocker.shared.feeds
  }()
  /// List of users with Story
  private(set) var storyUsers: [User] = {
    return CZMocker.shared.hotUsers
  }()
  /// List of suggested users
  private(set) var suggestedUsers: [User] = {
    return CZMocker.shared.hotUsers
  }()
  /// Current page number
  private(set) var page: Int = 0
  /// Indicates whether is loading feeds
  private(set) var isLoadingFeeds: Bool = false
  /// Last minimum FeedId, used as baseId for feeds request
  private(set) var lastMinFeedId: String = "-1"
  /// `Store` of FLUX, composed of `Dispatcher` and `Store`
  var store: Store<FeedListState>?
  /// SectionModelsTransformer closure -  mapping feeds to sectionModels
  var sectionModelsTransformer: CZFeedListFacadeView.SectionModelsTransformer!

  override init() {
    super.init()

    /// SectionModelsTransformer closure -  mapping feeds to sectionModels
    sectionModelsTransformer = { (feeds: [Any]) -> [CZSectionModel] in
      guard let feeds = feeds as? [Feed] else { fatalError() }
      var sectionModels = [CZSectionModel]()

      // HotUsers section
      let hotUsersFeedModels = self.storyUsers.compactMap {
        CZFeedModel(viewClass: HotUserCellView.self,
                    viewModel: HotUserCellViewModel($0)) }

      let hotUsersSectionModel = CZSectionModel(
        isHorizontal: true,
        heightForHorizontal: HotUserSection.heightForHorizontal,
        feedModels: hotUsersFeedModels,
        headerModel: CZFeedListSupplementaryTextFeedModel(
          title: "Stories",
          inset: UIEdgeInsets(top: 8,
                              left: 10,
                              bottom: 1,
                              right: 10)),
        footerModel: CZFeedListSupplementaryLineFeedModel(),
        sectionInset: UIEdgeInsets(
          top: 0,
          left: 3,
          bottom: 0,
          right: 5))

      sectionModels.append(hotUsersSectionModel)

      // Feeds section
      var feedModels = feeds.compactMap {
        CZFeedModel(viewClass: FeedCellView.self,
                    viewModel: FeedCellViewModel($0)) }

      // SuggestedUsers - CellViewController
      if feedModels.count > 0 {
        let suggestedUsers = self.suggestedUsers
        let suggestedUsersFeedModel = CZFeedModel(
          viewClass: HotUsersCellViewController.self,
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

extension FeedListViewModel: StateProtocol {
  /// Reacts to action.
  func reduce(action: CZActionProtocol) -> Self {
    self.feeds = feeds.map { $0.reduce(action: action) }
    return self
  }
}
