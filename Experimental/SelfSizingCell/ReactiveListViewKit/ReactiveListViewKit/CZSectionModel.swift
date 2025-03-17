//
//  CZFeedModel.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 1/3/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit

/**
 ViewModel/State of Section, groups CellFeedModels inside section accordingly
 */
public class CZSectionModel: NSObject, NSCopying, CZListDiffable {
  private(set) var isHorizontal: Bool
  private(set) var heightForHorizontal: CGFloat
  
  private(set) var headerModel: CZFeedModel?
  private(set) var footerModel: CZFeedModel?
  private(set) var feedModels: [CZFeedModel]
  
  /// The minimum spacing to use between lines of items in the grid.
  private(set) var minimumLineSpacing: CGFloat?
  /// The minimum spacing to use between items in the same row.
  private(set) var minimumInteritemSpacing: CGFloat?
  private(set) var sectionInset: UIEdgeInsets?
  
  public var isEmpty: Bool {
    return feedModels.count == 0 &&
    headerModel == nil &&
    footerModel == nil
  }
  
  public init(isHorizontal: Bool? = nil,
              heightForHorizontal: CGFloat = 40,
              feedModels: [CZFeedModel],
              headerModel: CZFeedModel? = nil,
              footerModel: CZFeedModel? = nil,
              minimumLineSpacing: CGFloat? = nil,
              minimumInteritemSpacing: CGFloat? = nil,
              sectionInset: UIEdgeInsets? = nil) {
    self.isHorizontal = isHorizontal ?? false
    self.heightForHorizontal = heightForHorizontal
    self.feedModels = feedModels
    self.headerModel = headerModel
    self.footerModel = footerModel
    self.minimumLineSpacing = minimumLineSpacing
    self.minimumInteritemSpacing = minimumInteritemSpacing
    self.sectionInset = sectionInset
    super.init()

    if let isHorizontal {
      for feedModel in self.feedModels {
        feedModel.isHorizontal = isHorizontal
      }
    }
  }
  
  public class func sectionModel(with aSectionModel: CZSectionModel, 
                                 feedModels: [CZFeedModel]) -> CZSectionModel {
    let replicated = aSectionModel
    replicated.feedModels = feedModels
    return replicated
  }
  
  public func isEqual(toDiffableObj object: AnyObject) -> Bool {
    guard let object = object as? CZSectionModel else {
      return false
    }
    return feedModels.isEqual(toDiffableObj: object.feedModels) &&
    CZListDiffableHelper.isEqual(headerModel, object.headerModel) &&
    CZListDiffableHelper.isEqual(footerModel, object.footerModel) &&
    minimumLineSpacing == object.minimumLineSpacing &&
    minimumInteritemSpacing == object.minimumInteritemSpacing &&
    isHorizontal == object.isHorizontal
  }
  
  public func copy(with zone: NSZone? = nil) -> Any {
    return self
//    return CZSectionModel(isHorizontal: isHorizontal,
//                          feedModels: feedModels.copy() as! [CZFeedModel],
//                          headerModel: headerModel?.copy() as? CZFeedModel,
//                          footerModel: footerModel?.copy() as? CZFeedModel,
//                          minimumLineSpacing: minimumLineSpacing,
//                          minimumInteritemSpacing: minimumInteritemSpacing,
//                          sectionInset: sectionInset)
  }
}
