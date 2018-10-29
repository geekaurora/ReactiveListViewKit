//
//  AutoScrollManager.swift
//
//  Created by Cheng Zhang on 10/25/18.
//  Copyright © 2018 LinkedIn. All rights reserved.
//

import UIKit

public protocol AutoScrollManagerDelegate: class {
    func indexPathsForVisibleItemsDidChange(_ indexPathsForVisibleItems: [IndexPath])
}

/**
 Auto scroll UICollectionView from top to bottom
 */
public class AutoScrollManager: NSObject {
    fileprivate static let logPrefix = "[AutoScrollManager] "
    fileprivate let collectionView: UICollectionView
    fileprivate let sectionsPerScroll: Int
    fileprivate let maxSections: Int
    
    fileprivate var lastScrolledSection = 0
    fileprivate var shouldAutoScroll = false
    
    public weak var delegate: AutoScrollManagerDelegate?
    fileprivate var indexPathsForVisibleItems: [IndexPath] = []
    
    public init(collectionView: UICollectionView,
                sectionsPerScroll: Int = 1, // 3 sections = 1 screen
        maxSections: Int = 10) {
        self.collectionView = collectionView
        self.sectionsPerScroll = sectionsPerScroll
        self.maxSections = maxSections
        super.init()
        collectionView.scrollDelegateProxy = self
    }
    
    public func refreshIndexPathsForVisibleItems() {
        checkIndexPathsForVisibleItems()
    }
    
    fileprivate func checkIndexPathsForVisibleItems() {
        let curIndexPathsForVisibleItems = collectionView.indexPathsForVisibleItems.sorted()
        if curIndexPathsForVisibleItems != indexPathsForVisibleItems &&
            (indexPathsForVisibleItems.isEmpty || curIndexPathsForVisibleItems.last != indexPathsForVisibleItems.last) {
            delegate?.indexPathsForVisibleItemsDidChange(curIndexPathsForVisibleItems)
            indexPathsForVisibleItems = curIndexPathsForVisibleItems
        }
    }
}

extension AutoScrollManager: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        checkIndexPathsForVisibleItems()
    }
}
