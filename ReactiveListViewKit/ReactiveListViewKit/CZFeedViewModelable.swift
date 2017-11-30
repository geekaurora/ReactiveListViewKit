//
//  CZFeedViewModelable.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 1/5/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit

/// Fundamental protocol for CellView of `CZFeedListFacadeView`/`CZFeedDetailsFacadeView`
public protocol CZFeedViewModelable: class, NSObjectProtocol, CZListDiffable, NSCopying {
    /// `diffId` is used for diff algorithm of batch update, verify whether two involved viewModels equal
    var diffId: String {get}
    func isEqual(toDiffableObj object: AnyObject) -> Bool
    func copy(with zone: NSZone?) -> Any
}

extension CZFeedViewModelable {
    public var diffId: String {
        return currentClassName
    }
}

public extension CZFeedViewModelable {    
    public var currentClassName: String {
        return NSStringFromClass(type(of: self))
    }
}

/// Fundamental protocol for ViewModel involved in ListView, verify whether two viewModels equal
public protocol CZListDiffable {
    /// Workaround of `Equatable`, because `Equatable` uses associatedType `Self`, which makes `Equatable` can only be used as generic constraint
    func isEqual(toDiffableObj object: AnyObject) -> Bool
}

public typealias CZListDiffableObject = CZListDiffable & AnyObject
