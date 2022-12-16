//
//  ItemsClientError.swift
//  ComposableArchitectureDemoProject
//
//  Created by Adam Fallon on 14/12/2022.
//

import Foundation

enum ItemsClientError: Error {
    case itemsNotFound(String)
    case parsingError
    case failedToNavigateToParent
    case noAuthString
    case other
}

extension ItemsClientError: Equatable {
    static func == (lhs: ItemsClientError, rhs: ItemsClientError) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
}

extension ItemsClientError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noAuthString:
            return "Failed to authorize request. Try logging out and back in."
        default:
            return "Oops, something went wrong. Please try again."
        }
    }
}
