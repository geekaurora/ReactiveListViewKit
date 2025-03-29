///
//  CZFeedDetailsModel.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 1/5/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit

/// Base building block for `CZFeedDetailsFacadeView`, highly decouples View/ViewModel layers
///
/// Composed of:
/// - viewClass: CZFeedCellViewSizeCalculatable
/// - voewModel: CZFeedViewModelable
///
public typealias CZFeedDetailsModel = CZFeedModel

//public class CZFeedDetailsModel: NSObject, CZFeedModelable {
//  public let viewClass: CZFeedCellViewable.Type
//  public let  viewModel: CZFeedViewModelable
//
//  public required init(viewClass: CZFeedCellViewable.Type,
//                       viewModel: CZFeedViewModelable) {
//    self.viewClass = viewClass
//    self.viewModel = viewModel
//    super.init()
//  }
//
//  public func isEqual(toDiffableObj object: AnyObject) -> Bool {
//    guard let object = object as? CZFeedDetailsModel else {return false}
//    return viewClass == object.viewClass &&
//    viewModel.isEqual(toDiffableObj: object.viewModel)
//  }
//
//  public func copy(with zone: NSZone? = nil) -> Any {
//    let viewClassCopy = viewClass
//    let viewModelCopy = viewModel.copy(with: zone) as! CZFeedViewModelable
//    return type(of: self).init(
//      viewClass: viewClassCopy,
//      viewModel: viewModelCopy)
//  }
//}
