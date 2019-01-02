//
//  CZError.swift
//
//  Created by Cheng Zhang on 1/10/16.
//  Copyright © 2016 Cheng Zhang. All rights reserved.
//

import Foundation

/// Convenience Error class  
open class CZError: NSError {    
    public init(domain: String, code: Int = 99, description: String? = nil) {
        var userInfo: [String: Any]? = nil
        if let description = description {
            userInfo = [NSLocalizedDescriptionKey: description]
        }
        super.init(domain: domain, code: code, userInfo: userInfo)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
