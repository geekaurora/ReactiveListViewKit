//
//  ListDiffTests.swift
//  ReactiveListViewKitTests
//
//  Created by Cheng Zhang on 3/15/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import XCTest
@testable import ReactiveListViewKit

/**
  Unit tests of list diff algorithm
 */
class ListDiffTests: XCTestCase {

    func testInsertRow() {
        var currSectionModels = [CZSectionModel]()

        // Insert section at 0
        var prevSectionModels = currSectionModels
        var feedModels = (0..<1).map { CZFeedModel(viewClass: CZTextFeedCell.self, viewModel: CZTextFeedViewModel(text: String($0))) }
        currSectionModels = [CZSectionModel(feedModels: feedModels)]
        var actual = CZListDiff.diffSectionModelIndexes(current: currSectionModels, prev: prevSectionModels)
        var expected = CZListDiff.emptyDiffSectionModelIndexes
        expected.sections[.insertedSections] = IndexSet([0])
        verifyDiffResult(actual: actual, expected: expected)

        // Insert row at (0, 1)
        prevSectionModels = currSectionModels
        feedModels = (0..<2).map { CZFeedModel(viewClass: CZTextFeedCell.self, viewModel: CZTextFeedViewModel(text: String($0))) }
        currSectionModels = [CZSectionModel(feedModels: feedModels)]
        actual = CZListDiff.diffSectionModelIndexes(current: currSectionModels, prev: prevSectionModels)
        expected = CZListDiff.emptyDiffSectionModelIndexes
        expected.rows[.inserted] = (1..<2).map { IndexPath(row: $0, section: 0) }
        verifyDiffResult(actual: actual, expected: expected)

        // Insert row at (0, 2..<20)
        prevSectionModels = currSectionModels
        feedModels = (0..<20).map { CZFeedModel(viewClass: CZTextFeedCell.self, viewModel: CZTextFeedViewModel(text: String($0))) }
        currSectionModels = [CZSectionModel(feedModels: feedModels)]
        actual = CZListDiff.diffSectionModelIndexes(current: currSectionModels, prev: prevSectionModels)
        expected = CZListDiff.emptyDiffSectionModelIndexes
        expected.rows[.inserted] = (2..<20).map { IndexPath(row: $0, section: 0) }
        verifyDiffResult(actual: actual, expected: expected)
    }

    func testDeleteRow() {
        var feedModels = (0..<20).map { CZFeedModel(viewClass: CZTextFeedCell.self, viewModel: CZTextFeedViewModel(text: String($0))) }
        var currSectionModels = [CZSectionModel]()

        // Insert section at 0
        var prevSectionModels = currSectionModels
        currSectionModels = [CZSectionModel(feedModels: feedModels)]
        var actual = CZListDiff.diffSectionModelIndexes(current: currSectionModels, prev: prevSectionModels)
        var expected = CZListDiff.emptyDiffSectionModelIndexes
        expected.sections[.insertedSections] = IndexSet([0])
        verifyDiffResult(actual: actual, expected: expected)

        // Delete row at (0, 19)
        prevSectionModels = currSectionModels
        feedModels = (0..<19).map { CZFeedModel(viewClass: CZTextFeedCell.self, viewModel: CZTextFeedViewModel(text: String($0))) }
        currSectionModels = [CZSectionModel(feedModels: feedModels)]
        actual = CZListDiff.diffSectionModelIndexes(current: currSectionModels, prev: prevSectionModels)
        expected = CZListDiff.emptyDiffSectionModelIndexes
        expected.rows[.deleted] = (19..<20).map { IndexPath(row: $0, section: 0) }
        verifyDiffResult(actual: actual, expected: expected)

        // Delete rows at (0, 1..<19)
        prevSectionModels = currSectionModels
        feedModels = (0..<1).map { CZFeedModel(viewClass: CZTextFeedCell.self, viewModel: CZTextFeedViewModel(text: String($0))) }
        currSectionModels = [CZSectionModel(feedModels: feedModels)]
        actual = CZListDiff.diffSectionModelIndexes(current: currSectionModels, prev: prevSectionModels)
        expected = CZListDiff.emptyDiffSectionModelIndexes
        expected.rows[.deleted] = (1..<19).map { IndexPath(row: $0, section: 0) }
        verifyDiffResult(actual: actual, expected: expected)
    }

