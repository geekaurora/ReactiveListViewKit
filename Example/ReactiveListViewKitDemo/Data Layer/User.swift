//
//  User.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 1/3/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import CZUtils
import ReactiveListViewKit
import EasyMapping

/// Model of user
@objc class User: CZModel {
    var userId: String?
    var userName: String?
    var fullName: String?
    var portraitUrl: String?
    var bio: String?
    var website: String?

    var feedCount: Int? {return _feedCount?.intValue}
    var followsCount: Int? {return _followsCount?.intValue}
    var followedByCount: Int? {return _followedByCount?.intValue}
    var _feedCount: NSNumber?
    var _followsCount: NSNumber?
    var _followedByCount: NSNumber?

    override init() { super.init() }
    required init(dictionary: CZDictionary) {
        super.init(dictionary: dictionary)
    }

    override class func objectMapping() -> EKObjectMapping {
        let allMapping = super.objectMapping()
        let mapping = EKObjectMapping(objectClass: self)
        mapping.mapProperties(from: ["id": "userId",
                                     "username": "userName",
                                     "full_name": "fullName",
                                     "profile_picture": "portraitUrl",
                                     "bio": "bio",
                                     "counts.media": "_feedCount",
                                     "counts.follows": "_followsCount",
                                     "counts.followed_by": "_followedByCount",
            ])
        allMapping.mapProperties(fromMappingObject: mapping)
        return allMapping
    }
}


