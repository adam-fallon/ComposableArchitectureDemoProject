//
//  ItemsClient.swift
//  ComposableArchitectureDemoProject
//
//  Created by Adam Fallon on 13/12/2022.
//

import Foundation
import ComposableArchitecture

struct ItemSearchResult: Decodable, Equatable, Sendable {
    var results: [Item]
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        results = try container.decode([Item].self)
    }
}

struct ItemsClient {
    @Dependency (\.appContext) static var appContext    
    
    /// Return the content of a folder.
    var getItemsForItem: @Sendable (Item, String) async throws -> [Item]
    
    /// Return the content of an item.
    var getDataForItem: @Sendable (Item, String) async throws -> Data
}

extension ItemsClient {
    static let live = Self(
        getItemsForItem: { item, auth in
            let getItemsForItemURL = appContext
                .apiConfiguration
                .getURL(.items)
                .appendingPathComponent("\(item.id)")
        
            var request = URLRequest(url: getItemsForItemURL)
            request.addValue("Basic \(auth)",
                             forHTTPHeaderField: "Authorization")
            request.addValue("application/json",
                             forHTTPHeaderField: "Content-Type")
            
            let (data, _) = try await appContext
                .httpClient
                .data(request)
            
            return try appContext
                .jsonDecoders
                .decoder(.iso8601)
                .decode([Item].self,
                        from: data)
        },
        
        getDataForItem: { item, auth in
            let getItemsForItemURL = appContext
                .apiConfiguration
                .getURL(.items)
                .appendingPathComponent("\(item.id)")
                .appendingPathComponent("data")
        
            var request = URLRequest(url: getItemsForItemURL)
            request.addValue("Basic \(auth)",
                             forHTTPHeaderField: "Authorization")
            request.addValue("application/json",
                             forHTTPHeaderField: "Content-Type")
            
            let (data, _) = try await appContext
                .httpClient
                .data(request)
            
            return data
        }
    )
}

extension ItemsClient: DependencyKey {
    static let liveValue = ItemsClient.live
}

// MARK: Register as a dependency
extension DependencyValues {
  var itemsClient: ItemsClient {
    get { self[ItemsClient.self] }
    set { self[ItemsClient.self] = newValue }
  }
}
