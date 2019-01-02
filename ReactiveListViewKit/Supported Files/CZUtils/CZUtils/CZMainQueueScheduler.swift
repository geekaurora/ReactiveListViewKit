//
//  CZMainQueueScheduler.swift
//
//  Created by Cheng Zhang on 1/4/16.
//  Copyright © 2016 Cheng Zhang. All rights reserved.
//

import Foundation

/// Convenience class for scheduling sync/async execution on main queue
open class CZMainQueueScheduler: NSObject {
    
    /// Synchronous execution: inferring function returnType with `execution` closure returnType
    public class func sync<T>(_ execution: @escaping () -> T) -> T {
        if Thread.isMainThread {
            return execution()
        } else {
            return DispatchQueue.main.sync  {
                execution()
            }
        }
    }
    
    /// Asynchronous execution
    public class func async(_ execution: @escaping () -> Void ) {
        DispatchQueue.main.async {
            execution()
        }
    }
}

