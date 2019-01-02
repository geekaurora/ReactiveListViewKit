//
//  CZFileHelper.swift
//
//  Created by Cheng Zhang on 1/13/16.
//  Copyright © 2016 Cheng Zhang. All rights reserved.
//

import Foundation

/// Helper class for file related methods 
@objc open class CZFileHelper: NSObject {
   public static func getFileSize(_ filePath: String?) -> Int? {
        guard let filePath = filePath else {return nil}
        do {
            let attrs = try FileManager.default.attributesOfItem(atPath: filePath)
            let size =  attrs[.size] as? Int
            return size
        } catch {
            dbgPrint("Failed to get file size of \(filePath). Error - \(error.localizedDescription)")
        }
        return nil
    }
    
    @objc public static var documentDirectory: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/"
    }
}
