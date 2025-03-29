//
//  CZFeedModel.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 1/5/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit

/// Fundamental protocol defines common behavior of `FeedModel`
public protocol CZFeedModelable: class, NSObjectProtocol, CZListDiffable, NSCopying {
  var isHorizontal: Bool { get set }
  var viewModel: CZFeedViewModelable { get }
  func isEqual(toDiffableObj object: AnyObject) -> Bool
  func copy(with zone: NSZone?) -> Any
}

/// Base building block for `CZFeedListFacadeView`, highly decouples View/ViewModel layers
///
/// Composed of:
/// - viewClass: CZFeedCellViewSizeCalculatable
/// - viewModel: CZFeedViewModelable
///
open class CZFeedModel: NSObject, CZFeedModelable {
  public var isHorizontal: Bool
  let viewClass: CZFeedCellViewSizeCalculatable.Type
  public let viewModel: CZFeedViewModelable
  
  public required init(isHorizontal: Bool = false,
                       viewClass: CZFeedCellViewSizeCalculatable.Type,
                       viewModel: CZFeedViewModelable) {
    self.isHorizontal = isHorizontal
    self.viewClass = viewClass
    self.viewModel = viewModel
    super.init()
  }
  
  public func isEqual(toDiffableObj object: AnyObject) -> Bool {
    guard let object = object as? CZFeedModel else {
      return false
    }
    return viewClass == object.viewClass &&
    isHorizontal == object.isHorizontal &&
    viewModel.isEqual(toDiffableObj: object.viewModel)
  }
  
  public func copy(with zone: NSZone? = nil) -> Any {
    return self
//    let viewClassCopy = viewClass
//    let viewModelCopy = viewModel.copy(with: zone) as! CZFeedViewModelable
//    return type(of: self).init(isHorizontal: isHorizontal,
//                               viewClass: viewClassCopy,
//                               viewModel: viewModelCopy)
  }
  
  public func buildView(onAction: OnAction?) -> UIView {
    let cellComponent = viewClass.init(viewModel: viewModel, onAction: onAction)
    let cellView: UIView
    switch cellComponent {
    case let cellComponent as UICollectionViewCell:
      cellView = cellComponent.contentView
    case let cellComponent as UIView:
      cellView = cellComponent
    case let cellComponent as UIViewController:
      cellView = cellComponent.view
    default:
      fatalError("\(viewClass) isn't expected type!")
      break
    }
    return cellView
  }
}
