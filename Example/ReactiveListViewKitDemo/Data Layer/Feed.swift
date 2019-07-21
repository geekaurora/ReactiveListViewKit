//
//  Feed.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 1/3/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import CZUtils
import ReactiveListViewKit

/// Model of feed
class Feed: ReactiveListDiffable {
    let feedId: String
    let content: String?
    let imageInfo: ImageInfo?
    let user: User?
    var userHasLiked: Bool
    var likesCount: Int

    // MARK: - CZListDiffable
    func isEqual(toDiffableObj object: AnyObject) -> Bool {
        return isEqual(toCodable: object)
    }
    
    // MARK: - NSCopying
    func copy(with zone: NSZone? = nil) -> Any {
        return codableCopy(with: zone)
    }
    
    // MARK: - Decodable
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        feedId = try values.decode(String.self, forKey: .feedId)
        userHasLiked = try values.decode(Bool.self, forKey: .userHasLiked)
        user = try values.decode(User.self, forKey: .user)
        
        let caption = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .caption)
        content = try caption.decode(String.self, forKey: .content)
        
        let likes = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .likes)
        likesCount = try likes.decode(Int.self, forKey: .likesCount)
        
        let images = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .images)
        imageInfo = try images.decode(ImageInfo.self, forKey: .imageInfo)
    }
}

// MARK: - State
extension Feed: State {
    func reduce(action: Action) {
        switch action {
        case let action as LikeFeedAction:
            // React to `LikeFeedEvent`: flip `userHasLiked` flag
            if  action.feed.feedId == feedId {
                userHasLiked = !userHasLiked
                likesCount += userHasLiked ? 1 : -1
            }
        default:
            break
        }
    }
}

// MARK: - Encodable
extension Feed {
    enum CodingKeys: String, CodingKey {
        case feedId = "id"
        case userHasLiked = "user_has_liked"
        case caption = "caption"
        case content = "text"
        case images = "images"
        case imageInfo = "standard_resolution"
        case likes = "likes"
        case likesCount = "count"
        case user
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(feedId, forKey: .feedId)
        try container.encode(userHasLiked, forKey: .userHasLiked)
        try container.encode(user, forKey: .user)
        
        var caption = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .caption)
        try caption.encode(content, forKey: .content)
        
        var likes = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .likes)
        try likes.encode(likesCount, forKey: .likesCount)
        
        var images = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .images)
        try images.encode(imageInfo, forKey: .imageInfo)
    }
}
