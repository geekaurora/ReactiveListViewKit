//
//  CriticalSectionLock.swift
//  CZUtils
//
//  Created by Cheng Zhang on 11/3/15.
//  Copyright © 2015 Cheng Zhang. All rights reserved.
//

import Foundation

/// Convenience mutex lock on top of NSLock
open class CriticalSectionLock: NSLock {
    public func execute<T>(_ execution: () -> T)  -> T {
        lock()
        defer {
            unlock()
        }
        return execution()
    }
}
