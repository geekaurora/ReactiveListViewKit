//
//  CZFeedListFacadeView.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 1/9/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit

/// Elegant Facade class encapsulating UICollectionview/UIMapView for reusable cells
///
/// - Features:
///   - Pagination
///   - Event driven: more loosely coupled than delegation
///   - Stateful
open class CZFeedListFacadeView: UIView {
    // Resolver closure transforming [Feed] to [CZSectionModel]
    public typealias SectionModelsResolver = ([Any]) -> [CZSectionModel]
    internal var onEvent: OnEvent?
    var viewModel: CZFeedListViewModel {
        return _viewModel
    }
    fileprivate var _viewModel: CZFeedListViewModel!
    fileprivate var prevViewModel: CZFeedListViewModel = {
        let viewModel = CZFeedListViewModel()
        return viewModel
    }()
    fileprivate(set) var collectionView: UICollectionView!
    fileprivate let parentViewController: UIViewController?
    fileprivate var collectionViewBGColor: UIColor?
    fileprivate var minimumLineSpacing: CGFloat
    fileprivate var minimumInteritemSpacing: CGFloat
    fileprivate var sectionInset: UIEdgeInsets
    fileprivate var showsVerticalScrollIndicator: Bool
    fileprivate var showsHorizontalScrollIndicator: Bool

    fileprivate var stateMachine: CZFeedListViewStateMachine!
    fileprivate var isHorizontal: Bool
    fileprivate var prevLoadMoreScrollOffset: CGFloat = 0
    fileprivate var isLoadingMore: Bool = false
    fileprivate var viewedIndexPaths = Set<IndexPath>()
    fileprivate var allowPullToRefresh: Bool
    fileprivate var allowLoadMore: Bool

    fileprivate lazy var registeredCellReuseIds: Set<String> = []
    fileprivate lazy var hasPulledToRefresh: Bool = false
    static let kLoadMoreThreshold = 0
    /// Threshold indexes distance from the last cell, before triggers `loadMore`event
    fileprivate var loadMoreThreshold: Int = kLoadMoreThreshold
    var sectionModelsResolver: SectionModelsResolver?
    fileprivate var hasInvokedWillDisplayCell: Bool = false
    
    fileprivate var hasSetup: Bool = false
    public var isLoading: Bool = false {
        willSet {
            guard isLoading != newValue else {return}
            if newValue {
                hasPulledToRefresh = true
                collectionView.refreshControl?.beginRefreshing()
            } else {
                viewedIndexPaths.removeAll()
                collectionView.refreshControl?.endRefreshing()
            }
        }
    }
    // KVO
    fileprivate var kvoContext: UInt8 = 0
    fileprivate var prevVisibleIndexPaths: [IndexPath] = []
    
    public init(sectionModelsResolver: SectionModelsResolver?,
                onEvent: OnEvent? = nil,
                isHorizontal: Bool = false,
                parentViewController: UIViewController? = nil,
                backgroundColor: UIColor? = ReactiveListViewKit.GreyBGColor,
                minimumLineSpacing: CGFloat = ReactiveListViewKit.minimumLineSpacing,
                minimumInteritemSpacing: CGFloat = ReactiveListViewKit.minimumInteritemSpacing,
                sectionInset: UIEdgeInsets = ReactiveListViewKit.sectionInset,
                allowPullToRefresh: Bool = true,
                allowLoadMore: Bool = true,
                loadMoreThreshold: Int = CZFeedListFacadeView.kLoadMoreThreshold,
                showsVerticalScrollIndicator: Bool = true,
                showsHorizontalScrollIndicator: Bool = false) {
        assert(isHorizontal || sectionModelsResolver != nil, "`sectionModelsResolver` can only be set to nil in nested horizontal sectoin.")

        self.sectionModelsResolver = sectionModelsResolver
        self.isHorizontal = isHorizontal
        if (isHorizontal) {
            self.allowPullToRefresh = false
            self.allowLoadMore = false
        } else {
            self.allowPullToRefresh = allowPullToRefresh
            self.allowLoadMore = allowLoadMore
        }
        self.parentViewController = parentViewController
        self.loadMoreThreshold = loadMoreThreshold
        self.collectionViewBGColor = backgroundColor
        self.minimumLineSpacing = minimumLineSpacing
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.sectionInset = sectionInset
        self.showsVerticalScrollIndicator = showsVerticalScrollIndicator
        self.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
        super.init(frame: .zero)
        self.onEvent = onEvent
        setup()
    }
    
