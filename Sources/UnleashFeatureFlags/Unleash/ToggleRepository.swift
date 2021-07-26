//
//  ToggleRepository.swift
//  UnleashFeatureFlags
//
//  Created by mac on 17.04.2021.
//  Copyright © 2021 Олег Герман. All rights reserved.
//

import Foundation

protocol ToggleRepositoryProtocol {
    var toggles: Toggles? { get set }
    func get(url: URL) -> (Toggles?, Error?)
}

final class ToggleRepository: ToggleRepositoryProtocol {
    private let key = "unleash-feature-toggles"
    private let memory: MemoryCache
    private let toggleService: ToggleServiceProtocol
    
    public var toggles: Toggles? {
        get { return memory.get(for: key) }
        set { memory.put(for: key, value: newValue) }
    }
    
    init(memory: MemoryCache, toggleService: ToggleServiceProtocol) {
        self.memory = memory
        self.toggleService = toggleService
    }
    
    func get(url: URL) -> (Toggles?, Error?) {
        let result = toggleService.fetchToggles(url: url)
        if let toggles = result.0 {
            self.toggles = toggles
        }
        return result
    }
}
