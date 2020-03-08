//
//  CZListDiff.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 1/5/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit

public struct MovedIndexPath: Equatable, Hashable {
    let from: IndexPath
    let to: IndexPath

    public static func == (lhs: MovedIndexPath, rhs: MovedIndexPath) -> Bool {
        return (lhs.from == rhs.from && lhs.to == rhs.to)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(from)
        hasher.combine(to)
    }
}

public struct MovedSection: Equatable, Hashable {
    let from: Int
    let to: Int

    public static func == (lhs: MovedSection, rhs: MovedSection) -> Bool {
        return (lhs.from == rhs.from && lhs.to == rhs.to)
    }

    public var hashValue: Int {
        return from * 13753 + to
    }
}

/**
 List diff algorithm implementation class

 - moved
    - only if pairs exchange, otherwise it will be moved automatically after insert/delete
    - only changes in ascending order: 0,2 => 2,0
 
 */
 public class CZListDiff: NSObject {
    /// RowDiffResultKey for Rows
    public enum RowDiffResultKey: Int, CaseCountable {
        case deleted = 0, unchanged, moved, updated, inserted
        static var allEnums: [RowDiffResultKey] {
            var res = [RowDiffResultKey](), i = 0
            while let item = RowDiffResultKey(rawValue: i) {
                res.append(item)
                i += 1
            }
            return res
        }
    }

    /// RowDiffResultKey for Sections
    public enum SectionDiffResultKey: Int, CaseCountable {
        case deletedSections = 0, unchangedSections, movedSections, updatedSections, insertedSections
        static var allEnums: [SectionDiffResultKey] {
            var res = [SectionDiffResultKey](), i = 0
            while let item = SectionDiffResultKey(rawValue: i) {
                res.append(item)
                i += 1
            }
            return res
        }
    }

    /// Compare current/previous SectionModels, output diffing sections/rows
    public typealias SectionModelsDiffResult = (sections: [SectionDiffResultKey: [CZSectionModel]], rows: [RowDiffResultKey: [CZFeedModel]])

    private static func diffSectionModels(current: [CZSectionModel],
                                          prev: [CZSectionModel]) -> (sections: [SectionDiffResultKey: [CZSectionModel]], rows: [RowDiffResultKey: [CZFeedModel]]) {
        let currFeedModels = [CZFeedModel](current.flatMap({$0.feedModels}))
        let prevFeedModels = [CZFeedModel](prev.flatMap({$0.feedModels}))

        // Pre-calculate diffing results on FeedModel level
        let rowsDiff: [RowDiffResultKey: [CZFeedModel]] = self.diffFeedModels(current: currFeedModels, prev: prevFeedModels)
        var sectionsDiff = [SectionDiffResultKey: [CZSectionModel]]()

        //=================================================================================
        // Sections Diffing
        //=================================================================================

        // `inserted` - none of FeedModels in current section exists in prev sections
        let insertedSections = current.filter { currSectionModel in
            !currSectionModel.feedModels.contains { currFeedModel in
                prevFeedModels.contains { prevFeedModel in
                    prevFeedModel.isEqual(toDiffableObj: currFeedModel)
                }
            }
        }
        sectionsDiff[.insertedSections] = insertedSections
                                                
        // `deleted` - none of FeedModels in prev section exists in current sections
        let deletedSections = prev.filter { prevSectionModel in
            !prevSectionModel.feedModels.contains{ prevFeedModel in
                currFeedModels.contains { currFeedModel in
                    currFeedModel.isEqual(toDiffableObj: prevFeedModel)
                }
            }
        }
        sectionsDiff[.deletedSections] = deletedSections

        // `unchanged`
        var unchangedSections = [CZSectionModel]()
                                                
        // `moved` - meet 2 conditions:
        // 1) prev/curr SectionModel equals
        // 2) index changes
        var movedSections = [CZSectionModel]()
        for (index, currSectionModel) in current.enumerated() {
            if let oldIndex = prev.index(where: { $0.isEqual(toDiffableObj: currSectionModel)}) {
                if index == oldIndex {
                    unchangedSections.append(currSectionModel)
                } else {
                    movedSections.append(currSectionModel)
                }
            }
        }
        sectionsDiff[.unchangedSections] = unchangedSections
        sectionsDiff[.movedSections] = movedSections

        return (sectionsDiff, rowsDiff)
    }

     public static func diffFeedModels<FeedModelType: CZFeedModelable>(current currFeedModels: [FeedModelType],
                                                                       prev prevFeedModels: [FeedModelType]) -> [RowDiffResultKey: [FeedModelType]] {
        var rowsDiff = [RowDiffResultKey: [FeedModelType]]()

        //=================================================================================
        // Rows Diffing
        //=================================================================================

        // `deleted` - prev FeedModel doesn't exists in current FeedModels
        let removedModels = prevFeedModels.filter { oldFeedModel in
            !currFeedModels.contains { $0.viewModel.diffId == oldFeedModel.viewModel.diffId }
        }
        rowsDiff[.deleted] = removedModels

        // `unchanged` - FeedModel with same id in prev/curr FeedModels equals
        let unchangedModels = currFeedModels.filter { newFeedModel in
            prevFeedModels.contains {
                $0.viewModel.diffId == newFeedModel.viewModel.diffId &&
                $0.isEqual(toDiffableObj: newFeedModel) }
        }
        rowsDiff[.unchanged] = unchangedModels

        // `updated` - FeedModel with same id in prev/curr FeedModels doesn't equal
        let updatedModels = currFeedModels.filter { newFeedModel in
            prevFeedModels.contains {
                $0.viewModel.diffId == newFeedModel.viewModel.diffId &&
                !$0.isEqual(toDiffableObj: newFeedModel) }
        }
        rowsDiff[.updated] = updatedModels

        // `inserted` - current FeedModel doesn't exist in prev FeedModels
        let insertedModels = currFeedModels.filter { newFeedModel in
            !prevFeedModels.contains { $0.viewModel.diffId == newFeedModel.viewModel.diffId }
        }
        rowsDiff[.inserted] = insertedModels

        return rowsDiff
    }

    public static func validatedMovedSections(_ sections: [MovedSection]) -> [MovedSection] {
        return sections
    }
    
    public static func validatedMovedIndexPathes(_ movedIndexPathes: [MovedIndexPath]) -> [MovedIndexPath] {
        return movedIndexPathes
    }
    
    // MARK: - Diff function returns IndexPaths/IndexSet
    public typealias SectionIndexDiffResult = (sections: [SectionDiffResultKey: Any], rows: [RowDiffResultKey: [Any]])
    
    /// Compare prev/current SectionModels, output section/row diffing indexes
    ///
    /// - Parameters:
    ///   - current     : current SectionModels
    ///   - prev        : prev SectionModels
    /// - Returns       : Tuple - (sectionDiffIndexesMap, rowDiffIndexesMap)
    public static func diffSectionModelIndexes(current: [CZSectionModel], prev: [CZSectionModel]) -> SectionIndexDiffResult {
        var sectionsDiff: [SectionDiffResultKey: Any] = [:]
        var rowsDiff: [RowDiffResultKey: [Any]] = [:]
        let modelsDiffRes: SectionModelsDiffResult  = diffSectionModels(current: current, prev: prev)
        let sectionModelsDiffRes = modelsDiffRes.sections
        let rowModelsDiffRes = modelsDiffRes.rows

        /*- Sections Diff -*/
        var insertedSections: IndexSet? = nil
        var deletedSections: IndexSet? = nil
        
        // deleted
        if let deletedSectionModels = sectionModelsDiffRes[.deletedSections] {
            deletedSections = IndexSet(deletedSectionModels.compactMap {sectionModel in
                prev.index(where: { $0.isEqual(toDiffableObj: sectionModel) })
            })
            sectionsDiff[.deletedSections] = deletedSections
        }

        // moved
        if let movedSections = sectionModelsDiffRes[.movedSections] {
            let res: [MovedSection] = movedSections.compactMap {sectionModel in
                let oldIndex = prev.index(where: { $0.isEqual(toDiffableObj: sectionModel) })!
                let newIndex = current.index(where: { $0.isEqual(toDiffableObj: sectionModel) })!
                return MovedSection(from: oldIndex, to: newIndex)
            }
            sectionsDiff[.movedSections] = validatedMovedSections(res)
        }

        // inserted
        if let insertedSectionModels = sectionModelsDiffRes[.insertedSections] {
            insertedSections = IndexSet(insertedSectionModels.compactMap {sectionModel in
                current.index(where: { $0.isEqual(toDiffableObj: sectionModel) })
            })
            sectionsDiff[.insertedSections] = insertedSections
        }

        /*- Rows Diff -*/

        // deleted
        rowsDiff[.deleted] = rowModelsDiffRes[.deleted]?.compactMap({
            indexPath(forFeedModel: $0, inSectionModels: prev)
        }).filter({
            // exclude "deletedSection" elements
            guard let deletedSections = deletedSections, let indexPath = $0 as? IndexPath else {return true}
            return !deletedSections.contains(indexPath.section)
        })

        // unchanged
        rowsDiff[.unchanged] = rowModelsDiffRes[.unchanged]?.compactMap {
            // exclude "moved"
            guard movedIndexPath(forFeedModel: $0, oldSectionModels: prev, newSectionModels: current) == nil else {return nil}
            return indexPath(forFeedModel: $0, inSectionModels: current)
        }

        // moved
        let unchanged = rowModelsDiffRes[.unchanged] ?? []
        let updated = rowModelsDiffRes[.updated] ?? []
        let movedRows = [unchanged, updated].joined().compactMap {
            movedIndexPath(forFeedModel: $0, oldSectionModels: prev, newSectionModels: current)
            }.filter({
                // exclude "inserted" section
                guard let insertedSections = insertedSections else { return true }
                return !insertedSections.contains($0.to.section)
            })
        rowsDiff[.moved] = validatedMovedIndexPathes(movedRows)

        // updated
        rowsDiff[.updated] = rowModelsDiffRes[.updated]?.compactMap ({
            indexPath(forFeedModel: $0, inSectionModels: current)
        }).filter({
            // exclude "moved" rows
            guard let indexPath = $0 as? IndexPath, let movedItems = rowsDiff[.moved] as? [MovedIndexPath] else {return true}
            return !movedItems.contains(where: {$0.to == indexPath})
        })

        // inserted
        rowsDiff[.inserted] = rowModelsDiffRes[.inserted]?.compactMap ({
            indexPath(forFeedModel: $0, inSectionModels: current)
        }).filter({
            // exclude "inserted" section
            guard let insertedSections = insertedSections, let indexPath = $0 as? IndexPath else {return true}
            return !insertedSections.contains(indexPath.section)
        })

        let sectionIndexDiffResult = (sectionsDiff, rowsDiff)
        CZListDiff.prettyPrint(sectionIndexDiffResult: sectionIndexDiffResult)
        return sectionIndexDiffResult
    }

    public static func sectionCount(for sectionDiffValue: Any?) -> Int {
        if let section = sectionDiffValue as? IndexSet {
            return section.count
        } else if let section = sectionDiffValue as? [MovedSection] {
            return section.count
        } else {
            return 0
        }
    }

    private static func movedIndexPath<FeedModelType: CZFeedModelable>
                                          (forFeedModel feedModel: FeedModelType,
                                           oldSectionModels: [CZSectionModel],
                                           newSectionModels: [CZSectionModel]) -> MovedIndexPath? {
        if let oldIndexPath = indexPath(forFeedModel: feedModel, inSectionModels: oldSectionModels),
            let newIndexPath = indexPath(forFeedModel: feedModel, inSectionModels: newSectionModels),
            oldIndexPath != newIndexPath {
            return MovedIndexPath(from: oldIndexPath, to: newIndexPath)
        }
        return nil
    }

    private static func indexPath<FeedModelType: CZFeedModelable>
                                      (forFeedModel feedModel: FeedModelType,
                                      inSectionModels sectionModels: [CZSectionModel]) -> IndexPath? {
        for (i, sectionModel) in sectionModels.enumerated() {
            if let row = sectionModel.feedModels.index(where: { feedModel.isEqual(toDiffableObj: $0) }) {
                return IndexPath(row: row, section: i)
            }
        }
        return nil
    }
    
    private static func prettyPrint(sectionIndexDiffResult: SectionIndexDiffResult) {
        let sectionsDiff = sectionIndexDiffResult.sections
        let rowsDiff = sectionIndexDiffResult.rows

        // Print count of items
        dbgPrint("\n******************************\nFeedListFacadeView DiffResult\n******************************")
        SectionDiffResultKey.allEnums.forEach { dbgPrint("\($0): \(sectionCount(for: sectionsDiff[$0])); ") }
        dbgPrint("**************************")
        RowDiffResultKey.allEnums.forEach { dbgPrint("\($0): \(rowsDiff[$0]?.count ?? 0); ") }
        dbgPrint("**************************")

        // Print model of items
        SectionDiffResultKey.allEnums.forEach {
            dbgPrint("\($0): \(PrettyString(sectionsDiff[$0] ?? [])); ")
        }
        dbgPrint("**************************")
        RowDiffResultKey.allEnums.forEach { dbgPrint("\($0): \(PrettyString(rowsDiff[$0] ?? [])); ") }
        dbgPrint("**************************")
    }
}

/// Protocol for enum providing the count of enumation
public protocol CaseCountable {
    static func countCases() -> Int
}

// Provide default implementation to count the cases for Int enums assuming starting at 0 and contiguous
extension CaseCountable where Self : RawRepresentable, Self.RawValue == Int {
    // count the number of cases in the enum
    public static func countCases() -> Int {
        // starting at zero, verify whether the enum can be instantiated from the Int and increment until it cannot
        var count = 0
        while let _ = Self(rawValue: count) { count += 1 }
        return count
    }
}


