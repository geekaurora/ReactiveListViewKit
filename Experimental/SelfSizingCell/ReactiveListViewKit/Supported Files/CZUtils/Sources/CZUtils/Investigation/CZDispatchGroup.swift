//
//  CZDispatchGroup.swift
//  CZUtils
//
//  Created by Cheng Zhang on 3/25/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import Foundation

/// Manage grouped concurrent executions completion, with same functionality as `DispatchGroup` class
public final class CZDispatchGroup: NSObject {
    private static let underlyingQueueLabel = "com.tony.dispatchGroup"
    private var underlyingQueue: DispatchQueue
    private lazy var semaphore = DispatchSemaphore(value: 0)
    private var countLock = CZMutexLock<Int>(0)
    private var notifyQueue: DispatchQueue?
    private var notifyBlock: (() -> Void)?
    
    override init() {
        underlyingQueue = DispatchQueue(label: CZDispatchGroup.underlyingQueueLabel,
                                        qos: .default,
                                        attributes: .concurrent)
        super.init()
    }
    
    public func enter() {
        underlyingQueue.async {[weak self] in
            guard let `self` = self else {return}
            self.countLock.writeLock{ count in
                count += 1
            }
        }
    }
    
    public func leave() {
        underlyingQueue.async {[weak self] in
            guard let `self` = self else {return}
            self.countLock.writeLock{ count in
                count -= 1
                if count == 0 {
                    self.semaphore.signal()
                }
            }
        }
    }
    
    public func wait() {
        underlyingQueue.sync {[weak self] in
            guard let `self` = self else {return}
            self.semaphore.wait()
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
            self.semaphore.wait()
            
            // Got completion semaphore signal and notify completion asynchronously with notifyQueue
            self.notifyQueue?.async {
                self.notifyBlock?()
            }
        }
    }
}

