//
//  ActivationStrategy.swift
//  UnleashFeatureFlags
//
//  Created by mac on 17.04.2021.
//  Copyright © 2021 Олег Герман. All rights reserved.
//

import Foundation

struct ActivationStrategy: Codable {
    var name: String
    var parameters: [String : String]?
}
