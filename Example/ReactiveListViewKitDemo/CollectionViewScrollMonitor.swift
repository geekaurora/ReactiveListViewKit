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
    public fileprivate(set) var scrolledSectionsThreshold: Int
    public fileprivate(set) var lastVisibleSection: Int = 0
    fileprivate var seenDiffSectionCount: Int = 0
    fileprivate var indexPathsForVisibleItems: [IndexPath] = []
    public weak var delegate: CollectionViewScrollMonitorDelegate?
    public var isFeed = false

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
            let bottomVisibleSection: Int = {
                if self.isFeed {
                    return bottomIndexPath.section
                } else {
                    return (bottomIndexPath.section == 1) ? bottomIndexPath.row : 0
                }
            }()

            // Increment diffSection counter
            if bottomVisibleSection != lastVisibleSection {
                seenDiffSectionCount += 1
            }

            if seenDiffSectionCount >= scrolledSectionsThreshold  {
                delegate?.indexPathsForVisibleItemsDidChange(curIndexPathsForVisibleItems)
                seenDiffSectionCount = 0
            }
            lastVisibleSection = bottomVisibleSection
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

fileprivate var scrollDelegateProxyPointer: Int8 = 0
public extension UICollectionView {
    public var scrollDelegateProxy: UIScrollViewDelegate? {
        get {
            return objc_getAssociatedObject(self, &scrollDelegateProxyPointer) as? UIScrollViewDelegate
        }
        set {
            objc_setAssociatedObject(self, &scrollDelegateProxyPointer, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
