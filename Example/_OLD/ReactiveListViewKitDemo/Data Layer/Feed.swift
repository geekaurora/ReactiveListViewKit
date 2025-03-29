//
//  Feed.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 1/3/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import CZUtils
import ReactiveListViewKit

/// Model of feed.
class Feed: ReactiveListDiffable {
  let feedId: String
  let content: String?
  let imageInfo: ImageInfo?
  let user: User?
  var userHasLiked: Bool
  var likesCount: Int
  
  // MARK: - NSCopying

  func copy(with zone: NSZone? = nil) -> Any {
    return codableCopy(with: zone)
  }
  
  // MARK: - Decodable

  required init(from decoder: Decoder) throws {
    /** Direct decode. */
    let values = try decoder.container(keyedBy: CodingKeys.self)
    feedId = (try values.decodeIfPresent(String.self, forKey: .feedId)).assertIfNil ?? ""
    userHasLiked = (try values.decodeIfPresent(Bool.self, forKey: .userHasLiked)).assertIfNil ?? false
    user = try values.decodeIfPresent(User.self, forKey: .user)
    
    /** Nested decode. */
    // e.g. content = dict["caption"]["content"]
    let caption = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .caption)
    content = try caption.decodeIfPresent(String.self, forKey: .content)
    
    let likes = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .likes)
    likesCount = (try likes.decodeIfPresent(Int.self, forKey: .likesCount)) ?? 0

    let images = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .images)
    imageInfo = try images.decodeIfPresent(ImageInfo.self, forKey: .imageInfo)
  }
}

// MARK: - State

extension Feed: StateProtocol {
  func reduce(action: CZActionProtocol) -> Self {
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
    return self
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
    /** Direct encode. */
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(feedId, forKey: .feedId)
    try container.encodeIfPresent(userHasLiked, forKey: .userHasLiked)
    try container.encodeIfPresent(user, forKey: .user)
    
    /** Nested encode. */
    var caption = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .caption)
    try caption.encodeIfPresent(content, forKey: .content)
    
    var likes = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .likes)
    try likes.encodeIfPresent(likesCount, forKey: .likesCount)
    
    var images = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .images)
    try images.encodeIfPresent(imageInfo, forKey: .imageInfo)
  }
}
