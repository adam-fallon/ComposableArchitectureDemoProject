//
//  UserClientError.swift
//  ComposableArchitectureDemoProject
//
//  Created by Adam Fallon on 13/12/2022.
//

import Foundation

enum UserClientError: Error {
    case failedToFormatCredentials
    case invalidUser
    case other(Error)
}

extension UserClientError: Equatable {
    static func == (lhs: UserClientError, rhs: UserClientError) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
}

extension UserClientError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .failedToFormatCredentials:
            return "Check username and password again."
        case .invalidUser:
            return "Login failed."
        default:
            return "Oops, something went wrong. Please try again."
        }
    }
}
