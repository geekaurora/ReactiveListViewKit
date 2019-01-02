//
//  CZMocker.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 1/12/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import CZUtils
import ReactiveListViewKit

class CZMocker: NSObject {
    static let shared = CZMocker()

    var feeds: [Feed] {
        let url = Bundle.main.url(forResource: "feeds", withExtension: "json")!
        return CodableHelper.decode(url) ?? []
    }
    
    var hotUsers: [User] {
        let url = Bundle.main.url(forResource: "users", withExtension: "json")!
        return CodableHelper.decode(url) ?? []
    }
}
