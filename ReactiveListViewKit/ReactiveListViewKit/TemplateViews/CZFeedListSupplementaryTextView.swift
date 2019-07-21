//
//  CZFeedListSupplementaryTextView.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 2/7/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit

/// Text based SupplementaryView for SectionHeaderView/SectionFooterView
open class CZFeedListSupplementaryTextFeedModel: CZFeedModel {
    public init(title: String,
                actionButtonText: String? = nil,
                actionButtonClosure: CZFeedListSupplementaryTextView.ActionButtonClosure? = nil,
                inset: UIEdgeInsets = ReactiveListViewKit.FeedListSupplementaryTextView.inset,
                showTopDivider: Bool = false,
                showBottomDivider: Bool = false) {
        super.init(viewClass: CZFeedListSupplementaryTextView.self,
                   viewModel: CZFeedListSupplementaryTextViewModel(title:title,
                                                                   actionButtonText: actionButtonText,
                                                                   actionButtonClosure: actionButtonClosure,
                                                                   inset: inset,
                                                                   showTopDivider: showTopDivider,
                                                                   showBottomDivider: showBottomDivider))
    }
    required public init(viewClass: CZFeedCellViewSizeCalculatable.Type, viewModel: CZFeedViewModelable) {
        super.init(viewClass: viewClass, viewModel: viewModel)
    }
}

open class CZFeedListSupplementaryTextViewModel: NSObject, CZFeedViewModelable {
    let title: String
    let actionButtonText: String?
    let actionButtonClosure: CZFeedListSupplementaryTextView.ActionButtonClosure?
    let isHorizontal: Bool
    let showTopDivider: Bool
    let showBottomDivider: Bool
    lazy public var diffId: String = self.currentClassName
    let inset: UIEdgeInsets

    required public init(title: String,
                         actionButtonText: String? = nil,
                         actionButtonClosure: CZFeedListSupplementaryTextView.ActionButtonClosure? = nil,
                         inset: UIEdgeInsets = ReactiveListViewKit.FeedListSupplementaryTextView.inset,
                         isHorizontal: Bool = false,
                         showTopDivider: Bool = false,
                         showBottomDivider: Bool = false) {
        self.title = title
        self.actionButtonText = actionButtonText
        self.actionButtonClosure = actionButtonClosure
        self.inset = inset
        self.isHorizontal = isHorizontal
        self.showTopDivider = showTopDivider
        self.showBottomDivider = showBottomDivider
        
        super.init()
        diffId = currentClassName + title
    }
    
    public func isEqual(toDiffableObj object: AnyObject) -> Bool {
        guard let object = object as? CZFeedListSupplementaryTextViewModel else {return false}
        return diffId == object.diffId &&
            title == object.title
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let titleCopy = title
        let copy = type(of: self).init(title: titleCopy,
                                       inset: inset,
                                       isHorizontal: isHorizontal)
        return copy
    }
}

open class CZFeedListSupplementaryTextView: UIView, CZFeedCellViewSizeCalculatable {
    public typealias ActionButtonClosure = (UIButton) -> Void
    public var onAction: OnAction?
    private var titleLabel: UILabel!
    private lazy var actionButton: UIButton = UIButton(frame: .zero)
    private let topDivider = CZDividerView()
    private let bottomDivider = CZDividerView()
    private var stackContainerView: UIStackView!
    private var contentContainerView: UIView!
    
    private lazy var hasSetup: Bool = false
    public var viewModel: CZFeedListSupplementaryTextViewModel?
    public var diffId: String {
        return viewModel?.diffId ?? ""
    }
    
    public required init(viewModel: CZFeedViewModelable?, onAction: OnAction?) {
        self.viewModel = viewModel as? CZFeedListSupplementaryTextViewModel
        self.onAction = onAction
        super.init(frame: .zero)
        config(with: viewModel)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("Must call designated initializer.")
    }
    
    public func setupViews() {
        guard let viewModel = viewModel, !hasSetup else {return}
        hasSetup = true
        translatesAutoresizingMaskIntoConstraints = false
        
        // contentContainerView
        contentContainerView = UIView(frame: .zero)
        contentContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        // stackContainerView
        stackContainerView = UIStackView()
        stackContainerView.axis = .vertical
        stackContainerView.distribution = .fill
        stackContainerView.alignment = .fill
        stackContainerView.overlayOnSuperview(self)
        
        // Append subviews to stackContainerView
        [topDivider, contentContainerView, bottomDivider].forEach{ stackContainerView.addArrangedSubview($0) }
        topDivider.isHidden = true
        bottomDivider.isHidden = true
        
        // TitleLabel
        titleLabel = UILabel(frame: .zero)
        titleLabel.font = ReactiveListViewKit.FeedListSupplementaryTextView.titleFont
        titleLabel.textColor = ReactiveListViewKit.FeedListSupplementaryTextView.titleColor
        contentContainerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant:  viewModel.inset.left),
            titleLabel.topAnchor.constraint(equalTo: contentContainerView.topAnchor, constant:  viewModel.inset.top),
            titleLabel.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor, constant:  viewModel.inset.bottom)
            ])
        
        // ActionButton
        contentContainerView.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            actionButton.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant:  -viewModel.inset.right),
            actionButton.topAnchor.constraint(equalTo: contentContainerView.topAnchor, constant:  viewModel.inset.top),
            actionButton.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor, constant:  viewModel.inset.bottom)
            ])
        actionButton.addHandler(for: .touchUpInside) {[weak self] (button) in
            guard let `self` = self else {return}
            self.viewModel?.actionButtonClosure?(self.actionButton)
        }
    }
    
    public func config(with viewModel: CZFeedViewModelable?) {
        setupViews()
        if let viewModel = viewModel as? CZFeedListSupplementaryTextViewModel {
            titleLabel.text = viewModel.title
            topDivider.isHidden = !viewModel.showTopDivider
            bottomDivider.isHidden = !viewModel.showBottomDivider
            
            if let actionButtonText = viewModel.actionButtonText {
                let attributedTitle  = NSAttributedString(string: actionButtonText,
                                                          attributes: [NSAttributedString.Key.font: ReactiveListViewKit.FeedListSupplementaryTextView.titleFont,
                                                                       NSAttributedString.Key.foregroundColor: ReactiveListViewKit.FeedListSupplementaryTextView.actionButtonColor
                    ])
                actionButton.setAttributedTitle(attributedTitle, for: .normal)
            }
        }
    }
    
    public static func sizeThatFits(_ containerSize: CGSize, viewModel: CZFeedViewModelable) -> CGSize {
        return CZFacadeViewHelper.sizeThatFits(containerSize,
                                               viewModel: viewModel,
                                               viewClass: CZFeedListSupplementaryTextView.self,
                                               isHorizontal: false)
    }
    
}
