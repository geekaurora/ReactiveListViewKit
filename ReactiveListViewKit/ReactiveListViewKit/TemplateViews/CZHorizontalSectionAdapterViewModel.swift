//
//  CZHorizontalSectionAdapterViewModel.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 1/16/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit

/// ViewModel class of `CZHorizontalSectionAdapterView`
public class CZHorizontalSectionAdapterViewModel: NSObject, CZFeedViewModelable, State {
    public lazy var diffId: String = self.currentClassName
    fileprivate(set) var feedModels: [CZFeedModel]
    fileprivate(set) var headerModel: CZFeedModel?
    fileprivate(set) var footerModel: CZFeedModel?
    fileprivate(set) var viewHeight: CGFloat
    fileprivate(set) var backgroundColor: UIColor
    fileprivate(set) var showTopDivider: Bool
    fileprivate(set) var showBottomDivider: Bool
    fileprivate(set) var isUserInteractionEnabled: Bool
    
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
    public func react(to event: Event) { }
}
