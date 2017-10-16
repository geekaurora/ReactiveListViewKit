//
//  CZFeedCellViewable.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 1/3/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit

public protocol CZEventable: class {
    var onEvent: OnEvent? {get set}
}

/// Basic CellView protocol, compatible with both View/ViewController. e.g. FeedDetailsCellViewController
///
/// - NOTE: CZFeedCellViewable is flexible to be Cell/UIView/UIViewController
///        - In CZFeedListFacadeView:
///           - if CZFeedCellViewable is Cell, it will be dequeued to reuse. Recommended if there're more than one type of Cell involved for reusable performance.
///           - if CZFeedCellViewable is UIView, it will be automatically added/overlapped to embeded Cell. Recommended if there's only one type of Cell involved.
///           - if CZFeedCellViewable is UIViewController, its `didMove(to:)` parentViewController method will be invoked and its `view` will be automatically added/overlapped to embeded Cell
///
///        - In CZFeedDetailsFacadeView:
///           - if CZFeedCellViewable is UIView, it will be appended to underlying UIStackView
///           - if CZFeedCellViewable is UIViewController, its view will be ppended to underlying UIStackView, and itself will be moved(toParentVC:) with containerViewController
///
public protocol CZFeedCellViewable: class, NSObjectProtocol, CZEventable {
    // diffId is used to match view and ViewModel if corresponding ViewModel differs
    var diffId: String {get}
    // Event hanlder 
    var onEvent: OnEvent? {get set}

    /// Initializer of FeedCellView
    ///
    /// - Parameters:
    ///   - viewModel: ViewModel of FeedCellView
    ///   - onEvent: Event handler for events of cellView, cellView can propagate custom event via this hanlder. e.g. OptionSelect, like/share button
    init(viewModel: CZFeedViewModelable?, onEvent: OnEvent?)

    func config(with viewModel: CZFeedViewModelable?)

    /// prevViewModel is used for diff Algo
    func config(with viewModel: CZFeedViewModelable?, prevViewModel: CZFeedViewModelable?)
}

extension CZFeedCellViewable {
    public func config(with viewModel: CZFeedViewModelable?, prevViewModel: CZFeedViewModelable?) {
        assertionFailure("\(type(of: self))::\(#function) should be implemented.")
    }
}

/// CellView protocol which returns cellSize based on input params. P.S. Required by UICollection, not UIStackView. e.g. FeedListCellView
public protocol CZFeedCellViewSizeCalculatable: CZFeedCellViewable {
    static func sizeThatFits(_ containerSize: CGSize, viewModel: CZFeedViewModelable) -> CGSize
}



