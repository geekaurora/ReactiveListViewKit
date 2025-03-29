//
//  PrettyDescription.swift
//  CZUtils
//
//  Created by Cheng Zhang on 7/29/19.
//  Copyright © 2019 Cheng Zhang. All rights reserved.
//

import Foundation

public class Pretty {
    
    /**
     Return Pretty formatted description for valid JSON object
    */
    static func describing(_ object: Any) -> String {
        do {
            let data: Data = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
            return String(data: data, encoding: .utf8).assertIfNil ?? ""
        } catch {
            assertionFailure("Failed to retrieve pretty printed description. error - \(error.localizedDescription)")
            return ""
        }
    }
    
}
