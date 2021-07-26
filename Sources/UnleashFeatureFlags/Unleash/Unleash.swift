//
//  Unleash.swift
//  UnleashFeatureFlags
//
//  Created by mac on 17.04.2021.
//  Copyright © 2021 Олег Герман. All rights reserved.
//

import Foundation

// MARK: - UnleashError
public enum UnleashError: Error {
    case noURLProvided
    case maxRetriesReached
}

// MARK: - Strategy
public protocol Strategy {
    var name: String { get }
    func isEnabled(parameters: [String: String]) -> Bool
}

public protocol UnleashDelegate {
    func unleashDidLoad(_ unleash: Unleash)
    func unleashDidFail(_ unleash: Unleash, withError error: Error)
}

// MARK: - Unleash
final public class Unleash {

    // MARK: - Properties
    private var toggleRepository: ToggleRepositoryProtocol
    private var toggles: Toggles? { return toggleRepository.toggles }
    private var scheduler: Scheduler

    public private(set) var appName: String
    public private(set) var url: String
    public private(set) var refreshInterval: TimeInterval
    public private(set) var strategies: [Strategy]
    public var delegate: UnleashDelegate?

    // MARK: - Lifecycle - Public Init
    public convenience init(
        appName: String,
        url: String,
        instanceId: String,
        refreshInterval: TimeInterval = 3600,
        strategies: [Strategy] = []
    ) {
        let clientRegistration: ClientRegistration = ClientRegistration(appName: appName, instanceId: instanceId, strategies: strategies)
        let memory: MemoryCache = MemoryCache(cache: Cache(), jsonDecoder: JSONDecoder(), jsonEncoder: JSONEncoder())
        let toggleService: ToggleServiceProtocol = ToggleService(appName: appName, instanceId: clientRegistration.instanceId)
        let toggleRepository: ToggleRepository = ToggleRepository(memory: memory, toggleService: toggleService)
        let allStrategies: [Strategy] = [DefaultStrategy()] + strategies

        self.init(
            clientRegistration: clientRegistration,
            toggleRepository: toggleRepository,
            appName: appName,
            url: url,
            refreshInterval: refreshInterval,
            strategies: allStrategies)
    }

    // MARK: - Internal Init
    init(
        clientRegistration: ClientRegistration,
        toggleRepository: ToggleRepositoryProtocol,
        appName: String,
        url: String,
        refreshInterval: TimeInterval,
        strategies: [Strategy],
        scheduler: Scheduler? = nil
    ) {
        self.toggleRepository = toggleRepository
        self.appName = appName
        self.url = url
        self.refreshInterval = refreshInterval
        self.strategies = strategies

        if let scheduler = scheduler {
            self.scheduler = scheduler
        } else {
            self.scheduler = UnleashScheduler.every(interval: refreshInterval)
        }
        self.scheduler.delegate = self

        start()
    }

    // MARK: Start
    private func start() {
        fetchToggles { [self] errorResult in
            if let error = errorResult {
                DispatchQueue.main.async {
                    self.delegate?.unleashDidFail(self, withError: error)
                }
            } else {
                scheduler.do {
                    self.fetchToggles() { _ in
                        DispatchQueue.main.async {
                            self.delegate?.unleashDidLoad(self)
                        }
                    }
                }
                scheduler.resume()
            }
        }
    }

    // MARK: Fetch Toggles
    private func fetchToggles(completion: @escaping (Error?) -> Void) {
        guard
            let url = URL(string: self.url)
        else { return completion(UnleashError.noURLProvided) }

        DispatchQueue.global().async { [self] in
            let result = toggleRepository.get(url: url)
            switch result {
            case (_, nil):
                completion(nil)
            case (nil, let error):
                completion(error)
            default:
                break
            }
        }
    }

    // MARK: Is Enabled
    public func isEnabled(name: String) -> Bool {
        guard
            let feature = toggles?.features.first(where: { $0.name == name }),
            feature.enabled
        else { return false }

        for strategy in feature.strategies {
            guard
                let targetStrategy = strategies.first(where: { $0.name == strategy.name }),
                let parameters = strategy.parameters
            else { continue }

            if targetStrategy.isEnabled(parameters: parameters) {=
                return true
            }
        }
        return false
    }
}

// MARK: - Scheduler Delegate
extension Unleash: SchedulerDelegate {
    func schedulerDidFail(_ scheduler: Scheduler, withError error: Error) {
        DispatchQueue.main.async {
            self.delegate?.unleashDidFail(self, withError: error)
        }
    }
}
