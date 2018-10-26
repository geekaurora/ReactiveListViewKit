//
//  AutoScrollManager.swift
//
//  Created by Cheng Zhang on 10/25/18.
//  Copyright © 2018 LinkedIn. All rights reserved.
//

import UIKit

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

    public init(collectionView: UICollectionView,
                sectionsPerScroll: Int = 1, // 3 sections = 1 screen
                maxSections: Int = 10) {
        self.collectionView = collectionView
        self.sectionsPerScroll = sectionsPerScroll
        self.maxSections = maxSections
        super.init()
        collectionView.scrollDelegateProxy = self
    }
    
    public func startScroll() {
        shouldAutoScroll = true
        nextScroll()
    }
    
    fileprivate func nextScroll() {
        guard shouldAutoScroll else {
            return
        }
        let section = 1
        
        var nextSection = lastScrolledSection + sectionsPerScroll
        let totalSections = collectionView.numberOfItems(inSection: section)
        
        if nextSection > totalSections - 1 {
            nextSection = totalSections - 1
            shouldAutoScroll = false
            print(AutoScrollManager.logPrefix + "Reached the last section")
        }
        let indexPath = IndexPath(row: nextSection, section: section)
        collectionView.scrollToItem(
            at: indexPath,
            at: .bottom,
            animated: true)
        lastScrolledSection = nextSection
    }
}

extension AutoScrollManager: UIScrollViewDelegate {
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)  {
        guard shouldAutoScroll else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.nextScroll()
        }
        
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)  {
        nextScroll()
    }
}
