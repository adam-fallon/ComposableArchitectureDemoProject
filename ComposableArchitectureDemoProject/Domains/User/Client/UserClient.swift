//
//  UserClient.swift
//  ComposableArchitectureDemoProject
//
//  Created by Adam Fallon on 13/12/2022.
//

import Foundation
import ComposableArchitecture

struct UserClient {
    @Dependency (\.appContext) static var appContext
    
    /// Return the current user. Use to retrieve the root item.
    var getUser: @Sendable (String, String) async throws -> User
}

extension UserClient {
    static let live = Self(
        getUser: { username, password in
            let getUserUrl = appContext.apiConfiguration.getURL(.user)
            
            guard !username.isEmpty && !password.isEmpty else {
                throw UserClientError.invalidUser
            }
            
            let loginString = "\(username):\(password)"
            
            guard let loginData = loginString.data(using: .utf8) else {
                throw UserClientError.failedToFormatCredentials
            }
            
            let loginHeader = loginData.base64EncodedString()
            
            var request = URLRequest(url: getUserUrl)
            request.addValue("Basic \(loginHeader)",
                             forHTTPHeaderField: "Authorization")
            request.addValue("application/json",
                             forHTTPHeaderField: "Content-Type")
            
            let (data, _) = try await appContext
                .httpClient
                .data(request)
            
            do {
                var user = try appContext
                    .jsonDecoders
                    .decoder(.iso8601)
                    .decode(User.self,
                            from: data)
                user.authString = loginHeader
                return user
            } catch let error {
                throw UserClientError.other(error)
            }
        }
    )
}

extension UserClient: DependencyKey {
    static let liveValue = UserClient.live
}

extension DependencyValues {
  var userClient: UserClient {
    get { self[UserClient.self] }
    set { self[UserClient.self] = newValue }
  }
}
