//
//  CZMutexLock.swift
//
//  Created by Cheng Zhang on 1/4/16.
//  Copyright © 2016 Cheng Zhang. All rights reserved.
//

import UIKit

/// Generic multi-thread mutex lock on top of DispatchQueue sync/barrier
public class CZMutexLock<Item>: NSObject {
    fileprivate lazy var lock = CZDispatchReadWriteLock()
    fileprivate var item: Item
    
    public init(_ item: Item) {
        self.item = item
    }
    
    /// Execute `block` with read lock that protects `item`
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
    
    /// Execute `block` with write lock that protects `item`
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
    public func read (_ block: @escaping (_ item: Any) -> Any?) -> Any? {
        return lock.readLock {(item: Any) -> Any?  in
            return block(item)
        }
    }
    
    @discardableResult
    public func write(_ block: @escaping (_ item: Any) -> Any?) -> Any? {
        return lock.writeLock { (item: inout Any) -> Any? in
            return block(item)
        }
    }
}