    public override init(frame: CGRect) { fatalError("Should call designated initializer `init(sectionModelsResolver: onEvent)`") }

    required public init?(coder: NSCoder) { fatalError("Should call designated initializer `init(sectionModelsResolver: onEvent)`") }

    public func setup() {
        guard !hasSetup else {return}
        hasSetup = true
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        _viewModel = CZFeedListViewModel(sectionModels: nil)
        setupCollectionView()
    }

    public func batchUpdate(withFeeds feeds: [Any], animated: Bool = true) {
        if let sectionModels = sectionModelsResolver?(feeds) {
            batchUpdate(withSectionModels: sectionModels)
        }
    }

    public func batchUpdate(withFeedModels feedModels: [CZFeedModel], animated: Bool = true) {
        batchUpdate(withSectionModels: [CZSectionModel(feedModels: feedModels)])
    }


    public func batchUpdate(withSectionModels sectionModels: [CZSectionModel], animated: Bool = true) {
        // Filter empty sectionModels to avoid inconsistent amount of sections/rows crash
        // Because default empty section is counted as 1 before reloadListView, leads to crash
        let sectionModels = adjustSectionModels(sectionModels)

        self.registerCellClassesIfNeeded(for: sectionModels)
        self.viewModel.batchUpdate(withSectionModels: sectionModels)
        self.reloadListView(animated: animated)
    }
    
    fileprivate func adjustSectionModels(_ sectionModels: [CZSectionModel]) -> [CZSectionModel] {
        var res = sectionModels.filter {!$0.isEmpty}
        res = res.flatMap { sectionModel in
            if sectionModel.isHorizontal {
                let horizontalFeedModel = CZFeedModel(viewClass: CZHorizontalSectionAdapterCell.self,
                                                      viewModel: CZHorizontalSectionAdapterViewModel(sectionModel.feedModels,
                                                                                                     viewHeight: sectionModel.heightForHorizontal)
                )
                let horizontalSectionModel = CZSectionModel.sectionModel(with: sectionModel, feedModels: [horizontalFeedModel])
                return horizontalSectionModel
            }
            return sectionModel
        }
        return res
    }

    public func listenToEvents(_ onEvent: @escaping OnEvent) {
        self.onEvent = onEvent
    }

    public func reuseId(with cellClass: AnyClass) -> String {
        return NSStringFromClass(object_getClass(cellClass))
    }
}

