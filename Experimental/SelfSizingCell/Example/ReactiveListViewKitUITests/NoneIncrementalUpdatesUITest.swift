//
//  ReactiveListViewKitUITests.swift
//
//  Created by Cheng Zhang on 2/6/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import KIF
@testable import ReactiveListViewKit
@testable import ReactiveListViewKitDemo

class NoneIncrementalUpdatesUITest: CZUITest {
    
    private static let verticalScrollFraction: CGFloat = -0.15
    
    override func setUp() {
        super.setUp()        
        ReactiveListViewKit.isIncrementalUpdateEnabled = false
        continueAfterFailure = true
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCollectionView() {
        guard let collectionView = tester().view(withAccessibilityIdentifier: AccessibilityLabel.feedListCollectionView) as? UICollectionView else {
            XCTFail("Couldn't find collectionView")
            return
        }
        // Verify cells count matchs mock feeds
        let cellsCount = collectionView.numberOfItems(inSection: 1)
        // Increment one for inserted SuggestedUsersCell
        let mockCount = CZMocker.shared.feeds.count + 1
        XCTAssert(cellsCount == mockCount, "Cells count \(cellsCount) doesn't match mocker feeds count \(mockCount)")
    }
    
    // TODO(@cnzhang): Test feeds with duplicates.
    func testCells() {
        // Wait for collectionView
        tester().waitForView(withAccessibilityLabel: AccessibilityLabel.feedListCollectionView)
        
        // Verify Cells
        CZMocker.shared.feeds.forEach { feed in
            tester().waitForView(withAccessibilityLabel: feed.content ?? "")
        }
    }
    
    // TODO(@cnzhang): Test scrolling performance by measuring dropped frames
    func testScrollToBottom() {
        guard let collectionView = tester().view(withAccessibilityIdentifier: AccessibilityLabel.feedListCollectionView) as? UICollectionView else {
            XCTFail("Couldn't find collectionView")
            return
        }
        // Keep scrolling to last cell
        let cellsCount = collectionView.numberOfItems(inSection: 1)
        let lastIndexPath = IndexPath(row: cellsCount - 1, section: 1)
        var visibleIndexPaths = collectionView.indexPathsForVisibleItems
        
        while !visibleIndexPaths.contains(lastIndexPath) {
            tester().scrollView(
                withAccessibilityLabel: AccessibilityLabel.feedListCollectionView,
                byFractionOfSizeHorizontal: 0,
                vertical: type(of: self).verticalScrollFraction)
            visibleIndexPaths = collectionView.indexPathsForVisibleItems
        }
    }
}
