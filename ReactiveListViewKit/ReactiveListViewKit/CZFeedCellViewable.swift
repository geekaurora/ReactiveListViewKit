//
//  CZFeedCellViewable.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 1/3/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit

/// Fundamental protocol of actionable Component
public protocol CZActionable: class {
    var onAction: OnAction? {get set}
}

/// Fundamental CellView protocol, compatible with UICollectionViewCell/View/ViewController
///
/// - In CZFeedListFacadeView
///     - if CZFeedCellViewable is `UICollectionViewCell`, it will be dequeued to reuse. Recommended if there're more than one type of Cell involved in ListView
///     - if CZFeedCellViewable is `UIView`, it will be automatically overlayed on embeded Cell. Recommended if there's only one type of Cell involved in ListView
///     - if CZFeedCellViewable is `UIViewController`, its `didMove(to:)` parentViewController method will be invoked and its `view` will be automatically overlayed on embeded Cell
///
/// - In CZFeedDetailsFacadeView
///     - if CZFeedCellViewable is `UIView`, it will be appended to underlying UIStackView
///     - if CZFeedCellViewable is `UIViewController`, its `didMove(to:)` parentViewController method will be invoked and its `view` will be automatically appended to UIStackView
///
public protocol CZFeedCellViewable: NSObjectProtocol, CZActionable {
    // diffId is used to match view and ViewModel if corresponding ViewModel changes
    var diffId: String {get}
    // Action hanlder closure
    var onAction: OnAction? {get set}

    /// Initializer of FeedCellView
    ///
    /// - Parameters:
    ///   - viewModel: ViewModel of FeedCellView
    ///   - onAction: Action handler for events of cellView, cellView can propagate customEvent
    ///              e.g. `OptionSelect`, like/comment/share
    init(viewModel: CZFeedViewModelable?, onAction: OnAction?)
    func config(with viewModel: CZFeedViewModelable?)
    func config(with viewModel: CZFeedViewModelable?, prevViewModel: CZFeedViewModelable?)
}

extension CZFeedCellViewable {
    public func config(with viewModel: CZFeedViewModelable?, prevViewModel: CZFeedViewModelable?) {
        assertionFailure("\(type(of: self))::\(#function) should be implemented.")
    }
}

/// CellView protocol that returns cellSize based on input params, required for CellClass in `CZFeedListFacadeView`
public protocol CZFeedCellViewSizeCalculatable: CZFeedCellViewable {
    static func sizeThatFits(_ containerSize: CGSize, viewModel: CZFeedViewModelable) -> CGSize
}