    func testUpdateRow() {
        var feedModels = (0..<6).map { CZFeedModel(
            viewClass: CZTextFeedCell.self,
            viewModel: CZTextFeedViewModel(diffId: String($0), text: String($0)))
        }
        var currSectionModels = [CZSectionModel]()

        // Insert section at 0
        var prevSectionModels = currSectionModels
        currSectionModels = [CZSectionModel(feedModels: feedModels)]
        var actual = CZListDiff.diffSectionModelIndexes(current: currSectionModels, prev: prevSectionModels)
        var expected = CZListDiff.emptyDiffSectionModelIndexes
        expected.sections[.insertedSections] = IndexSet([0])
        verifyDiffResult(actual: actual, expected: expected)

        // Update row (0, 0)
        prevSectionModels = currSectionModels
        feedModels[0] = CZFeedModel(
            viewClass: CZTextFeedCell.self,
            viewModel: CZTextFeedViewModel(diffId: "0", text: "updated row 0"))
        currSectionModels = [CZSectionModel(feedModels: feedModels)]
        actual = CZListDiff.diffSectionModelIndexes(current: currSectionModels, prev: prevSectionModels)
        expected = CZListDiff.emptyDiffSectionModelIndexes
        expected.rows[.updated] = [IndexPath(row: 0, section: 0)]
        verifyDiffResult(actual: actual, expected: expected)

        // Update row (0, 2), (0, 4), (0, 5)
        prevSectionModels = currSectionModels
        [2, 4, 5].forEach {
            feedModels[$0] = CZFeedModel(
                viewClass: CZTextFeedCell.self,
                viewModel: CZTextFeedViewModel(diffId: String($0), text: "updated row \($0)"))
        }
        currSectionModels = [CZSectionModel(feedModels: feedModels)]
        actual = CZListDiff.diffSectionModelIndexes(current: currSectionModels, prev: prevSectionModels)
        expected = CZListDiff.emptyDiffSectionModelIndexes
        expected.rows[.updated] = [2, 4, 5].map { IndexPath(row: $0, section: 0) }
        verifyDiffResult(actual: actual, expected: expected)
    }

    func testMoveRow() {
        var feedModels = [0, 1, 2, 3, 4, 5, 6].map { CZFeedModel(viewClass: CZTextFeedCell.self, viewModel: CZTextFeedViewModel(text: String($0))) }
        var currSectionModels = [CZSectionModel]()

        // Insert section at 0
        var prevSectionModels = currSectionModels
        currSectionModels = [CZSectionModel(feedModels: feedModels)]
        var actual = CZListDiff.diffSectionModelIndexes(current: currSectionModels, prev: prevSectionModels)
        var expected = CZListDiff.emptyDiffSectionModelIndexes
        expected.sections[.insertedSections] = IndexSet([0])
        verifyDiffResult(actual: actual, expected: expected)

        // TODO: move should be only counted once
        // Move row from (0, 6) to (0, 5)
        prevSectionModels = currSectionModels
        feedModels = [0, 1, 2, 3, 4, 6, 5].map { CZFeedModel(viewClass: CZTextFeedCell.self, viewModel: CZTextFeedViewModel(text: String($0))) }
        currSectionModels = [CZSectionModel(feedModels: feedModels)]
        actual = CZListDiff.diffSectionModelIndexes(current: currSectionModels, prev: prevSectionModels)
        expected = CZListDiff.emptyDiffSectionModelIndexes
        expected.rows[.moved] = [MovedIndexPath(from: IndexPath(row: 5, section: 0), to: IndexPath(row: 6, section: 0)),
                                 MovedIndexPath(from: IndexPath(row: 6, section: 0), to: IndexPath(row: 5, section: 0))]
        verifyDiffResult(actual: actual, expected: expected)
    }

    func testInsertSection() {
        var currSectionModels = [CZSectionModel]()
        var prevSectionModels = currSectionModels

        // Insert section at 0
        currSectionModels.append(CZSectionModel(feedModels: []))
        var actual = CZListDiff.diffSectionModelIndexes(current: currSectionModels, prev: prevSectionModels)
        var expected = CZListDiff.emptyDiffSectionModelIndexes
        expected.sections[.insertedSections] = IndexSet([0])
        verifyDiffResult(actual: actual, expected: expected)
    }

    func testDeleteSection() {
        var currSectionModels = [CZSectionModel(feedModels: [])]
        var prevSectionModels = currSectionModels

        // Deleted section at 0
        currSectionModels.remove(at: 0)
        var actual = CZListDiff.diffSectionModelIndexes(current: currSectionModels, prev: prevSectionModels)
        var expected = CZListDiff.emptyDiffSectionModelIndexes
        expected.sections[.deletedSections] = IndexSet([0])
        verifyDiffResult(actual: actual, expected: expected)
    }

