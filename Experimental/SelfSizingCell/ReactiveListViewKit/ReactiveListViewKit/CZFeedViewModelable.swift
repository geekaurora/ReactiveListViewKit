//
//  CZFeedViewModelable.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 1/5/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import CZUtils

/**
 Fundamental protocol for CellView of `CZFeedListFacadeView`/`CZFeedDetailsFacadeView`
 */
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
  var currentClassName: String {
    return NSStringFromClass(type(of: self))
  }
}

/// Fundamental protocol for ViewModel involved in ListView, verify whether two viewModels equal
public protocol CZListDiffable {
  /// Workaround of `Equatable`, because `Equatable` uses associatedType `Self`, which makes `Equatable` can only be used as generic constraint
  func isEqual(toDiffableObj object: AnyObject) -> Bool
}

/// Fundamental protocol composition of reactive listDiffable model
/// - note: The protocol only requires conformance of `Codable` and `NSCopying`, other protocols are conformed by categories automatically.
public typealias ReactiveListDiffable = Codable & NSCopying & CustomStringConvertible & CZListDiffable

public typealias CZListDiffableObject = CZListDiffable & AnyObject

// MARK: CZListDiffable
public extension Encodable where Self: Decodable {
  func isEqual(toDiffableObj object: AnyObject) -> Bool {
    return isEqual(toCodable: object)
  }
}
