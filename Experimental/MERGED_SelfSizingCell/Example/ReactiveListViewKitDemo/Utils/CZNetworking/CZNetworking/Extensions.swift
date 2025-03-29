//
//  Extensions.swift
//  CZNetworking
//
//  Created by Cheng Zhang on 12/11/15.
//  Copyright © 2015 Cheng Zhang. All rights reserved.
//

import UIKit
import CommonCrypto

public extension String {
    /// MD5 HashValue: Should #import <CommonCrypto/CommonCrypto.h> in your Bridging-Header file
    public var MD5: String {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)
        
        if let d = self.data(using: String.Encoding.utf8) {
            _ = d.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
                CC_MD5(body, CC_LONG(d.count), &digest)
            }
        }
        
        return (0..<length).reduce("") {
            $0 + String(format: "%02x", digest[$1])
        }
    }
}
