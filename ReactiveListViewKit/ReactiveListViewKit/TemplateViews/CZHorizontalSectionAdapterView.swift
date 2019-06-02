//
//  CZHorizontalSectionAdapterView.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 1/16/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit

/// Convenience class to implement horizontal list view
open class CZHorizontalSectionAdapterView: UIView, CZFeedCellViewSizeCalculatable {
    private var viewModel: CZHorizontalSectionAdapterViewModel?
    open var diffId: String {return viewModel?.diffId ?? ""}
    open var onEvent: OnEvent?
    private var containerStackView: UIStackView!
    private var nestedFeedListView: CZFeedListFacadeView!
    private var headerView: UIView?
    private var footerView: UIView?
    private let topDivider = CZDividerView()
    private let bottomDivider = CZDividerView()
    private var listViewIndex: Int {
        return containerStackView.arrangedSubviews.index(of: nestedFeedListView)!
    }

    public required init(viewModel: CZFeedViewModelable? = nil, onEvent: OnEvent?) {
        self.viewModel = viewModel as? CZHorizontalSectionAdapterViewModel
        self.onEvent = onEvent
        super.init(frame: .zero)
        setup()
        config(with: viewModel)
    }
    
    public required init?(coder aDecoder: NSCoder) { fatalError("Must call designated initializer `init(viewModel:onEvent:)`") }
    
    public func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        containerStackView = UIStackView()
        containerStackView.axis = .vertical
        containerStackView.alignment = .fill
        containerStackView.distribution = .fill
        containerStackView.overlayOnSuperview(self)
            
        nestedFeedListView = CZFeedListFacadeView(sectionModelsTransformer: nil,
                                                  onEvent: onEvent,
                                                  isHorizontal: true)
        
        [topDivider, nestedFeedListView, bottomDivider].forEach { containerStackView.addArrangedSubview($0) }
        topDivider.isHidden = true
        bottomDivider.isHidden = true
    }
    
    public func config(with viewModel: CZFeedViewModelable?) {
        guard let viewModel = viewModel as? CZHorizontalSectionAdapterViewModel else {
            return
        }        
        backgroundColor = viewModel.backgroundColor
        topDivider.isHidden = !viewModel.showTopDivider
        bottomDivider.isHidden = !viewModel.showBottomDivider

        isUserInteractionEnabled = true
        nestedFeedListView.isUserInteractionEnabled = true

        // Reset header/footer view
        headerView?.removeFromSuperview()
        headerView = nil
        footerView?.removeFromSuperview()
        footerView = nil
        
        // Header view
        if let headerModel = viewModel.headerModel {
            if headerView == nil {
                headerView = headerModel.buildView(onEvent: onEvent)
                containerStackView.insertArrangedSubview(headerView!, at: listViewIndex)
            } else {
                (headerView as! CZFeedCellViewable).config(with: headerModel.viewModel)
            }
        }
        
        // Footer view
        if let footerModel = viewModel.footerModel {
            if footerView == nil {
                footerView = footerModel.buildView(onEvent: onEvent)
                containerStackView.insertArrangedSubview(headerView!, at: listViewIndex + 1)
            } else {
                (footerView as! CZFeedCellViewable).config(with: footerModel.viewModel)
            }
        }

        // Horizontal listView
        nestedFeedListView.batchUpdate(withFeedModels: viewModel.feedModels)
    }
    
    public func config(with viewModel: CZFeedViewModelable?, prevViewModel: CZFeedViewModelable?) {}
    
    public static func sizeThatFits(_ containerSize: CGSize, viewModel: CZFeedViewModelable) -> CGSize {
        guard let viewModel = viewModel as? CZHorizontalSectionAdapterViewModel else {
            fatalError("Invalid ViewModel type.")
        }
        return CGSize(width: containerSize.width, height: viewModel.viewHeight)
    }
}
