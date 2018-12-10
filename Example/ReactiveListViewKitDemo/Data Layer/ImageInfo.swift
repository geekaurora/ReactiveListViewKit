//
//  ImageInfo.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 1/4/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import CZUtils
import ReactiveListViewKit
import EasyMapping

/// Model of image info
class ImageInfo: CZModel {
    var url: String? 
    var width: Int? {return _width?.intValue}
    var height: Int? {return _height?.intValue}
    var _width: NSNumber?
    var _height: NSNumber?

    override init() { super.init() }

    required init(dictionary: CZDictionary) {
        super.init(dictionary: dictionary)
    }

    override class func objectMapping() -> EKObjectMapping {
        let allMapping = super.objectMapping()
        let mapping = EKObjectMapping(objectClass: self)
        mapping.mapProperties(from: ["url": "url",
                                     "width": "_width",
                                     "height": "_height",
                                     ])
        allMapping.mapProperties(fromMappingObject: mapping)
        return allMapping
    }
}
