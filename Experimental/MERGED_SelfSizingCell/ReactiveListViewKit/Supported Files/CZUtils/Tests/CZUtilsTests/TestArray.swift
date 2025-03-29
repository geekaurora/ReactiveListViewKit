//
//  TestArray.swift
//  CZUtilsTests
//
//  Created by Cheng Zhang on 7/26/18.
//  Copyright © 2018 Cheng Zhang. All rights reserved.
//

import XCTest
@testable import CZUtils

class TestArray: XCTestCase {
    func testSafeSubscript() {
        let array = [Int](0..<10)

        // Elements within bounds
        [0, 3, 9].forEach { index in
            let element = array[safe: index]
            XCTAssert(element == index, "Unexpected element '\(String(describing: element))' at specified index '\(index)'. Expected value = '\(index)'")
        }

        // Elements out of bounds
        [-1, 10, 13, 20, 1000].forEach { index in
            let element = array[safe: index]
            XCTAssert(element == nil, "Unexpected element '\(String(describing: element))' at specified index '\(index)'. Expected value = nil")
        }
    }
}
