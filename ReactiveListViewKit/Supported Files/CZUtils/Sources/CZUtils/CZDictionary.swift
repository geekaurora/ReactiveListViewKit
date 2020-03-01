//
//  CZDictionary.swift
//  CZUtils
//
//  Created by Cheng Zhang on 2018/7/6.
//  Copyright © 2019 Cheng Zhang. All rights reserved.
//

import Foundation

public typealias CZDictionary = [AnyHashable : Any]

public protocol CZDictionaryable {
    init(dictionary: CZDictionary)
}

