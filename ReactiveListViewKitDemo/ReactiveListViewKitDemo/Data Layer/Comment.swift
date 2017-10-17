//
//  Comment
//  CZInstagram
//
//  Created by Cheng Zhang on 1/3/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import EasyMapping
import UIKit
import CZUtils
import ReactiveListViewKit

class Comment: CZModel {
    lazy var commentId: String = ""
    var user: User?
    var content: String?
    var createTime: String?     // “create_time”: “1279340983”

    override init() { super.init() }
    required init(dictionary: CZDictionary) {
        super.init(dictionary: dictionary)
        
    }

    override class func objectMapping() -> EKObjectMapping {
        let allMapping = super.objectMapping()
        let mapping = EKObjectMapping(objectClass: self)
        mapping.mapProperties(from: ["id": "commentId",
                                     "text": "content",
                                     "createTime": "createTime",
                                     ])
        mapping.hasOne(User.self, forKeyPath: "from", forProperty: "user")
        allMapping.mapProperties(fromMappingObject: mapping)
        return allMapping
    }
}

extension Comment: State {
    func react(to event: Event) {
    }

}
