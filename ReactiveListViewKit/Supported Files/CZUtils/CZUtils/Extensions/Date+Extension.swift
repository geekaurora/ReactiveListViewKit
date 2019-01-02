//
//  Date+Extension.swift
//  CZUtils
//
//  Created by Cheng Zhang on 5/19/16.
//  Copyright © 2016 Cheng Zhang. All rights reserved.
//

import Foundation

public extension Date {
    var simpleString: String {
        return string(withFormatterStr: "yyyy-MM-dd hh:mm")
    }
    
    var complexString: String {
        return string(withFormatterStr: "EEE, dd MMM yyyy hh:mm:ss +zzzz")
    }
}

private extension Date {
    func string(withFormatterStr formatterStr: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatterStr
        return dateFormatter.string(from: self)
    }
}
