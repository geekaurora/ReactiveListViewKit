//
//  CZFeedListCell.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 1/5/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit
import CZUtils

/**
 Internal convenience `UICollectionViewCell` class wrapping input CellView
 */
internal class CZFeedListCell: UICollectionViewCell {
  private var model: CZFeedModel?
  // Adaptive to `UIView`/`UIViewController`
  private var cellComponent: CZFeedCellViewSizeCalculatable?
  private var isHorizontal: Bool {
    model?.isHorizontal ?? false
  }

  open func config(with model: CZFeedModel,
                   onAction: OnAction?,
                   parentViewController: UIViewController? = nil,
                   containerSize: CGSize = .zero) {
    defer {
      self.model = model
      cellComponent?.config(
        with: model.viewModel,
        containerSize: containerSize)
    }

    // Reset cellView if previous cellViewClass differs from the current one
    if let cellComponent = cellComponent,
       let currModel = self.model,
       currModel.viewClass != model.viewClass {
      switch cellComponent {
      case let cellComponent as UIView:
        cellComponent.removeFromSuperview()
      case let cellComponent as UIViewController:
        cellComponent.didMove(toParent: nil)
        cellComponent.view.removeFromSuperview()
      default:
        break
      }
      self.cellComponent = nil
    }

    if let cellComponent = self.cellComponent {
      cellComponent.config(with: model.viewModel, containerSize: containerSize)
    } else {
      self.cellComponent = model.viewClass.init(viewModel: model.viewModel, onAction: onAction)
      let cellView: UIView
      switch cellComponent {
      case let cellComponent as UIView:
        cellView = cellComponent
      case let cellComponent as UIViewController:
        cellView = cellComponent.view
        if let parentViewController = parentViewController {
          cellComponent.didMove(toParent: parentViewController)
        } else {
          assertionFailure("`parentViewController` should be set in `CZFeedDetailsFacadeView` initializer if cellComponent is `UIViewController`!")
        }
      default:
        fatalError("\(model.viewClass) should be subclass of UIView or UIViewController!")
        break
      }
      cellView.overlayOnSuperview(contentView)
      cellView.isUserInteractionEnabled = true
    }
  }

  // MARK: - Self sizing

  /// Returns the optimal size of the view based on its current constraints.
  ///
  /// - Note: `targetSize` is set from `collectionView(_ collectionView: layout:sizeForItemAt:)`.
  override func systemLayoutSizeFitting(_ targetSize: CGSize,
                                        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
                                        verticalFittingPriority: UILayoutPriority) -> CGSize {
    dbgPrintWithFunc(self, "isHorizontal = \(isHorizontal)")
    return super.systemLayoutSizeFitting(
      CGSize(
        width: targetSize.width,
        height: targetSize.height),
      withHorizontalFittingPriority: isHorizontal ? .fittingSizeLevel: .required,
      verticalFittingPriority: isHorizontal ? .required : .fittingSizeLevel)
  }
}
