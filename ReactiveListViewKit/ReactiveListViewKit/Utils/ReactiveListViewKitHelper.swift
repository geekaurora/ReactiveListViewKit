//
//  ReactiveListViewKitHelper.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 11/6/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit

public func dbgPrint(_ item: String) {
    guard ReactiveListViewKit.isDebugMode else { return }
    print(item)
}

