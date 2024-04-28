//
//  CZHorizontalSectionAdapterViewModel.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 1/16/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit

/**
 ViewModel class of `CZHorizontalSectionAdapterView`
 */
public class CZHorizontalSectionAdapterViewModel: NSObject, CZFeedViewModelable, StateProtocol {
  public lazy var diffId: String = self.currentClassName
  private(set) var feedModels: [CZFeedModel]
  private(set) var headerModel: CZFeedModel?
  private(set) var footerModel: CZFeedModel?
  private(set) var viewHeight: CGFloat
  private(set) var backgroundColor: UIColor
  private(set) var showTopDivider: Bool
  private(set) var showBottomDivider: Bool
  private(set) var isUserInteractionEnabled: Bool
  
  public required init(_ feedModels: [CZFeedModel],
                       headerModel: CZFeedModel? = nil,
                       footerModel: CZFeedModel? = nil,
                       backgroundColor: UIColor = ReactiveListViewKit.horizontalSectionAdapterViewBGColor,
                       viewHeight: CGFloat,
                       showTopDivider: Bool = false,
                       showBottomDivider: Bool = false,
                       isUserInteractionEnabled: Bool = false) {
    self.feedModels = feedModels
    self.headerModel = headerModel
    self.footerModel = footerModel
    self.backgroundColor = backgroundColor
    self.viewHeight = viewHeight
    self.showTopDivider = showTopDivider
    self.showBottomDivider = showBottomDivider
    self.isUserInteractionEnabled = isUserInteractionEnabled
    super.init()
    self.diffId = currentClassName
  }
  
  public func isEqual(toDiffableObj object: AnyObject) -> Bool {
    guard let object = object as? CZHorizontalSectionAdapterViewModel else {return false}
    return feedModels.isEqual(toDiffableObj: object.feedModels) &&
    CZListDiffableHelper.isEqual(headerModel, object.headerModel) &&
    CZListDiffableHelper.isEqual(footerModel, object.footerModel) &&
    viewHeight == object.viewHeight
  }
  
  public func copy(with zone: NSZone?) -> Any {
    let feedModelsCopy = feedModels.copy() as! [CZFeedModel]
    return CZHorizontalSectionAdapterViewModel(feedModelsCopy, viewHeight: viewHeight)
  }
  public func reduce(action: Action) -> Self {
    return self
  }
}
