//
//  CZFeedListSupplementaryView.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 2/7/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit

/// Convenience class of SectionHeaderView/SectionFooterView
open class CZFeedListSupplementaryView: UICollectionReusableView {
    open override var reuseIdentifier: String? {
        return type(of: self).reuseId
    }
    private var model: CZFeedModel?
    private var contentView: CZFeedCellViewSizeCalculatable?
    public static var reuseId: String {
        return NSStringFromClass(object_getClass(self)!)
    }
    open func config(with model: CZFeedModel, onAction: OnAction?) {
        defer {
            self.model = model
            contentView?.config(with: model.viewModel)
        }
        // Reset contentView if contentViewClass differs from the current one
        if let contentView = contentView,
            let currModel = self.model,
            currModel.viewClass != model.viewClass {
            (contentView as? UIView)?.removeFromSuperview()
            self.contentView = nil
        }
        if contentView == nil {
            self.contentView = model.viewClass.init(viewModel: model.viewModel, onAction: onAction)
            guard let contentView = self.contentView as? UIView else {
                assertionFailure("\(model.viewClass) should be subClass of UIView!")
                return
            }
            contentView.translatesAutoresizingMaskIntoConstraints = false
            contentView.isUserInteractionEnabled = false
            addSubview(contentView)
            contentView.overlayOnSuperview()
        }
    }
}
