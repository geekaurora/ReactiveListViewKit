//
//  CZFeedDetailsViewModel.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 1/3/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit

/// ViewModel/State class for `CZFeedDetailsFacadeView`
open class CZFeedDetailsViewModel: NSObject, NSCopying {
    private var _feedModels: [CZFeedModelable]
    required public init(feedModels: [CZFeedModelable]? = nil) {
        _feedModels = feedModels ?? []
    }
    public func batchUpdate(with feedModels: [CZFeedModelable]) {
        _feedModels.removeAll()
        _feedModels.append(contentsOf: feedModels)
    }
    // MARK: - NSCopying
    public func copy(with zone: NSZone? = nil) -> Any {
        let feedModels = _feedModels.compactMap{ $0.copy(with: nil) as? CZFeedModelable}
        let viewModel = type(of: self).init(feedModels: feedModels)
        return viewModel
    }
    public var feedModels: [CZFeedDetailsModel] {
        return (_feedModels as? [CZFeedDetailsModel]) ?? []
    }
}
