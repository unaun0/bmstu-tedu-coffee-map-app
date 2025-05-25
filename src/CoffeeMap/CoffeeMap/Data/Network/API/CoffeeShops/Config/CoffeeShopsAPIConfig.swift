//
//  CoffeeShopsAPIConfig.swift
//  CoffeeMap
//
//  Created by Цховребова Яна on 21.05.2025.
//

import Foundation

struct CoffeeShopsAPIConfig: ConfigInput {
    private static func stringValue(forKey key: String) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String, !value.isEmpty else {
            fatalError("Missing or empty configuration value for key: \(key)")
        }
        return value
    }

    private static func intValue(forKey key: String) -> Int {
        guard let stringValue = Bundle.main.object(forInfoDictionaryKey: key) as? String,
              let intValue = Int(stringValue) else {
            fatalError("Invalid integer configuration value for key: \(key)")
        }
        return intValue
    }

    static var apiProtocol: String {
        stringValue(forKey: "API_PROTOCOL")
    }

    static var apiHost: String {
        stringValue(forKey: "API_HOST")
    }

    static var apiPort: Int {
        intValue(forKey: "API_PORT")
    }

    static var apiPath: String {
        stringValue(forKey: "API_PATH")
    }

    static var baseURL: URL {
        var components = URLComponents()
        components.scheme = apiProtocol
        components.host = apiHost
        components.port = apiPort
        components.path = apiPath

        guard let url = components.url else {
            fatalError("Could not create a valid URL")
        }
        return url
    }
}
