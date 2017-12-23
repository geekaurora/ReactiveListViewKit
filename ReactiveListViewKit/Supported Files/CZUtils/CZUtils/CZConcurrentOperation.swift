//
//  CZConcurrentOperation.swift
//
//  Created by Cheng Zhang on 1/5/16.
//  Copyright © 2016 Cheng Zhang. All rights reserved.
//

import UIKit

/// An abstract class that makes subclassing ConcurrentOperation easy to udpate KVO props `isReady`/`isExecuting`/`isFinished` automatically
///
/// Usage:
/// - Subclass must implement `execute()` when execute task
/// - Subclass must invoke `finish()` any work is done or after a call to `cancel()` to move the operation into a completed state.
///
/// https://gist.github.com/calebd
/// https://gist.github.com/alexaubry/1ee81a952b11a2ddc6a43480cc59032c
@objc open class CZConcurrentOperation: Operation {
    /// Concurrent DispatchQueue acting as mutex read/write lock of rawState
    private let stateQueue = DispatchQueue(label: "com.tony.operation.state", attributes: [.concurrent])
    fileprivate var rawState: OperationState = .ready
    @objc private dynamic var state: OperationState {
        get {
            return stateQueue.sync{ rawState}
        }
        set {
            willChangeValue(forKey: #keyPath(state))
            stateQueue.sync(flags: .barrier) {
                rawState = newValue
            }
            didChangeValue(forKey: #keyPath(state))
        }
    }
    public final override var isReady: Bool {
        return state == .ready && super.isReady
    }
    public final override var isExecuting: Bool {
        return state == .executing
    }
    public final override var isFinished: Bool {
        return state == .finished
    }
    public final override var isConcurrent: Bool {
        return true
    }

    // MARK: - Public Methods

    /// Subclasses must implement `execute` and must not call super
    open func execute() {
        fatalError("Subclasses must implement `\(#function)`.")
    }

    /// Call this function after any work is done or after a call to `cancel()`
    /// to move the operation into a completed state.
    public final func finish() {
        state = .finished
    }

    // MARK: - Override methods
    public final override func start() {
        if isCancelled {
            finish()
            return
        }
        state = .executing
        execute()
    }

    // MARK: - Dependent KVO

    /// Bind dependency of KVO between `state` and `isReady`, `isExecuting`,`isFinished`: `state` change automatically triggers KVO notification of the other 3 props
    @objc private dynamic class func keyPathsForValuesAffectingIsReady() -> Set<String> {
        return [#keyPath(state)]
    }
    @objc private dynamic class func keyPathsForValuesAffectingIsExecuting() -> Set<String> {
        return [#keyPath(state)]
    }
    @objc private dynamic class func keyPathsForValuesAffectingIsFinished() -> Set<String> {
        return [#keyPath(state)]
    }
}

@objc private enum OperationState: Int {
    case ready, executing, finished
}
