//
//  ViewController.swift
//  SampleFeatureFlags
//
//  Created by mac on 17.04.2021.
//

import UIKit
import UnleashFeatureFlags

struct UnleashConstants {
    static let environment: String = "qa"
    static let appName = "production"
    static let unleashUrl = "https://gitlab.com/api/v4/feature_flags/unleash/42"
    static let instanceId = "29QmjsW6KngPR5JNPMWx"
    static let featureToggleName = "my_feature_name"
    static let errorTitle = "Unleash Error"
    static let refreshInterval: TimeInterval = 10
}

class ViewController: UIViewController {

    private var unleash: Unleash!

    var isEnabledFlag: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        initUnleashConnect()
    }
}

extension ViewController {
    func initUnleashConnect() {
        unleash = Unleash(
            appName: UnleashConstants.appName,
            url: UnleashConstants.unleashUrl,
            instanceId: UnleashConstants.instanceId,
            refreshInterval: UnleashConstants.refreshInterval,
            strategies: [EnvironmentStrategy()])
        unleash.delegate = self
    }
}

extension ViewController: UnleashDelegate {
    func unleashDidLoad(_ unleash: Unleash) {
        isEnabledFlag = unleash.isEnabled(name: UnleashConstants.featureToggleName)
    }

    func unleashDidFail(_ unleash: Unleash, withError error: Error) {
        let alertController = UIAlertController(
            title: UnleashConstants.errorTitle,
            message: error.localizedDescription,
            preferredStyle: .alert)

        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}

