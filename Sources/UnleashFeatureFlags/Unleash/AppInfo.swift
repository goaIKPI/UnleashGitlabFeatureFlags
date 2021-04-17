//
//  AppInfo.swift
//  UnleashFeatureFlags
//
//  Created by mac on 17.04.2021.
//  Copyright © 2021 Олег Герман. All rights reserved.
//

import Foundation

public enum AppInfo {
    public static let shortVersion =
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
}
