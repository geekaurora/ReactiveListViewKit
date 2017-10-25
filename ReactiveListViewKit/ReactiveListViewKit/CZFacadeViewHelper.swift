//
//  CZFacadeViewHelper.swift
//  CZInstagram
//
//  Created by Cheng Zhang on 1/3/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit

/// Convenience helper class for FacadeView
public class CZFacadeViewHelper: NSObject {
    /// Calculate cell size with input params, adaptive to `viewClass` as UIView/UIViewController/UICollectionViewCell
    public static func sizeThatFits(_ containerSize: CGSize,
                                    viewModel: CZFeedViewModelable,
                                    viewClass: CZFeedCellViewable.Type,
                                    isHorizontal: Bool = false) -> CGSize {
        let tmpComponent = viewClass.init(viewModel: viewModel, onEvent: nil)
        let tmpView: UIView
        switch tmpComponent {
        case let tmpComponent as UIView:
            // Component is UIView
            tmpView = tmpComponent
        case let tmpComponent as UIViewController:
            // Component is UIViewController
            tmpView = tmpComponent.view
        case let tmpComponent as UICollectionViewCell:
            // Component is UICollectionViewCell
            tmpView = tmpComponent.contentView
        default:
            assertionFailure("\(viewClass) should be subclass of UICollectionViewCell/UIView/UIViewController.")
            return .zero
        }        
        tmpView.translatesAutoresizingMaskIntoConstraints = false

        var containerSize = containerSize
        if isHorizontal {
            containerSize.width = 0
        } else {
            containerSize.height = 0
        }
        
        var calculatedSize = tmpView.systemLayoutSizeFitting(containerSize)
        if isHorizontal {
            calculatedSize.height = containerSize.height - 10
        } else {
            calculatedSize.width = containerSize.width
        }
        return calculatedSize
    }
}
