//
//  DefaultStrategy.swift
//  UnleashFeatureFlags
//
//  Created by mac on 17.04.2021.
//  Copyright © 2021 Олег Герман. All rights reserved.
//

import Foundation

final class DefaultStrategy : Strategy {
    var name: String {
        return "default"
    }
    
    func isEnabled(parameters: [String : String]) -> Bool {
        return true
    }
}
