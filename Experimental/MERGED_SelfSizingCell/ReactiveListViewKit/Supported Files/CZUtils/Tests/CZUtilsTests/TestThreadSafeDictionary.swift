//
//  TestThreadSafeDictionary.swift
//  CZUtils
//
//  Created by Cheng Zhang on 2/10/16.
//  Copyright © 2016 Cheng Zhang. All rights reserved.
//

import XCTest
@testable import CZUtils

class TestThreadSafeDictionary: XCTestCase {
    private static let queueLabel = "com.tony.test.threadSafeDictionary"
    
    private var originalDict: [Int: Int] = {
        var originalDict = [Int: Int]()
        for (i, value) in (0 ..< 10).enumerated() {
            originalDict[i] = value
        }
        return originalDict
    }()
    
    func testSingleThreadInitializ() {
        let threadSafeDict = ThreadSafeDictionary<Int, Int>(dictionary: originalDict)
        XCTAssert(threadSafeDict.isEqual(toDictionary: originalDict), "Result of ThreadSafeDictionary should same as the original dictionary.")
    }
    
    func testSingleThreadSetValue() {
        let threadSafeDict = ThreadSafeDictionary<Int, Int>()
        for (key, value) in originalDict {
            threadSafeDict[key] = value
        }
        XCTAssert(threadSafeDict.isEqual(toDictionary: originalDict), "Result of ThreadSafeDictionary should same as the original dictionary.")
    }
    
    func testMultiThreadSetValue() {
        // 1. GIVEN(Condition) - some context: Describes the system's tate before any processing
        // Initialize ThreadSafeDictionary
        let threadSafeDict = ThreadSafeDictionary<Int, Int>()
        
        // Concurrent DispatchQueue to simulate multiple-thread read/write executions
        let queue = DispatchQueue(label: TestThreadSafeDictionary.queueLabel,
                                  qos: .userInitiated,
                                  attributes: .concurrent)
        
        // 2. WHEN(Execution) - some action is carried out: Apply some business logic on the given context
        // Group asynchonous write operations by DispatchGroup
        let dispatchGroup = DispatchGroup()
        for (key, value) in originalDict {
            dispatchGroup.enter()
            queue.async {
                // Sleep to simulate operation delay in multiple thread mode
                let sleepInternal = TimeInterval((arc4random() % 10)) * 0.00001
                Thread.sleep(forTimeInterval: sleepInternal)
                threadSafeDict[key] = value
                dispatchGroup.leave()
            }
        }

        // 3. THEN(Assertion) - a particular set of observable consequences should be obtained
        // DispatchGroup: Wait for completion signal of all operations
        dispatchGroup.wait()
        XCTAssert(threadSafeDict.isEqual(toDictionary: self.originalDict), "Result of ThreadSafeDictionary should same as the original dictionary.")
    }
}
