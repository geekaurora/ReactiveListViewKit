//
//  CZModel.swift
//  CZFacebook
//
//  Created by Cheng Zhang on 1/3/17.
//  Copyright © 2017 Groupon Inc. All rights reserved.
//

import UIKit
import CZUtils
import ReactiveListViewKit
import EasyMapping

typealias CZDictionary = [AnyHashable : Any]

protocol CZDictionaryable: NSObjectProtocol {
    init(dictionary: CZDictionary)
}

/// Base Model class conforming `CZListDiffable` by default
class CZModel: NSObject, EKMappingProtocol, NSCopying, CZDictionaryable {
    fileprivate var serializedObject: CZDictionary?

    override init() { super.init() }
    required init(dictionary: CZDictionary) {
        super.init()
        EKMapper.fillObject(self, fromExternalRepresentation: dictionary, with: type(of: self).objectMapping())
    }

    init(dictionary: CZDictionary, mapping: EKObjectMapping) {
        super.init()
        EKMapper.fillObject(self, fromExternalRepresentation: dictionary, with: mapping)
    }

    // MARK: - EKMappingProtocol
    class func objectMapping() -> EKObjectMapping {
        return EKObjectMapping(objectClass: self)
    }

    func update(with dictionary: CZDictionary, mapping: EKObjectMapping? = nil) -> CZModel? {
        let mapping = mapping ?? type(of: self).objectMapping()
        EKMapper.fillObject(self, fromExternalRepresentation: dictionary, with: mapping)
        return self
    }

    var dictionaryVersion: CZDictionary {
        return EKSerializer.serializeObject(self, with: type(of: self).objectMapping())
    }

    func dictionaryVersion(mapping: EKObjectMapping) -> CZDictionary {
        return EKSerializer.serializeObject(self, with: mapping)
    }

    func isEqual(to model: Any) -> Bool {
        guard let model = model as? CZModel,
            NSStringFromClass(type(of: model)) == NSStringFromClass(type(of: self)) else {
            return false
        }
        return (dictionaryVersion as NSDictionary).isEqual(to: model.dictionaryVersion)
    }
}

// MARK: - NSCopying
extension CZModel {
    func copy(with zone: NSZone? = nil) -> Any {
        return type(of: self).init(dictionary: dictionaryVersion)
    }
}

extension CZModel {
    override var description: String {
        return dictionaryVersion.description
    }
}

// MARK: - CZListDiffable
extension CZModel: CZListDiffable {
    func isEqual(toDiffableObj object: AnyObject) -> Bool {
        return isEqual(to: object)
    }
}


