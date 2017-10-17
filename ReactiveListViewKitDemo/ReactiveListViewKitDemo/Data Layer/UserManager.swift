//
//  UserManager.swift
//  CZInstagram
//
//  Created by Cheng Zhang on 1/3/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit
import CZUtils
import ReactiveListViewKit

/// currentUser (userId/access_token)
class UserManager: NSObject {
    static let shared = {
        return UserManager()
    }()
    
}
