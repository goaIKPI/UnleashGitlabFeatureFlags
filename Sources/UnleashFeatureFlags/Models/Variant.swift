//
//  VariantOverride.swift
//  UnleashFeatureFlags
//
//  Created by mac on 17.04.2021.
//  Copyright © 2021 Олег Герман. All rights reserved.
//

import Foundation

struct Variant: Codable {
    var contextName: String
    var values: [String]
}
