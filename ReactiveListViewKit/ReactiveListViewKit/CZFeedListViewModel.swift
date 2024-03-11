//
//  CZFeedListViewModel.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 1/3/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit

/**
 ViewModel/State class for `CZFeedListFacadeView`
 */
public class CZFeedListViewModel: NSObject, NSCopying {
  private(set) var sectionModels: [CZSectionModel]
  
  /// Initializer for multiple section ListView
  public required init(sectionModels: [CZSectionModel]?) {
    self.sectionModels = sectionModels ?? []
  }
  
  /// Convenience initializer for single section ListView
  public init(feedModels: [CZFeedModel]? = nil) {
    self.sectionModels = []
    super.init()
    if let feedModels = feedModels {
      reset(withFeedModels: feedModels)
    }
  }
  
  /// Method for multiple section ListView
  @objc(resetWithSectionModels:)
  public func reset(withSectionModels sectionModels: [CZSectionModel]) {
    self.sectionModels = sectionModels
  }
  
  /// Convenient method for single section ListView
  @objc(resetWithFeedModels:)
  public func reset(withFeedModels feedModels: [CZFeedModel]) {
    let sectionModels = [CZSectionModel(feedModels: feedModels)]
    reset(withSectionModels: sectionModels)
  }
  
  // MARK: - UICollectionView DataSource
  
  public func numberOfSections() -> Int{
    return sectionModels.count
  }
  
  public func numberOfItems(inSection section: Int) -> Int {
    let sectionModel = sectionModels[section]
    return sectionModel.isHorizontal ? 1 : sectionModel.feedModels.count
  }
  
  // SectionHeader/SectionFooter
  public func supplementaryModel(inSection section: Int, 
                                 kind: String) -> CZFeedModel? {
    return (kind == UICollectionView.elementKindSectionHeader) ? sectionModels[section].headerModel : sectionModels[section].footerModel
  }
  
  public func feedModel(at indexPath: IndexPath) -> CZFeedModel? {
    guard indexPath.section < sectionModels.count &&
            indexPath.row < sectionModels[indexPath.section].feedModels.count else {
      assertionFailure("Couldn't find matched cell/feedModel at \(indexPath)")
      return nil
    }
    let feedModel = sectionModels[indexPath.section].feedModels[indexPath.row]
    return feedModel
  }
  
  // MARK: - NSCopying
  
  public func copy(with zone: NSZone? = nil) -> Any {
    guard let sectionModelsCopy = sectionModels.copy() as? [CZSectionModel] else {
      fatalError("Failed to copy the instance.")
    }
    let viewModel = type(of: self).init(sectionModels: sectionModelsCopy)
    return viewModel
  }
}
