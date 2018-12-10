//
//  HotUserCellViewModel.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 3/4/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit
import ReactiveListViewKit

class HotUserCellViewModel: NSObject, CZFeedViewModelable {
    var diffId: String {
        return currentClassName + (user.userId ?? "")
    }
    fileprivate(set) var user: User
    var userName: String? {return user.userName}
    var fullName: String? {return user.fullName}

    var portraitUrl: URL? {
        guard let urlStr = user.portraitUrl else {return nil}
        return URL(string: urlStr)
    }

    required init(_ user: User) {
        self.user = user
        super.init()
    }

    func isEqual(toDiffableObj object: AnyObject) -> Bool {
        guard let object = object as? HotUserCellViewModel else {return false}
        return user.isEqual(toDiffableObj: object.user)
    }

    func copy(with zone: NSZone?) -> Any {
        let userCopy = user.copy() as! User
        return HotUserCellViewModel(userCopy)
    }
}

extension HotUserCellViewModel: State {
    func react(to event: Event) {
        // no-op
    }
}
