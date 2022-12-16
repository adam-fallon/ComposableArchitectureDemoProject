//
//  TestUserClient.swift
//  ComposableArchitectureDemoProject
//
//  Created by Adam Fallon on 13/12/2022.
//

import Foundation
import Dependencies

extension UserClient {
    private typealias UserEntry = (password: String, rootFile: Item)
        
    static let test = UserClient(
        getUser: { userName, password in
            let launchArgs = ProcessInfo.processInfo.arguments
            var validUsers: [String: (password: String, user: User)] = [
                "file": ("password123", TestHelpers.Users.validUserWithFileAtRoot),
                "folder": ("password123", TestHelpers.Users.validUserWithFolderAtRoot)
            ]
            
            if launchArgs.contains("UserServiceDown") {
                throw UserClientError.other(NSError(domain:"", code:500, userInfo:nil))
            }
            
            if let authenticatedUser = validUsers[userName] {
                return authenticatedUser.user
            } else {
                throw UserClientError.invalidUser
            }
    })
}

extension UserClient: TestDependencyKey {
    static let testValue = UserClient.test
}
