//
//  FeedCellViewModel.swift
//  CZInstagram
//
//  Created by Cheng Zhang on 1/4/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit
import CZUtils
import ReactiveListViewKit

class FeedCellViewModel: NSObject, CZFeedViewModelable {
    var diffId: String {
        return currentClassName + feed.feedId
    }
    fileprivate(set) var feed: Feed
    var isInFeedDetails: Bool = false

    var userName: String? {return feed.user?.userName}
    var content: String? {return feed.content}

    var portraitUrl: URL? {
        guard let urlStr = feed.user?.portraitUrl else {return nil}
        return URL(string: urlStr)
    }
    var imageUrl: URL? {
        guard let urlStr = feed.imageInfo?.url else {return nil}
        return URL(string: urlStr)
    }
    var likesCount: Int {
        return feed.likesCount ?? 0
    }
    var userHasLiked: Bool {
        return feed.userHasLiked
    }

    required init(_ feed: Feed) {
        self.feed = feed
        super.init()
    }

    func isEqual(toDiffableObj object: AnyObject) -> Bool {
        guard let object = object as? FeedCellViewModel else {return false}
        return feed.isEqual(toDiffableObj: object.feed) &&
                isInFeedDetails == object.isInFeedDetails
    }

    func copy(with zone: NSZone?) -> Any {
        let feedCopy = feed.copy() as! Feed
        return FeedCellViewModel(feedCopy)
    }
}

extension FeedCellViewModel: State {
    func react(to event: Event) {

    }
}
