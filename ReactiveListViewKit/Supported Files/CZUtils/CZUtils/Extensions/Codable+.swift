//
//  Codable+.swift
//  CZUtils
//
//  Created by Cheng Zhang on 12/31/18.
//  Copyright © 2018 Cheng Zhang. All rights reserved.
//

import Foundation

public class CodableHelper {
    /// Decode model from specified file
    ///
    /// - Parameter pathUrl: pathUrl of file
    /// - Returns: the decoded model
    public static func decode<T: Decodable>(_ pathUrl: URL) -> T? {
        do {
            let jsonData = try Data(contentsOf: pathUrl)
            let model = try JSONDecoder().decode(T.self, from: jsonData)
            return model
        } catch {
            CZUtils.dbgPrint("Failed to decode JSON file \(pathUrl). Error - \(error.localizedDescription)")
            return nil
        }
    }
}

public extension Encodable {
    /// Transform current obj to dictionary
    public var dictionaryVersion: [AnyHashable : Any] {
        do {
            let jsonData = try JSONEncoder().encode(self)
            let dictionaryVersion = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [AnyHashable : Any]
            return dictionaryVersion ?? [:]
        } catch {
            assertionFailure("Failed to encode model to Data. Error - \(error.localizedDescription)")
            return [:]
        }
    }
    
    /// Verify whether current obj equals to other obj
    ///
    /// - Parameter other: the other obj to compare
    /// - Returns: true if equals, false otherwise
    public func isEqual(toCodable other: Any) -> Bool {
        guard let other = other as? Encodable,
            let selfClass = type(of: self) as? AnyClass,
            let otherClass = type(of: other) as? AnyClass,
            NSStringFromClass(selfClass) == NSStringFromClass(otherClass) else {
                return false
        }
        return (dictionaryVersion as NSDictionary).isEqual(to: other.dictionaryVersion)
    }
}

// MARK: - NSCopying

public extension Encodable where Self: Decodable {
    public func codableCopy(with zone: NSZone? = nil) -> Any {
        do {
            let encodedData = try JSONEncoder().encode(self)
            let copy = try JSONDecoder().decode(type(of: self), from: encodedData)
            return copy
        } catch {
            assertionFailure("Failed to copy the object. Error - \(error.localizedDescription)")
            return self
        }
    }
}

// MARK: - CustomStringConvertible

public extension CustomStringConvertible where Self: Encodable {
    public var description: String {
        return dictionaryVersion.description
    }
}
