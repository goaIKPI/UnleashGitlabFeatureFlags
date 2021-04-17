//
//  ClientRegistration.swift
//  UnleashFeatureFlags
//
//  Created by mac on 17.04.2021.
//  Copyright © 2021 Олег Герман. All rights reserved.
//

import Foundation

struct ClientRegistration: Codable {
    var appName: String
    var instanceId: String
    var sdkVersion: String
    var strategiesName: [String]
    
    init(appName: String, instanceId: String, strategies: [Strategy]) {
        self.appName = appName
        self.instanceId = instanceId
        self.sdkVersion = "unleash-client-ios:\(AppInfo.shortVersion)"
        self.strategiesName = strategies.map { $0.name }
    }
}
