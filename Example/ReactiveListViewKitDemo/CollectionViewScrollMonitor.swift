//
//  CollectionViewScrollMonitor.swift
//
//  Created by Cheng Zhang on 10/25/18.
//  Copyright © 2018 LinkedIn. All rights reserved.
//

import UIKit

public protocol CollectionViewScrollMonitorDelegate: class {
    func indexPathsForVisibleItemsDidChange(_ indexPathsForVisibleItems: [IndexPath])
}

public class CollectionViewScrollMonitor: NSObject {
    fileprivate let collectionView: UICollectionView
    fileprivate var scrolledSectionsThreshold: Int
    fileprivate var lastVisibleSection: Int = 0
    public weak var delegate: CollectionViewScrollMonitorDelegate?
    fileprivate var indexPathsForVisibleItems: [IndexPath] = []
    
    public init(collectionView: UICollectionView,
                scrolledSectionsThreshold: Int = 3) {
        self.collectionView = collectionView
        self.scrolledSectionsThreshold = scrolledSectionsThreshold
        super.init()
        collectionView.scrollDelegateProxy = self
    }
    
    public func refreshIndexPathsForVisibleItems() {
        checkIndexPathsForVisibleItems()
    }
    
    fileprivate func checkIndexPathsForVisibleItems() {
        let curIndexPathsForVisibleItems = collectionView.indexPathsForVisibleItems.sorted()
        if !curIndexPathsForVisibleItems.isEmpty &&
            curIndexPathsForVisibleItems != indexPathsForVisibleItems &&
            (indexPathsForVisibleItems.isEmpty || curIndexPathsForVisibleItems.last != indexPathsForVisibleItems.last) {
            
            let bottomIndexPath = curIndexPathsForVisibleItems.last!
            let expectedVisibleSection = lastVisibleSection + scrolledSectionsThreshold
            let bottomVisibleSection = (bottomIndexPath.section == 1) ? bottomIndexPath.row : -1
            
            // Verify bottomVisibleSection >= expectedVisibleSection
            if bottomVisibleSection >= expectedVisibleSection {
                delegate?.indexPathsForVisibleItemsDidChange(curIndexPathsForVisibleItems)
                lastVisibleSection = expectedVisibleSection
            }
            indexPathsForVisibleItems = curIndexPathsForVisibleItems
            print("indexPathsForVisibleItems:\(indexPathsForVisibleItems)")
        }
    }
}

extension CollectionViewScrollMonitor: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        checkIndexPathsForVisibleItems()
    }
}
