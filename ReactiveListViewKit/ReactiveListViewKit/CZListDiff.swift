//
//  CZListDiff.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 1/5/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit

public struct MovedIndexPath {
    let from: IndexPath
    let to: IndexPath
}

public struct MovedSection {
    let from: Int
    let to: Int
}

/// List diff algorithm implementation class
///
/// - Moved:
///    - Only pairs exchange? Otherwise it will be moved automatically after insert/delete
///    - Only change ascending order: 0,2=>2, 0
 public class CZListDiff: NSObject {
    public enum ResultKey: Int, CaseCountable {
        case deleted = 0, unchanged, moved, updated, inserted // Rows
        static var allEnums: [ResultKey] {
            var res = [ResultKey](), i = 0
            while let item = ResultKey(rawValue: i) {
                res.append(item)
                i += 1
            }
            return res
        }
    }
    public enum SectionResultKey: Int, CaseCountable {
        case deletedSections = 0, unchangedSections, movedSections, updatedSections, insertedSections // Sections
        static var allEnums: [SectionResultKey] {
            var res = [SectionResultKey](), i = 0
            while let item = SectionResultKey(rawValue: i) {
                res.append(item)
                i += 1
            }
            return res
        }
    }

    /// Compare current/prev CZSectionModels and output different sections/rows based on Model
    public typealias SectionModelsDiffResult = (sections: [SectionResultKey: [CZSectionModel]], rows: [ResultKey: [CZFeedModel]])
    fileprivate static func diffSectionModels(current: [CZSectionModel],
                                              prev: [CZSectionModel]) ->
                                             (sections: [SectionResultKey: [CZSectionModel]], rows: [ResultKey: [CZFeedModel]]) {
        let currentFeedModels = [CZFeedModel](current.flatMap({$0.feedModels}))
        let prevFeedModels = [CZFeedModel](prev.flatMap({$0.feedModels}))
        let rowsDiff: [ResultKey: [CZFeedModel]] = diffFeedModels(current: currentFeedModels, prev: prevFeedModels)

        var sectionsDiff = [SectionResultKey: [CZSectionModel]]()

        /** Sections Diff **/
        // inserted
        // FeedModels in current's whole section doesn't exist in prev sectionModels
        let insertedSections = current.filter { currSectionModel in
            !currSectionModel.feedModels.contains{ currSectionFeedModel in
                prevFeedModels.contains { prevFeedModel in
                    prevFeedModel.isEqual(toDiffableObj: currSectionFeedModel)
                }
            }
        }
        sectionsDiff[.insertedSections] = insertedSections
                                                
        // deleted
        // FeedModels in prev's whole section doesn't exist in current sectionModels
        let deletedSections = prev.filter { prevSectionModel in
            !prevSectionModel.feedModels.contains{ prevSectionFeedModel in
                currentFeedModels.contains { currFeedModel in
                    currFeedModel.isEqual(toDiffableObj: prevSectionFeedModel)
                }
            }
        }
        sectionsDiff[.deletedSections] = deletedSections

        // unchanged
        var unchangedSections = [CZSectionModel]()
                                                
        // moved
        // 1) Content doesn't change 2) index changes
        var movedSections = [CZSectionModel]()
        for (i, currSectionModel) in current.enumerated() {
            if let oldIndex = prev.index(where: { $0.isEqual(toDiffableObj: currSectionModel)}) {
                if i == oldIndex {
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

     public static func diffFeedModels<FeedModelType: CZFeedModelable>(current currentFeedModels: [FeedModelType],
                                                                prev prevFeedModels: [FeedModelType]) -> [ResultKey: [FeedModelType]] {
        var rowsDiff = [ResultKey: [FeedModelType]]()

        /** Rows Diff **/
        // Deleted
        let removedModels = prevFeedModels.filter{ oldFeedModel in
            !currentFeedModels.contains { $0.viewModel.diffId == oldFeedModel.viewModel.diffId }
        }
        rowsDiff[.deleted] = removedModels

        // Unchanged
        let unchangedModels = currentFeedModels.filter{ newFeedModel in
            prevFeedModels.contains {
                $0.viewModel.diffId == newFeedModel.viewModel.diffId &&
                $0.isEqual(toDiffableObj: newFeedModel) }
        }
        rowsDiff[.unchanged] = unchangedModels

        // Updated
        let updatedModels = currentFeedModels.filter{ newFeedModel in
            prevFeedModels.contains {
                $0.viewModel.diffId == newFeedModel.viewModel.diffId &&
                !$0.isEqual(toDiffableObj: newFeedModel) }
        }
        rowsDiff[.updated] = updatedModels

        // Inserted
        let insertedModels = currentFeedModels.filter{ newFeedModel in
            !prevFeedModels.contains {
                $0.viewModel.diffId == newFeedModel.viewModel.diffId
            }
        }
        rowsDiff[.inserted] = insertedModels

        return rowsDiff
    }

    // moved items should build a circle: fromSet == toSet
    // NO: from is based on prevSections, to is basedon currentSections
    public static func validatedMovedSections(_ sections: [MovedSection]) -> [MovedSection] {
        return sections
//        let fromIndexSet = Set(sections.flatMap {$0.from})
//        let toIndexSet = Set(sections.flatMap {$0.to})
//        let intersectionSet = fromIndexSet.intersection(toIndexSet)
//        let res = sections.filter {
//            intersectionSet.contains($0.from) || intersectionSet.contains($0.to)
//        }
//        return res
    }
    
    public static func validatedMovedIndexPathes(_ movedIndexPathes: [MovedIndexPath]) -> [MovedIndexPath] {
        return movedIndexPathes
    }
    
    // MARK: - Diff function returns IndexPaths/IndexSet
    /// Return tuple: (sectionDiff, rowDiff)
    public typealias SectionIndexDiffResult = (sections: [SectionResultKey: Any], rows: [ResultKey: [Any]])
    public static func diffSectionModels(current: [CZSectionModel], prev: [CZSectionModel]) -> SectionIndexDiffResult {
        var sectionsDiff: [SectionResultKey: Any] = [:]
        var rowsDiff: [ResultKey: [Any]] = [:]
        let modelsDiffRes: SectionModelsDiffResult  = diffSectionModels(current: current, prev: prev)
        let sectionModelsDiffRes = modelsDiffRes.sections
        let rowModelsDiffRes = modelsDiffRes.rows

        /** Sections Diff **/
        var insertedSections: IndexSet? = nil
        var deletedSections: IndexSet? = nil
        if let deletedSectionModels = sectionModelsDiffRes[.deletedSections] {
            // deleted
            deletedSections = IndexSet(deletedSectionModels.flatMap {sectionModel in
                prev.index(where: { $0.isEqual(toDiffableObj: sectionModel) })
            })
            sectionsDiff[.deletedSections] = deletedSections
        }

        // moved
        if let movedSections = sectionModelsDiffRes[.movedSections] {
            let res: [MovedSection] = movedSections.flatMap {sectionModel in
                let oldIndex = prev.index(where: { $0.isEqual(toDiffableObj: sectionModel) })!
                let newIndex = current.index(where: { $0.isEqual(toDiffableObj: sectionModel) })!
                return MovedSection(from: oldIndex, to: newIndex)
            }
            sectionsDiff[.movedSections] = validatedMovedSections(res)
        }

        if let insertedSectionModels = sectionModelsDiffRes[.insertedSections] {
            // inserted
            insertedSections = IndexSet(insertedSectionModels.flatMap {sectionModel in
                current.index(where: { $0.isEqual(toDiffableObj: sectionModel) })
            })
            sectionsDiff[.insertedSections] = insertedSections
        }

        /** Rows Diff **/
        // deleted
        rowsDiff[.deleted] = rowModelsDiffRes[.deleted]?.flatMap({
            indexPath(forFeedModel: $0, inSectionModels: prev)
        }).filter({// Excludes "deletedSection" elements
            guard let deletedSections = deletedSections, let indexPath = $0 as? IndexPath else {return true}
            return !deletedSections.contains(indexPath.section)
        })

        // unchanged
        rowsDiff[.unchanged] = rowModelsDiffRes[.unchanged]?.flatMap { // Exclude "moved"
            guard movedIndexPath(forFeedModel: $0, oldSectionModels: prev, newSectionModels: current) == nil else {return nil}
            return indexPath(forFeedModel: $0, inSectionModels: current)
        }

        // moved
        let unchanged = rowModelsDiffRes[.unchanged] ?? []
        let updated = rowModelsDiffRes[.updated] ?? []
        let movedRows = [unchanged, updated].joined().flatMap {
            movedIndexPath(forFeedModel: $0, oldSectionModels: prev, newSectionModels: current)
            }.filter({// Excludes "inserted" section
                guard let insertedSections = insertedSections else {
                        return true
                }
                return !insertedSections.contains($0.to.section)
            })
        rowsDiff[.moved] = validatedMovedIndexPathes(movedRows)

        // updated
        rowsDiff[.updated] = rowModelsDiffRes[.updated]?.flatMap ({
            indexPath(forFeedModel: $0, inSectionModels: current)
        }).filter({//Exclude "moved" rows
            guard let indexPath = $0 as? IndexPath, let movedItems = rowsDiff[.moved] as? [MovedIndexPath] else {return true}
            return !movedItems.contains(where: {$0.to == indexPath})
        })

        // inserted
        rowsDiff[.inserted] = rowModelsDiffRes[.inserted]?.flatMap ({
            indexPath(forFeedModel: $0, inSectionModels: current)
        }).filter({// Excludes "inserted" section
            guard let insertedSections = insertedSections, let indexPath = $0 as? IndexPath else {return true}
            return !insertedSections.contains(indexPath.section)
        })

        print("\n******************************\nCZFeedListView DiffResult\n******************************")
        SectionResultKey.allEnums.forEach { print("\($0): \(sectionCount(for: sectionsDiff[$0])); ") }
        print("**************************")
        ResultKey.allEnums.forEach { print("\($0): \(rowsDiff[$0]?.count ?? 0); ") }
        print("**************************")
        
        SectionResultKey.allEnums.forEach { print("\($0): \(sectionsDiff[$0] ?? []); ") }
        print("**************************")
        ResultKey.allEnums.forEach { print("\($0): \(rowsDiff[$0] ?? []); ") }
        print("**************************")
        return (sectionsDiff, rowsDiff)
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

    fileprivate static func movedIndexPath<FeedModelType: CZFeedModelable>
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

    fileprivate static func indexPath<FeedModelType: CZFeedModelable>
                                      (forFeedModel feedModel: FeedModelType,
                                      inSectionModels sectionModels: [CZSectionModel]) -> IndexPath? {
        for (i, sectionModel) in sectionModels.enumerated() {
            if let row = sectionModel.feedModels.index(where: { feedModel.isEqual(toDiffableObj: $0) }) {
                return IndexPath(row: row, section: i)
            }
        }
        //assertionFailure("Couldn't find matched model \(feedModel)")
        return nil
    }
}

/// Protocol for enum provideing the count of enumation
public protocol CaseCountable {
    static func countCases() -> Int
}

// provide a default implementation to count the cases for Int enums assuming starting at 0 and contiguous
extension CaseCountable where Self : RawRepresentable, Self.RawValue == Int {
    // count the number of cases in the enum
    public static func countCases() -> Int {
        // starting at zero, verify whether the enum can be instantiated from the Int and increment until it cannot
        var count = 0
        while let _ = Self(rawValue: count) { count += 1 }
        return count
    }
}


