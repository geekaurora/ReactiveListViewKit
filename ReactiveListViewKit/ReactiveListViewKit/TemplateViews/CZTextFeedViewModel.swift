//
//  CZTextFeedViewModel.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 2/7/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit

open class CZSimpleTextFeedModel: CZFeedModel {
    public init(text: String, isHorizontal: Bool = false, model: Any? = nil) {
        super.init(viewClass: CZTextFeedCellView.self,
                   viewModel: CZTextFeedViewModel(text: text,
                                                  isHorizontal: isHorizontal,
                                                  model: model))
    }

    public required init(viewClass: CZFeedCellViewSizeCalculatable.Type, viewModel: CZFeedViewModelable) {
        super.init(viewClass: viewClass, viewModel: viewModel)
    }
}

open class CZTextFeedViewModel: NSObject, CZFeedViewModelable {
    public let text: String
    public let model: Any?
    public let isHorizontal: Bool
    public var diffId: String {
        return presetDiffId ?? (currentClassName + text)
    }
    private var presetDiffId: String?

    public required init(diffId: String? = nil,
                         text: String,
                         isHorizontal: Bool = false,
                         model: Any? = nil) {
        self.presetDiffId = diffId
        self.text = text
        self.model = model
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
        let copy = type(of: self).init(text: textCopy, model: model)
        return copy
    }
}
