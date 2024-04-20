//
//  CZFeedListSupplementaryLineView.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 2/7/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit

/**
 Line SupplementaryView for SectionHeaderView/SectionFooterView
 */
open class CZFeedListSupplementaryLineFeedModel: CZFeedModel {
  public init(inset: UIEdgeInsets = ReactiveListViewKit.feedListSupplementaryLineFooterViewInset) {
    super.init(
      viewClass: CZFeedListSupplementaryLineView.self,
      viewModel: CZFeedListSupplementaryLineViewModel(inset: inset))
  }
  public required init(viewClass: CZFeedCellViewSizeCalculatable.Type, 
                       viewModel: CZFeedViewModelable) {
    super.init(viewClass: viewClass, viewModel: viewModel)
  }
}

open class CZFeedListSupplementaryLineViewModel: NSObject, CZFeedViewModelable {
  public let isHorizontal: Bool
  public lazy var diffId: String = self.currentClassName
  public let inset: UIEdgeInsets
  
  public required init(inset: UIEdgeInsets, 
                       isHorizontal: Bool = false) {
    self.inset = inset
    self.isHorizontal = isHorizontal
    super.init()
    diffId = currentClassName
  }
  
  public  func isEqual(toDiffableObj object: AnyObject) -> Bool {
    guard let object = object as? CZFeedListSupplementaryLineViewModel else {return false}
    return diffId == object.diffId
  }
  
  public func copy(with zone: NSZone? = nil) -> Any {
    let copy = type(of: self).init(
      inset: inset,
      isHorizontal: isHorizontal)
    return copy
  }
}

open class CZFeedListSupplementaryLineView: UIView, CZFeedCellViewSizeCalculatable {
  public var onAction: OnAction?
  public var lineView: UIView!
  
  private lazy var hasSetup: Bool = false
  public var viewModel: CZFeedViewModelable?
  public var diffId: String {
    return viewModel?.diffId ?? ""
  }
  
  public required init(viewModel: CZFeedViewModelable?, 
                       onAction: OnAction?) {
    self.viewModel = viewModel
    self.onAction = onAction
    super.init(frame: .zero)
    setup()
    config(with: viewModel)
  }
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
  
  public func setup() {
    guard let viewModel = viewModel as? CZFeedListSupplementaryLineViewModel, !hasSetup else {return}
    hasSetup = true
    translatesAutoresizingMaskIntoConstraints = false
    
    lineView = CZDividerView()
    addSubview(lineView)
    NSLayoutConstraint.activate([
      lineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: viewModel.inset.left),
      lineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -viewModel.inset.right),
      lineView.topAnchor.constraint(equalTo: topAnchor, constant: viewModel.inset.top),
      lineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -viewModel.inset.bottom)
    ])
  }
  
  public func config(with viewModel: CZFeedViewModelable?) {
    setup()
  }
  
  public static func sizeThatFits(_ containerSize: CGSize, 
                                  viewModel: CZFeedViewModelable) -> CGSize {
    return CZFacadeViewHelper.sizeThatFits(
      containerSize,
      viewModel: viewModel,
      viewClass: CZFeedListSupplementaryLineView.self,
      isHorizontal: false)
  }
  
}
