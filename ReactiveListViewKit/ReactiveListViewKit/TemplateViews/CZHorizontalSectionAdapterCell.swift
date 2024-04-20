//
//  CZHorizontalSectionAdapterCell.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 1/29/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import CZUtils

public class CZHorizontalSectionAdapterCell: UICollectionViewCell, CZFeedCellViewSizeCalculatable {
  private var viewModel: CZHorizontalSectionAdapterViewModel?
  open var diffId: String { return viewModel?.diffId ?? "" }
  open var onAction: OnAction?
  private var horizontalSectionAdapterView: CZHorizontalSectionAdapterView!
  private var hasSetup: Bool = false
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViewsIfNeeded()
  }
  
  public required init(viewModel: CZFeedViewModelable? = nil, 
                       onAction: OnAction?) {
    self.viewModel = viewModel as? CZHorizontalSectionAdapterViewModel
    self.onAction = onAction
    super.init(frame: .zero)
    setupViewsIfNeeded()
    config(with: viewModel)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("Must call designated initializer `init(viewModel:onAction:)`")
  }
  
  public func setupViewsIfNeeded() {
    guard !hasSetup else {return}
    hasSetup = true
    // translatesAutoresizingMaskIntoConstraints = false
    horizontalSectionAdapterView = CZHorizontalSectionAdapterView(onAction: onAction)
    horizontalSectionAdapterView.overlayOnSuperview(contentView)
  }
  
  public func config(with viewModel: CZFeedViewModelable?) {
    setupViewsIfNeeded()
    guard let viewModel = viewModel as? CZHorizontalSectionAdapterViewModel else {
      return
    }
    isUserInteractionEnabled = true
    contentView.isUserInteractionEnabled = true
    horizontalSectionAdapterView.config(with: viewModel)
  }
  
  public static func sizeThatFits(_ containerSize: CGSize, 
                                  viewModel: CZFeedViewModelable) -> CGSize {
    return CZHorizontalSectionAdapterView.sizeThatFits(containerSize, viewModel: viewModel)
  }
  
  public func config(with viewModel: CZFeedViewModelable?, 
                     prevViewModel: CZFeedViewModelable?) {}

  // MARK: - Cell Size

  /// * Self-sizing: this method executes after `collectionView(_:cellForItemAt:indexPath)`.
  ///
  /// * targetSize: is from collectionView(_ collectionView: layout:sizeForItemAt:)
  public override func systemLayoutSizeFitting(_ targetSize: CGSize,
                                        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
                                        verticalFittingPriority: UILayoutPriority) -> CGSize {
    return super.systemLayoutSizeFitting(
      CGSize(
        width: UIView.layoutFittingExpandedSize.width,
        height: targetSize.height),
      withHorizontalFittingPriority: .fittingSizeLevel,
      verticalFittingPriority: .required)
  }
}
