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
    private static let logPrefix = "[AutoScrollManager] "
    private let collectionView: UICollectionView
    private let sectionsPerScroll: Int
    private let maxSections: Int

    private var lastScrolledSection = -1

    public init(collectionView: UICollectionView,
                sectionsPerScroll: Int = 6,
                maxSections: Int = 10) {
        self.collectionView = collectionView
        self.sectionsPerScroll = sectionsPerScroll
        self.maxSections = maxSections
        super.init()
    }
    
    public func startScroll() {
        var nextSection = lastScrolledSection + sectionsPerScroll
        let totalSections = collectionView.numberOfSections
        if nextSection > totalSections - 1 {
            nextSection = totalSections - 1
            print(AutoScrollManager.logPrefix + "Reached the last section")
        }
        let indexPath = IndexPath(row: 0, section: nextSection)
        collectionView.scrollToItem(
            at: indexPath,
            at: .bottom,
            animated: true)
        lastScrolledSection = nextSection
    }
}
