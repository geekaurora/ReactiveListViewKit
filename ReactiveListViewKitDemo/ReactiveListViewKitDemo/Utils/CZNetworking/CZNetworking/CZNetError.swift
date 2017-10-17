//
//  CZNetError.swift
//  CZNetworking
//
//  Created by Cheng Zhang on 12/9/15.
//  Copyright © 2015 Cheng Zhang. All rights reserved.
//

import UIKit
import CZUtils

/// Network Error class
open class CZNetError: CZError {
    fileprivate static let domain = "CZNetworking"
    public static let `default` = CZNetError("Network Error")
    public static let returnType = CZNetError("ReturnType Error")
    
    public init(_ description: String? = nil, code: Int = 99) {
        super.init(domain: CZNetError.domain, code: code, description: description)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
