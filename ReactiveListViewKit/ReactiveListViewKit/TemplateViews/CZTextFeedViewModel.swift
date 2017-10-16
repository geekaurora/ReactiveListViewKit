//
//  CZTextFeedViewModel.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 2/7/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit

open class CZSimpleTextFeedModel: CZFeedModel {
    public init(text: String, isHorizontal: Bool = false) {
        super.init(viewClass: CZTextFeedCellView.self,
                   viewModel: CZTextFeedViewModel(text: text,
                                                  isHorizontal: isHorizontal))
    }

    public required init(viewClass: CZFeedCellViewSizeCalculatable.Type, viewModel: CZFeedViewModelable) {
        super.init(viewClass: viewClass, viewModel: viewModel)
    }
}

open class CZTextFeedViewModel: NSObject, CZFeedViewModelable {
    /// diffId is used for diff algorithm of incremental update, compare whether two involved viewModels equal
    public let text: String
    public let isHorizontal: Bool
    public var diffId: String {
        return currentClassName + text
    }

    public required init(text: String, isHorizontal: Bool = false) {
        self.text = text
        self.isHorizontal = isHorizontal
        super.init()
    }

    public func isEqual(toDiffableObj object: AnyObject) -> Bool {
        guard let object = object as? CZTextFeedViewModel else {return false}
        return diffId == object.diffId &&
               text == object.text
    }

    public func copy(with zone: NSZone? = nil) -> Any {
        let textCopy = text
        let copy = type(of: self).init(text: textCopy)
        return copy
    }
}
