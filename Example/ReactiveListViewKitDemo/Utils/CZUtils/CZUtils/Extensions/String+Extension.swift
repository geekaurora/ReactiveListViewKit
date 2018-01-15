//
//  NSString+Additions
//
//  Created by Cheng Zhang on 1/5/16.
//  Copyright © 2016 Cheng Zhang. All rights reserved.
//

import UIKit

public extension String {
    /**
        http://stackoverflow.com/questions/24551816/swift-encode-url
        http://stackoverflow.com/questions/37376196/encode-url-with-http

        URLHostAllowedCharacterSet      "#%/<>?@\^`{|}
        URLQueryAllowedCharacterSet     "#%<>[\]^`{|}
        URLFragmentAllowedCharacterSet  "#%<>[\]^`{|}
        URLPasswordAllowedCharacterSet  "#%/:<>?@[\]^`{|}
        URLPathAllowedCharacterSet      "#%;<>?[\]^`{|}
        URLUserAllowedCharacterSet      "#%/:<>?@[\]^`
     */
    public func urlEncoded()-> String {
        guard characters.index(of: "%") == nil else { return self }
        let mutableString = NSMutableString(string: self)
        let urlEncoded = mutableString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        return urlEncoded ?? ""
    }
}
