//
//  MemoryCache.swift
//  UnleashFeatureFlags
//
//  Created by mac on 17.04.2021.
//  Copyright © 2021 Олег Герман. All rights reserved.
//

import Foundation

final class MemoryCache {
    private var cache: Cache
    private let jsonDecoder: JSONDecoder
    private let jsonEncoder: JSONEncoder
    
    init(cache: Cache, jsonDecoder: JSONDecoder, jsonEncoder: JSONEncoder) {
        self.cache = cache
        self.jsonDecoder = jsonDecoder
        self.jsonEncoder = jsonEncoder
    }
    
    func get<T: Decodable>(for key: String) -> T? {
        if let data = cache[key] {
            return try? jsonDecoder.decode(T.self, from: data)
        }
        
        return nil
    }
    
    func put<T: Encodable>(for key: String, value: T) {
        if let data = try? jsonEncoder.encode(value) {
            cache[key] = data
        }
    }
}

class Cache {
    private var cache: [String : Data] = [:]
    
    subscript(key: String) -> Data? {
        get {
            return cache[key]
        }
        set(newValue) {
            cache[key] = newValue
        }
    }
}
