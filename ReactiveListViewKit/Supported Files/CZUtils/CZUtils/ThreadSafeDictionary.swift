//
//  ThreadSafeDictionary.swift
//  CZUtils
//
//  Created by Cheng Zhang on 2/10/16.
//  Copyright © 2016 Cheng Zhang. All rights reserved.
//

import Foundation

/// Elegant thread safe Dictionary on top of CZMutexLock
open class ThreadSafeDictionary<Key: Hashable, Value: Any>: NSObject, Collection, ExpressibleByDictionaryLiteral {
    public typealias DictionaryType = Dictionary<Key, Value>
    private var protectedCache: CZMutexLock<DictionaryType>
    private let emptyDictionary = DictionaryType()
    private var underlyingDictionary: DictionaryType {
        return protectedCache.readLock{ $0 }!
    }
    public override init() {
        protectedCache = CZMutexLock([:])
        super.init()
    }
    
    public init(dictionary: DictionaryType) {
        protectedCache = CZMutexLock(dictionary)
        super.init()
    }
    
    // MAKR: - ExpressibleByDictionaryLiteral
    
    /// Creates an instance initialized with the given key-value pairs
    public required init(dictionaryLiteral elements: (Key, Value)...) {
        var dictionary = DictionaryType()
        for (key, value) in elements {
            dictionary[key] = value
        }
        protectedCache = CZMutexLock(dictionary)
        super.init()
    }
    
    // MARK: - Public variables
    
    public var isEmpty: Bool {
        return protectedCache.readLock { $0.isEmpty } ?? true
    }
    
    public var count: Int {
        return protectedCache.readLock { $0.count } ?? 0
    }
    
    public var keys: Dictionary<Key, Value>.Keys {
        return protectedCache.readLock { $0.keys } ?? emptyDictionary.keys
    }
    
    public var values: Dictionary<Key, Value>.Values {
        return protectedCache.readLock { $0.values } ?? emptyDictionary.values
    }
    
    // MARK: - Public methods
    
    public func updateValue(_ value: Value, forKey key: Key) -> Value? {
        return protectedCache.writeLock { $0.updateValue(value, forKey: key) }
    }
    
    public func removeValue(forKey key: Key) -> Value? {
        return protectedCache.writeLock { $0.removeValue(forKey: key) }
    }
    
    public func removeAll(keepingCapacity keepCapacity: Bool = false) {
        protectedCache.writeLock { $0.removeAll(keepingCapacity: keepCapacity) }
    }
    
    public func values(for keys: [Key]) -> [Value] {
        return protectedCache.readLock{ cache in
            return keys.compactMap{ (key) -> Value? in
                return cache[key]
            } } ?? []
    }
    
    // MARK: - Subscripts
    
    public subscript (key: Key) -> Value? {
        get {
            return protectedCache.readLock { $0[key] }
        }
        set {
            protectedCache.writeLock { (cache) -> Value? in
                cache[key] = newValue
                return newValue
            }
        }
    }
    
    public subscript(position: DictionaryIndex<Key, Value>) -> (key: Key, value: Value) {
        return protectedCache.readLock { return $0[position] }  ?? emptyDictionary[position]
    }
    
    // MARK: - Collection protocol
    
    public var startIndex: DictionaryIndex<Key, Value> {
        return protectedCache.readLock { $0.startIndex } ?? emptyDictionary.startIndex
    }
    
    public var endIndex: DictionaryIndex<Key, Value> {
        return protectedCache.readLock { $0.endIndex } ?? emptyDictionary.endIndex
    }
    
    public func indexForKey(_ key: Key) -> DictionaryIndex<Key, Value>? {
        return protectedCache.readLock { $0.index(forKey: key) }
    }
    
    public func index(after i: DictionaryIndex<Key, Value>) -> DictionaryIndex<Key, Value> {
        return protectedCache.readLock { $0.index(after: i) }  ?? emptyDictionary.index(after: i)
    }
    
    public func removeAtIndex(_ index: DictionaryIndex<Key, Value>) -> (Key, Value) {
        if let result = protectedCache.writeLock({ $0.remove(at: index) }) {
            return result
        } else {
            var temp = emptyDictionary
            return temp.remove(at: index)
        }
    }
    
    // MARK: - CustomStringConvertable
    
    open override var description: String {
        return protectedCache.readLock {
            var description = "[\n"
            var index = 0
            for (key, value) in $0 {
                let comma = (index == $0.count - 1) ? "" : ","
                description += "\(key): \(value)\(comma)\n"
                index += 1
            }
            description += "]"
            return description
            } ?? ""
    }
}

public extension ThreadSafeDictionary where Key : Hashable, Value : Equatable {
    public static func ==(lhs: ThreadSafeDictionary, rhs: ThreadSafeDictionary) -> Bool {
        return lhs.underlyingDictionary == rhs.underlyingDictionary
    }
    
    public func isEqual(toDictionary dictionary: DictionaryType) -> Bool {
        return underlyingDictionary == dictionary
    }
}


