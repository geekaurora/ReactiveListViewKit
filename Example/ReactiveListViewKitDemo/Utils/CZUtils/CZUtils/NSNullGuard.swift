//
//  NSNullGuard.swift
//
//  Created by Cheng Zhang on 5/17/16.
//  Copyright © 2016 Cheng Zhang. All rights reserved.
//

import UIKit

// MARK: - Swizzling - Remove NSNulls from Sequence object in `write(to:)`

public extension NSDictionary {
    static var hasSwizzled: Bool? = false
    open override class func initialize() {
//      guard self === NSDictionary.self else { return }
        swizzleMethods()
    }
    static func swizzleMethods()  {
        guard !(hasSwizzled ?? false) else {return}
        hasSwizzled = true
        swizzling(NSDictionary.self,
                  originalSelector: #selector(write(to:atomically:)),
                  swizzledSelector: #selector(swizzled_write(to:atomically:)))
        swizzling(self,
                  originalSelector: #selector(write(toFile:atomically:)),
                  swizzledSelector: #selector(swizzled_write(toFile:atomically:)))
    }
    open func swizzled_write(to url: URL, atomically: Bool) -> Bool {
        return (removedNulls() as! NSDictionary).swizzled_write(to: url, atomically: atomically)
    }
    open func swizzled_write(toFile path: String, atomically useAuxiliaryFile: Bool) -> Bool {
        return (removedNulls() as! NSDictionary).write(toFile: path, atomically: useAuxiliaryFile)
    }
}

public extension NSArray {
    static var hasSwizzled: Bool? = false
    open override class func initialize() {
        swizzleMethods()
    }
    static func swizzleMethods()  {
        guard !(hasSwizzled ?? false) else {return}
        hasSwizzled = true
        swizzling(NSArray.self,
                  originalSelector: #selector(write(to:atomically:)),
                  swizzledSelector: #selector(swizzled_write(to:atomically:)))
        swizzling(self,
                  originalSelector: #selector(write(toFile:atomically:)),
                  swizzledSelector: #selector(swizzled_write(toFile:atomically:)))
    }
    open func swizzled_write(to url: URL, atomically: Bool) -> Bool {
        return (removedNulls() as! NSArray).swizzled_write(to: url, atomically: atomically)
    }
    open func swizzled_write(toFile path: String, atomically useAuxiliaryFile: Bool) -> Bool {
        return (removedNulls() as! NSArray).swizzled_write(toFile: path, atomically: useAuxiliaryFile)
    }
}

// MARK: - NSNullRemovable

public protocol NSNullRemovable {
    func removedNulls() -> NSNullRemovable
}

extension Dictionary: NSNullRemovable {
    public func removedNulls() -> NSNullRemovable {
        var res = type(of: self).init()
        for (key, value) in self {
            if value is NSNull {
                continue
            } else if let value = value as? NSNullRemovable {
                res[key] = value.removedNulls() as! Value
            } else {
                res[key] = value
            }
        }
        return res
    }
}

extension Array: NSNullRemovable {
    public func removedNulls() -> NSNullRemovable {
        var res = type(of: self).init()
        for value in self {
            if value is NSNull {
                continue
            } else if let value = value as? NSNullRemovable {
                res.append(value.removedNulls() as! Element)
            } else {
                res.append(value)
            }
        }
        return res
    }
}

extension NSDictionary: NSNullRemovable {
    public func removedNulls() -> NSNullRemovable {
        return (self as! [AnyHashable: Any]).removedNulls()
    }
}

extension NSArray: NSNullRemovable {
    public func removedNulls() -> NSNullRemovable {
        return (self as! [NSObject]).removedNulls()
    }
}




