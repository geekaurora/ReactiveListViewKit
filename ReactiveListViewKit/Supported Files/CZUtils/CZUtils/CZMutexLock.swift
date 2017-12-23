//
//  CZMutexLock.swift
//
//  Created by Cheng Zhang on 1/4/16.
//  Copyright © 2016 Cheng Zhang. All rights reserved.
//

import UIKit

/// Multiple thread protector for specified object `item` on top of serial queue sync/barrier methods, `item` can only be read/written inside the protector
///
/// NOTE: Ensure no nested lock operations, which can lead to deadlock crash. e.g. read lock is invoked in write lock
///
public class CZMutexLock<Item>: NSObject {
    fileprivate lazy var lock = CZDispatchReadWriteLock()
    //fileprivate lazy var lock = CZSemaphoreReadWriteLock()

    fileprivate var item: Item

    public init(_ item: Item) {
        self.item = item
    }

    // give read access to "item" to the given block, returning whatever that block returns
    @discardableResult
    public func readLock<Result>(_ block: @escaping (_ item: Item) -> Result?) -> Result? {
        return lock.readLock { [weak self] in
            guard let `self` = self else {
                assertionFailure("self was deallocated!")
                return nil
            }
            return block(self.item)
        }
    }

    // give write access to "item" to the given block, returning whatever that block returns
    @discardableResult
    public func writeLock<Result>(_ block: @escaping (_ item: inout Item) -> Result?) -> Result? {
        return lock.writeLock { [weak self] in
            guard let `self` = self else {
                assertionFailure("self was deallocated!")
                return nil
            }
            return block(&self.item)
        }
    }
}

public class CZDispatchReadWriteLock {
    fileprivate let syncQueue = DispatchQueue(label: "com.tony.mutexLock", attributes: .concurrent)
    public init () {}

    @discardableResult
    public func readLock<T>(_ block: @escaping () -> T?) -> T?  {
        return syncQueue.sync { () -> T? in
            return block()
        }
    }
    
    @discardableResult
    public func writeLock<T>(isAsync: Bool = false, block: @escaping () -> T?) -> T? {
        if isAsync {
            syncQueue.async(flags: .barrier) { _ = block() }
            return nil
        } else {
            return syncQueue.sync(flags: .barrier) {() -> T? in
                return block()
            }
        }
    }
}

// MARK: - Bridging class for Objective-C
@objc public class CZMutexLockOC: NSObject {
    fileprivate var lock: CZMutexLock<Any>
    init(_ item: Any) {
        lock = CZMutexLock<Any>(item)
    }

    @discardableResult
    public func read (_ block: @escaping (_ item: Any) -> Any?) -> Any? { // U
        return lock.readLock {(item: Any) -> Any?  in
            // `item` is actually the input of callback block of `lock`
            return block(item)
        }
    }

    @discardableResult
    public func write(_ block: @escaping (_ item: Any) -> Any?) -> Any? {// U
        return lock.writeLock { (item: inout Any) -> Any? in
            return block(item)
        }
    }
}