// MARK: - Private methods
fileprivate extension CZFeedListFacadeView  {
    func registerCellClassesIfNeeded(for sectionModels: [CZSectionModel]) {
        [CZFeedModel](sectionModels.flatMap({$0.feedModels})).forEach {
            registerCellClassIfNeeded($0.viewClass)
        }
    }

    func registerCellClassIfNeeded(_ cellClass: AnyClass) {
        let reuseId = self.reuseId(with: cellClass)
        guard cellClass is UICollectionViewCell.Type else {
            return
        }
        collectionView.register(cellClass, forCellWithReuseIdentifier: reuseId)
        registeredCellReuseIds.insert(reuseId)
    }

    func reloadListView(animated: Bool) {
        let (sectionsDiff, rowsDiff) = CZListDiff.diffSectionModels(current: viewModel.sectionModels, prev: prevViewModel.sectionModels)
        guard CZListDiff.sectionCount(for: sectionsDiff[.insertedSections]) > 0 ||
            CZListDiff.sectionCount(for: sectionsDiff[.deletedSections]) > 0 ||
            rowsDiff[.deleted]?.count ?? 0 > 0 ||
            rowsDiff[.moved]?.count ?? 0 > 0 ||
            rowsDiff[.updated]?.count ?? 0 > 0 ||
            rowsDiff[.inserted]?.count ?? 0 > 0 else {
                return
        }

        if !ReactiveListViewKit.incrementalUpdateOn || !animated {
            self.collectionView.reloadData()
        } else {
            let batchUpdate = {
                // Sections: inserted sections
                // Insert all items inside automatically, shouldn't insert items to avoid inconsistent number crash
                if let insertedSections = sectionsDiff[.insertedSections] as? IndexSet,
                    insertedSections.count > 0 {
                    self.collectionView.insertSections(insertedSections)
                }

                // Rows: deleted
                if let removedIndexPathes = rowsDiff[.deleted] as? [IndexPath],
                    removedIndexPathes.count > 0 {
                    self.collectionView.deleteItems(at: removedIndexPathes)
                }
                // Rows: unchanged
                let unchangedIndexPaths = rowsDiff[.unchanged]

                // Rows: inserted
                if let insertedIndexPaths = rowsDiff[.inserted] as? [IndexPath],
                    insertedIndexPaths.count > 0 {
                    self.collectionView.insertItems(at: insertedIndexPaths)
                }

                // Rows: moved
                if let movedIndexPaths = rowsDiff[.moved] as? [MovedIndexPath],
                    movedIndexPaths.count > 0 {
                    movedIndexPaths.forEach { movedIndexPath in
                        self.collectionView.moveItem(at: movedIndexPath.from, to: movedIndexPath.to)
                    }
                }

                // Rows: updated
                if let updatedIndexPaths = rowsDiff[.updated] as? [IndexPath],
                    updatedIndexPaths.count > 0 {
                    self.collectionView.reloadItems(at: updatedIndexPaths)
                }

                // Secitons: deleted
                if let deletedSections = sectionsDiff[.deletedSections] as? IndexSet,
                    deletedSections.count > 0 {
                    self.collectionView.deleteSections(deletedSections)
                }
            }
            collectionView.performBatchUpdates(batchUpdate, completion: nil)
        }
        prevViewModel = viewModel.copy() as! CZFeedListViewModel

        for indexPath in viewedIndexPaths {
            if indexPath.section > viewModel.sectionModels.count - 1 ||
                (indexPath.section == viewModel.sectionModels.count - 1 &&
                    indexPath.row >= (viewModel.sectionModels.last?.feedModels.count ?? 0)  - 1) {
                viewedIndexPaths.remove(indexPath)
            }
        }
    }

    func setupCollectionView() {
        // Initialization
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = isHorizontal ? .horizontal : .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
        collectionView.showsVerticalScrollIndicator = showsVerticalScrollIndicator

        addSubview(collectionView)
        collectionView.overlayOnSuperview()

        // refreshControl
        if allowPullToRefresh {
            collectionView.refreshControl = UIRefreshControl()
            collectionView.refreshControl?.addTarget(self, action: #selector(refreshControlValueChanged), for: UIControlEvents.valueChanged)
        }

        // Datasource/delegate
        collectionView.dataSource = self
        collectionView.delegate = self
        if #available(iOS 10.0, *) {
            collectionView.prefetchDataSource = self
        }

        // Register cells
        registerCellClassIfNeeded(CZFeedListCell.self)

        // Register headerView
        collectionView.register(CZFeedListSupplementaryView.self,
                                forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                withReuseIdentifier: CZFeedListSupplementaryView.reuseId)
        // Register footerView
        collectionView.register(CZFeedListSupplementaryView.self,
                                forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
                                withReuseIdentifier: CZFeedListSupplementaryView.reuseId)
        
        updateVisibleIndexPathsIfNeeded()
    }
    
    func updateVisibleIndexPathsIfNeeded() {
//        let sortClosure = { (indexPath0: IndexPath, indexPath1: IndexPath) -> Bool in
//            if indexPath0.section < indexPath1.section {
//                return true
//            } else if indexPath0.section == indexPath1.section {
//                return indexPath0.row < indexPath1.row
//            } else {
//                return false
//            }
//        }                
//        let newVisibleIndexPaths = collectionView.indexPathsForVisibleItems.sorted(by: sortClosure)
//        if prevVisibleIndexPaths != newVisibleIndexPaths {
//            prevVisibleIndexPaths = newVisibleIndexPaths
//            onEvent?(CZFeedListViewEvent.visibleIndexPathsChanged(newValue: newVisibleIndexPaths))
//        }
    }
}

