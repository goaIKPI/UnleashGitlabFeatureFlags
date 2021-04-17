//
//  EnvironmentStrategy.swift
//  SampleFeatureFlags
//
//  Created by mac on 17.04.2021.
//

import Foundation
import UnleashFeatureFlags

// MARK: EnvironmentStrategy
class EnvironmentStrategy: Strategy {
    var name: String {
        return "environment"
    }

    func isEnabled(parameters: [String : String]) -> Bool {
        return UnleashConstants.environment == parameters["environment"]
    }
}
