//
//  CZFeedListCell.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 1/5/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import CZUtils

/// Internal convenience UICollectionViewCell class wrapping CellView of `CZFeedModel`
internal class CZFeedListCell: UICollectionViewCell {
    fileprivate var model: CZFeedModel?
    // Adaptive to UIView or UIViewController
    fileprivate var cellComponent: CZFeedCellViewSizeCalculatable?

    open func config(with model: CZFeedModel, onEvent: OnEvent?, parentViewController: UIViewController? = nil) {
        defer {
            self.model = model
            cellComponent?.config(with: model.viewModel)
        }

        // Reset cellView if cellViewClass differs from the current one
        if let cellComponent = cellComponent,
            let currModel = self.model,
            currModel.viewClass != model.viewClass {
            switch cellComponent {
            case let cellComponent as UIView:
                cellComponent.removeFromSuperview()
            case let cellComponent as UIViewController:
                cellComponent.didMove(toParentViewController: nil)
                cellComponent.view.removeFromSuperview()
            default:
                break
            }
            self.cellComponent = nil
        }
        
        if let cellComponent = self.cellComponent {
            cellComponent.config(with: model.viewModel)
        } else {
            self.cellComponent = model.viewClass.init(viewModel: model.viewModel, onEvent: onEvent)
            let cellView: UIView
            switch cellComponent {
            case let cellComponent as UIView:
                cellView = cellComponent
            case let cellComponent as UIViewController:
                cellView = cellComponent.view
                if let parentViewController = parentViewController {
                    cellComponent.didMove(toParentViewController: parentViewController)
                } else {
                    assertionFailure("`parentViewController` should be set in `CZFeedDetailsFacadeView` initializer if cellComponent is `UIViewController`!")
                }
            default:
                fatalError("\(model.viewClass) should be subClass of UIView or UIViewController!")
                break
            }
            cellView.overlayOnSuperview(contentView)
            cellView.isUserInteractionEnabled = true
        }
    }
}