    func testMoveSection() {
        let ItemsCount = 3
        var currSectionModels = [CZSectionModel]()

        // Insert section at 0
        var prevSectionModels = currSectionModels
        currSectionModels = [0, 1, 2, 3, 4, 5].map {
            let start = $0 * ItemsCount
            let end = start + ItemsCount
            let feedModels = (start..<end).map { CZFeedModel(viewClass: CZTextFeedCell.self, viewModel: CZTextFeedViewModel(text: String($0))) }
            return CZSectionModel(feedModels: feedModels)
        }
        var actual = CZListDiff.diffSectionModelIndexes(current: currSectionModels, prev: prevSectionModels)
        var expected = CZListDiff.emptyDiffSectionModelIndexes
        expected.sections[.insertedSections] = IndexSet([0, 1, 2, 3, 4, 5])
        verifyDiffResult(actual: actual, expected: expected)

        // Move section from 0 to 1
        prevSectionModels = currSectionModels
        currSectionModels = [1, 0, 2, 3, 4, 5].map {
            let start = $0 * ItemsCount
            let end = start + ItemsCount
            let feedModels = (start..<end).map { CZFeedModel(viewClass: CZTextFeedCell.self, viewModel: CZTextFeedViewModel(text: String($0))) }
            return CZSectionModel(feedModels: feedModels)
        }
        actual = CZListDiff.diffSectionModelIndexes(current: currSectionModels, prev: prevSectionModels)
        expected = CZListDiff.emptyDiffSectionModelIndexes

        let movedSections = [MovedSection(from: 0, to: 1), MovedSection(from: 1, to: 0)]
        var movedRows = [MovedIndexPath]()
        movedSections.forEach { movedSection in
            let currResult = (0..<ItemsCount).map { row in
                MovedIndexPath(from: IndexPath(row: row, section: movedSection.from), to: IndexPath(row: row, section: movedSection.to))
            }
            movedRows += currResult
        }
        expected.rows[.moved] = movedRows
        verifyDiffResult(actual: actual, expected: expected)
    }
}

// MARK: - Private methods

private extension ListDiffTests {
    func verifyDiffResult(actual: CZListDiff.SectionIndexDiffResult, expected: CZListDiff.SectionIndexDiffResult) {
        /**
         Rows diff
         */
        // inserted rows
        let actualInsertedRows = actual.rows[.inserted] as? [IndexPath] ?? []
        let expectedInsertedRows = expected.rows[.inserted] as? [IndexPath] ?? []
        XCTAssert(
            Set(actualInsertedRows) == Set(expectedInsertedRows),
            "Inserted rows mismatch: actualInsertedRows = \(actualInsertedRows); expectedInsertedRows = \(expectedInsertedRows)")

        // deleted rows
        let actualDeletedRows = actual.rows[.deleted] as? [IndexPath] ?? []
        let expectedDeletedRows = expected.rows[.deleted] as? [IndexPath] ?? []
        XCTAssert(
            Set(actualDeletedRows) == Set(expectedDeletedRows),
            "Deleted rows mismatch: actualDeletedRows = \(actualDeletedRows); expectedDeletedRows = \(expectedDeletedRows)")

        // updated rows
        let actualUpdatedRows = actual.rows[.updated] as? [IndexPath] ?? []
        let expectedUpdatedRows = expected.rows[.updated] as? [IndexPath] ?? []
        XCTAssert(
            Set(actualUpdatedRows) == Set(expectedUpdatedRows),
            "Updated rows mismatch: actualUpdatedRows = \(actualUpdatedRows); expectedUpdatedRows = \(expectedUpdatedRows)")

        // moved rows
        let actualMovedRows: [MovedIndexPath] = actual.rows[.moved] as? [MovedIndexPath] ?? []
        let expectedMovedRows: [MovedIndexPath] = expected.rows[.moved] as? [MovedIndexPath] ?? []
        XCTAssert(
            Set(actualMovedRows) == Set(expectedMovedRows),
            "Moved rows mismatch: actualMovedRows = \(actualMovedRows); expectedMovedRows = \(expectedMovedRows)")

        /**
         Sections diff
         */
        // inserted sections
        let actualInsertedSections = (actual.sections[.insertedSections] as? IndexSet ?? IndexSet())
        let expectedInsertedSections = (expected.sections[.insertedSections] as? IndexSet ?? IndexSet())
        XCTAssert(
            actualInsertedSections == expectedInsertedSections,
            "Inserted sections mismatch: actualInsertedSections = \(actualInsertedSections); expectedInsertedSections = \(expectedInsertedSections)")

        // deleted sections
        let actualDeletedSections = (actual.sections[.deletedSections] as? IndexSet ?? IndexSet())
        let expectedDeletedSections = (expected.sections[.deletedSections] as? IndexSet ?? IndexSet())
        XCTAssert(
            actualDeletedSections == expectedDeletedSections,
            "sections DeletedSections mismatched: actualDeletedSections = \(actualDeletedSections); expectedDeletedSections = \(expectedDeletedSections)")
    }
}
