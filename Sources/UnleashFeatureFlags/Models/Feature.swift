//
//  Feature.swift
//  UnleashFeatureFlags
//
//  Created by mac on 17.04.2021.
//  Copyright © 2021 Олег Герман. All rights reserved.
//

import Foundation

struct Feature: Codable {
    var name: String
    var description: String
    var enabled: Bool
    var strategies: [ActivationStrategy]
    var variants: [VariantDefinition]?
}
