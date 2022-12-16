//
//  APIConfiguration.swift
//  ComposableArchitectureDemoProject
//
//  Created by Adam Fallon on 13/12/2022.
//

import Foundation
import ComposableArchitecture

enum Endpoint: Hashable {
    case user
    case items
}

protocol API {
    static var baseURL: URL { get }
}

private enum APIEndpoint {
    enum User: String, API {
        static var baseURL: URL = URL(string: "SERVER_ENDPOINT")!
        case me = "me"
    }
    
    enum Items: String, API {
        static var baseURL: URL = URL(string: "SERVER_ENDPOINT")!
        case items = "items"
    }
}

private extension RawRepresentable where RawValue == String, Self: API {
    var url: URL { Self.baseURL.appendingPathComponent(rawValue) }
}

struct APIConfiguration {
    var getURL: (Endpoint) -> URL
}

extension APIConfiguration {
    static let live = Self(
        getURL: { endpoint in
            switch endpoint {
            case .user:
                return APIEndpoint.User.me.url
            case .items:
                return APIEndpoint.Items.items.url
            }
        }
    )
}

extension APIConfiguration {
    static let unimplemented = Self(
        getURL: { _ in fatalError("Looks like you are trying to use a real API call from a test. Don't do that!") }
    )
}

extension APIConfiguration: DependencyKey {
    static let liveValue = APIConfiguration.live
}

extension DependencyValues {
    var apiConfiguration: APIConfiguration {
        get { self[APIConfiguration.self] }
        set { self[APIConfiguration.self] = newValue }
    }
}
