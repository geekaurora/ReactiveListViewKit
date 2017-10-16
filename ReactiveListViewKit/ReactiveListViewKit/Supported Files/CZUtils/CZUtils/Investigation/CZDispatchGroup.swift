//
//  CZDispatchGroup.swift
//  CZUtils
//
//  Created by Cheng Zhang on 3/25/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit

/// Manage grouped concurrent executions completion, with same functionality as `DispatchGroup` class
public final class CZDispatchGroup: NSObject {
    fileprivate static let underlyingQueueLabel = "com.tony.dispatchGroup"
    fileprivate var underlyingQueue: DispatchQueue
    fileprivate var semaphore: DispatchSemaphore?
    fileprivate var executionCountLock = CZMutexLock<Int>(0)
    fileprivate var notifyQueue: DispatchQueue?
    fileprivate var notifyBlock: (() -> Void)?

    override init() {
        underlyingQueue = DispatchQueue(label: CZDispatchGroup.underlyingQueueLabel,
                                             qos: .default,
                                             attributes: .concurrent)
        super.init()
    }
    
    public func enter() {
        underlyingQueue.async {[weak self] in
            guard let `self` = self else {return}
            self.executionCountLock.writeLock{ count in
                count += 1
            }
        }
    }
    
    public func leave() {
        underlyingQueue.async {[weak self] in
            guard let `self` = self else {return}
            self.executionCountLock.writeLock{ count in
                count -= 1
                if count == 0 {
                    self.semaphore?.signal()
                }
            }
        }
    }
    
    public func wait() {
        underlyingQueue.sync {[weak self] in
            guard let `self` = self else {return}
            self.semaphore = DispatchSemaphore(value: 0)
            self.semaphore?.wait()
        }
    }
    
    public func notify(qos: DispatchQoS = .default,
                       flags: DispatchWorkItemFlags = .inheritQoS,
                       queue: DispatchQueue,
                       execute work: @escaping @convention(block) () -> Void) {
        self.notifyQueue = queue
        self.notifyBlock = work
        
        // Wait for semaphore signal of completion of all executions
        underlyingQueue.async {[weak self] in
            guard let `self` = self else {return}
            self.semaphore = DispatchSemaphore(value: 0)
            self.semaphore?.wait()
            
            // Got completion semaphore signal and notify completion asynchronously with notifyQueue
            self.notifyQueue?.async {
                self.notifyBlock?()
            }
        }
    }
}

