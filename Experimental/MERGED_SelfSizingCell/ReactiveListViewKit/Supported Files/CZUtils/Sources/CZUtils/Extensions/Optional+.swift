//
//  Optional+.swift
//  CZUtils
//
//  Created by Cheng Zhang on 9/22/18.
//  Copyright © 2018 Cheng Zhang. All rights reserved.
//

import Foundation

/**
 Convenient methods of Swift Optional
 */
extension Optional {
    /**
     If this optional has a value, unwrap the optional and call the given function passing the unwrapped value
     */
    public func ifPresent(_ function: ((Wrapped) -> Void)? = nil) {
        guard let function = function else {
            return
        }

        switch (self) {
        case .some(let value):
            function(value)
        default:
            break
        }
    }

    /**
     If this optional has a value, call the given function passing this optional
     */
    public func ifPresent(_ function: ((Wrapped?) -> Void)? = nil) {
        guard let function = function else {
            return
        }

        switch (self) {
        case .some(let value):
            function(value)
        default:
            break
        }
    }

    /**
     Raises an assert if the value is nil.
     */
    public var assertIfNil: Optional {
        assert(self != nil, "Expected a non-nil \(Wrapped.self)")
        return self
    }

    /**
     Returns a string-interpolated value for item contained in this optional, or the default value if the optional is nil.
     This can be used instead of String(describing:) if you don't want the result to contain "Optional()"

     Note: If this is a doubly-nested optional (e.g. Int??), you could still get the "Optional()" string as this only unwraps one level.
     */
    public func interpolatedString(withDefaultValue defaultValue: String = "nil") -> String {
        return self.map { wrapped in "\(wrapped)" } ?? defaultValue
    }
}
