//
//  ViewController.swift
//  CZUtilsDemo
//
//  Created by Cheng Zhang on 9/27/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit
import CZUtils

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        testThreadSafeDictionaryWithGCD()
    }
}

fileprivate extension ViewController {
    func testThreadSafeDictionaryWithGCD() {
        var originalDict = [Int: Int]()
        for (i, value) in (0..<10).enumerated() {
            originalDict[i] = value
        }
        
        let threadSafeDict = ThreadSafeDictionary<Int, Int>()
        for (key, value) in originalDict {
            threadSafeDict[key] = value
        }
        print(threadSafeDict)
        
        assert(threadSafeDict.isEqual(toDictionary: originalDict))
        
    }
    
    func testThreadSafeDictionary() {
        var originalDict = [Int: Int]()
        for (i, value) in (0..<10).enumerated() {
            originalDict[i] = value
        }
        
        let threadSafeDict = ThreadSafeDictionary<Int, Int>()
        for (key, value) in originalDict {
            threadSafeDict[key] = value
        }
        print(threadSafeDict)
        
        assert(threadSafeDict.isEqual(toDictionary: originalDict))
        
    }
}

