//
//  CZFeedViewModelable.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 1/5/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit

/// Protocol for CellView of CZFeedListView/CZFeedDetailsView
public protocol CZFeedViewModelable: class, NSObjectProtocol, CZListDiffable, NSCopying {
    /// diffId is used for diff algorithm of incremental update, compare whether two involved viewModels equal
    var diffId: String {get}
    func isEqual(toDiffableObj object: AnyObject) -> Bool
    func copy(with zone: NSZone?) -> Any
}

extension CZFeedViewModelable {
    public var diffId: String {
        return NSStringFromClass(type(of: self))
    }
}

public extension CZFeedViewModelable {    
    public var currentClassName: String {
        return NSStringFromClass(type(of: self))
    }
}

/// - Note:
///   - When compare properties, should invoke `isEqual(toDiffableObj: :)` or `isEqual(to:)` in OC, instead of `isEqualTo` which compares hashvalue
public protocol CZListDiffable {
    /// Workaround of `Equatable`, because `Equatable` function uses associatedType `Self` as type, which makes `Equatable` SubProtocol can only be used as generic constraint
    func isEqual(toDiffableObj object: AnyObject) -> Bool
}

public typealias CZListDiffableObject = CZListDiffable & AnyObject