// UICollectionViewFlowLayout
extension CZFeedListFacadeView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let feedModel = viewModel.feedModel(at: indexPath) else {
            assertionFailure("Couldn't find matched cell/feedModel at \(indexPath)")
            return .zero
        }
        // UICollectionView has .zero frame at this point
        let collectionViewSize = collectionView.bounds.size
        let size = feedModel.viewClass.sizeThatFits(collectionViewSize, viewModel: feedModel.viewModel)
        return size
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let supplymentaryModel = viewModel.supplementaryModel(inSection: section, kind: UICollectionElementKindSectionHeader) else {
            return .zero
        }
        let collectionViewSize = CGSize(width: UIScreen.main.bounds.size.width, height: 0)
        let size = supplymentaryModel.viewClass.sizeThatFits(collectionViewSize, viewModel: supplymentaryModel.viewModel)
        return size
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let supplymentaryModel = viewModel.supplementaryModel(inSection: section, kind: UICollectionElementKindSectionFooter) else {
            return .zero
        }
        let collectionViewSize = CGSize(width: UIScreen.main.bounds.size.width, height: 0)
        let size = supplymentaryModel.viewClass.sizeThatFits(collectionViewSize, viewModel: supplymentaryModel.viewModel)
        return size
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return viewModel.sectionModels[section].sectionInset ?? sectionInset
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,  minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.sectionModels[section].minimumLineSpacing ?? minimumLineSpacing
        
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.sectionModels[section].minimumInteritemSpacing ?? minimumInteritemSpacing
    }
    
    @objc func refreshControlValueChanged(_ refreshControl:UIRefreshControl){
        if (refreshControl.isRefreshing) {
            onEvent?(CZFeedListViewEvent.pullToRefresh(isFirst: !hasPulledToRefresh))
        }
    }
}

// MARK: - UICollectionView
extension CZFeedListFacadeView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let amount = viewModel.numberOfItems(inSection: section)
        print("numberOfItems in section\(section): \(amount)")
        return amount
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("viewModel.numberOfSections(): \(viewModel.numberOfSections())")
        return viewModel.numberOfSections()
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellClass: AnyClass
        if let feedModel = viewModel.feedModel(at: indexPath) {
            if let viewClass = feedModel.viewClass as? UICollectionViewCell.Type {
                // if viewClass is Cell, it will be dequeued to reuse
                cellClass = viewClass
            } else {
                // if viewClass is UIView, it will be automatically added/overlapped to embeded Cell
                cellClass = CZFeedListCell.self
            }

            let reuseCellId = reuseId(with: cellClass)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCellId, for: indexPath)
            if let cell = cell as? CZFeedListCell {
                cell.config(with: feedModel, onEvent: onEvent, parentViewController: parentViewController)
                return cell
            } else if let cell = cell as? CZFeedCellViewSizeCalculatable {
                cell.config(with: feedModel.viewModel)
                cell.onEvent = onEvent
                return cell as! UICollectionViewCell
            }
        }
        assertionFailure("Couldn't find matched cell/feedModel at \(indexPath)")
        return UICollectionViewCell()
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                   withReuseIdentifier: CZFeedListSupplementaryView.reuseId,
                                                                                   for: indexPath) as? CZFeedListSupplementaryView {
            if let supplymentaryModel = viewModel.supplementaryModel(inSection: indexPath.section, kind: kind) {
                supplementaryView.config(with: supplymentaryModel, onEvent: onEvent)
            } else {
                assertionFailure("Couldn't find matched ViewModel for supplementaryView.")
            }
            return supplementaryView
        }
        assertionFailure("Couldn't find matched cell/feedModel at \(indexPath)")
        return UICollectionReusableView()
    }
}

extension CZFeedListFacadeView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let feedModel = viewModel.feedModel(at: indexPath) else {
            assertionFailure("Couldn't find matched cell/feedModel at \(indexPath)")
            return
        }
        onEvent?(CZFeedListViewEvent.selectedCell(feedModel))
    }

    // MARK: - Load More
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewedIndexPaths.insert(indexPath)
        let isLastRow = indexPath.section == (viewModel.sectionModels.count - 1) &&
            indexPath.row >= (viewModel.sectionModels.last?.feedModels.count ?? 0) - 1 - loadMoreThreshold
        if allowLoadMore &&
            isLastRow &&
            !viewedIndexPaths.contains(indexPath) {
            onEvent?(CZFeedListViewEvent.loadMore)
        }
        
        if !hasInvokedWillDisplayCell &&
            collectionView.indexPathsForVisibleItems.count > 0 {
            hasInvokedWillDisplayCell = true
            updateVisibleIndexPathsIfNeeded()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        updateVisibleIndexPathsIfNeeded()
    }
}

extension CZFeedListFacadeView: UICollectionViewDataSourcePrefetching {
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        //onEvent?(CZFeedListViewEvent.prefetch(indexPaths))
    }

    public func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        //onEvent?(CZFeedListViewEvent.cancelPrefetching(indexPaths))
    }
}

extension CZFeedListFacadeView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //updateVisibleIndexPathsIfNeeded()
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isLoadingMore = false
    }
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    }
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            isLoadingMore = false
        }
    }
}




