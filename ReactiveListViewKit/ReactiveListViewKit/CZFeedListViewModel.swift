//
//  CZFeedListViewModel.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 1/3/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit

/// ViewModel/State class for CZFeedListView
public class CZFeedListViewModel: NSObject, NSCopying {
    fileprivate(set) var sectionModels: [CZSectionModel]

    /// Initializer for multiple section ListView
    public required init(sectionModels: [CZSectionModel]?) {
        self.sectionModels = sectionModels ?? []
    }
    
    /// Convenient initializer for single section ListView
    public init(feedModels: [CZFeedModel]? = nil) {
        self.sectionModels = []
        super.init()
        if let feedModels = feedModels {
            batchUpdate(with: feedModels)
        }
    }
    
    /// Method for multiple section ListView
    @objc(resetWithSectionModels:)
    public func batchUpdate(withSectionModels sectionModels: [CZSectionModel]) {
        self.sectionModels.removeAll()
        self.sectionModels.append(contentsOf: sectionModels)
    }

    /// Convenient method for single section ListView
    @objc(resetWithFeedModels:)
    public func batchUpdate(with feedModels: [CZFeedModel]) {
        let sectionModels = [CZSectionModel(feedModels: feedModels)]
        batchUpdate(withSectionModels: sectionModels)
    }

    // MARK: - UICollectionView DataSource
    public func numberOfSections() -> Int{
        return sectionModels.count
    }

    public func numberOfItems(inSection section: Int) -> Int {
        let sectionModel = sectionModels[section]
        return sectionModel.isHorizontal ? 1 : sectionModel.feedModels.count
    }

    // UICollectionElementKindSectionHeader/UICollectionElementKindSectionFooter
    public func supplementaryModel(inSection section: Int, kind: String) -> CZFeedModel? {
        return (kind == UICollectionElementKindSectionHeader) ? sectionModels[section].headerModel : sectionModels[section].footerModel
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
            fatalError("Failure of copy function.")
        }
        let viewModel = type(of: self).init(sectionModels: sectionModelsCopy)
        return viewModel
    }
}

/// ViewModel/State class for CZFeedDetailsView
open class CZFeedDetailsViewModel: NSObject, NSCopying {
    fileprivate var _feedModels: [CZFeedModelable]
    required public init(feedModels: [CZFeedModelable]? = nil) {
        _feedModels = feedModels ?? []
    }
    public func batchUpdate(with feedModels: [CZFeedModelable]) {
        _feedModels.removeAll()
        _feedModels.append(contentsOf: feedModels)
    }
    // MARK: - NSCopying
    public func copy(with zone: NSZone? = nil) -> Any {
        let feedModels = _feedModels.flatMap{ $0.copy() as? CZFeedModelable}
        let viewModel = type(of: self).init(feedModels: feedModels)
        return viewModel
    }
    public var feedModels: [CZFeedDetailsModel] {
        return (_feedModels as? [CZFeedDetailsModel]) ?? []
    }
}

