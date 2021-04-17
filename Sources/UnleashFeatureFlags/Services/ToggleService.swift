//
//  ToggleService.swift
//  UnleashFeatureFlags
//
//  Created by mac on 17.04.2021.
//  Copyright © 2021 Олег Герман. All rights reserved.
//

import Foundation

protocol ToggleServiceProtocol {
    func fetchToggles(url: URL) -> (Toggles?, Error?)
}

struct ToggleService: ToggleServiceProtocol {
    private let appName: String
    private let instanceId: String

    private let fetchTogglesQueue = DispatchQueue(label: "Unleash.ToggleService",
                                                  qos: .utility,
                                                  attributes: .concurrent)

    
    init(appName: String, instanceId: String) {
        self.appName = appName
        self.instanceId = instanceId
    }
}

extension ToggleService {
    func fetchToggles(url: URL) -> (Toggles?, Error?) {
        requestToggles(url: url)
    }
    
    private func makeUrlRequest(url: URL) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(instanceId, forHTTPHeaderField: "UNLEASH-INSTANCEID")
        request.addValue(appName, forHTTPHeaderField: "UNLEASH-APPNAME")
        request.addValue(self.appName, forHTTPHeaderField: "User-Agent")
        return request
    }
}

extension ToggleService {
    func requestToggles(url: URL) -> (Toggles?, Error?) {
        var toggles: Toggles?
        var errorResponse: Error?
        let locker = NSLock()
        locker.lock()
        fetchTogglesQueue.async {
            do {
                URLSession.shared.dataTask(with: try makeUrlRequest(url: url)) { data, response, error in
                    if error != nil {
                        errorResponse = error
                        locker.unlock()
                        return
                    }
                    if let dataDecoder = data {
                        do {
                            toggles = try JSONDecoder().decode(Toggles.self, from: dataDecoder)
                        } catch (let error) {
                            errorResponse = error
                        }
                        locker.unlock()
                        return
                    }
                }.resume()
            } catch(let error) {
                errorResponse = error
                locker.unlock()
            }
        }
        locker.lock()
        return (toggles, errorResponse)
    }
}
