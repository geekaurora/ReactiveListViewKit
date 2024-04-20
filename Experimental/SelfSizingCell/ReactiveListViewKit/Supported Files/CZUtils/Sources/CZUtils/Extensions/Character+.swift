//
//  Character+.swift
//
//  Created by Cheng Zhang on 12/30/18.
//  Copyright © 2018 Cheng Zhang. All rights reserved.
//

import Foundation

extension Character {
    
    public var ascii: Int {
        return Int(String(self).unicodeScalars.first!.value)
    }
    
}
