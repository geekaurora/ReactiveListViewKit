//
//  CZTextFeedCellView.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 2/7/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit

/// Convenience text based CellView class
open class CZTextFeedListCell: UICollectionViewCell, CZFeedCellViewSizeCalculatable {
    open var onEvent: OnEvent? {
        didSet {
            cellView?.onEvent = onEvent
        }
    }
    open var viewModel: CZFeedViewModelable?
    open var cellView: CZTextFeedCellView?
    open var diffId: String {
        return viewModel?.diffId ?? ""
    }

    public required init(viewModel: CZFeedViewModelable?, onEvent: OnEvent?) {
        self.viewModel = viewModel
        self.onEvent = onEvent
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        config(with: viewModel)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public func config(with viewModel: CZFeedViewModelable?) {
        if let viewModel = viewModel as? CZTextFeedViewModel {
            if cellView == nil {
                cellView = CZTextFeedCellView(viewModel: viewModel, onEvent: onEvent)
                cellView?.overlayOnSuperview(self)
            }
            cellView!.config(with: viewModel)
        }
    }

    public class func sizeThatFits(_ size: CGSize, viewModel: CZFeedViewModelable) -> CGSize {
        return CZTextFeedCellView.sizeThatFits(size, viewModel: viewModel)
    }
}

public class CZTextFeedCellView: UIView, CZFeedCellViewSizeCalculatable {
    public var onEvent: OnEvent?

    fileprivate var titleLabel: UILabel!

    fileprivate lazy var hasSetup: Bool = false
    public var viewModel: CZFeedViewModelable?
    public var diffId: String {
        return viewModel?.diffId ?? ""
    }

    public required init(viewModel: CZFeedViewModelable?, onEvent: OnEvent?) {
        self.viewModel = viewModel
        self.onEvent = onEvent
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        config(with: viewModel)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public func setup() {
        guard !hasSetup else {return}
        hasSetup = true
        titleLabel = UILabel(frame: .zero)
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.overlayOnSuperview(self, inset: UIEdgeInsets(top: 5,
                                                                left: 10,
                                                                bottom: 5,
                                                                right: 10))
    }
    
    public func config(with viewModel: CZFeedViewModelable?) {
        setup()
        if let viewModel = viewModel as? CZTextFeedViewModel {
            titleLabel.text = viewModel.text
        }
    }

    public class func sizeThatFits(_ containerSize: CGSize, viewModel: CZFeedViewModelable) -> CGSize {
        guard let viewModel = viewModel as? CZTextFeedViewModel else { preconditionFailure() }
        return CZFacadeViewHelper.sizeThatFits(containerSize,
                                               viewModel: viewModel,
                                               viewClass: CZTextFeedCellView.self,
                                               isHorizontal: viewModel.isHorizontal)
    }
}


