//
//  CZListDiff.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 1/5/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import ReactiveListViewKit

 extension CZListDiff {
    /**
     Return empty SectionIndexDiffResult
     */
    public static var emptyDiffSectionModelIndexes: SectionIndexDiffResult {
        let sectionsDiff: [SectionDiffResultKey: Any] = [:]
        let rowsDiff: [RowDiffResultKey: [Any]] = [:]
        return (sectionsDiff, rowsDiff)
    }
}

