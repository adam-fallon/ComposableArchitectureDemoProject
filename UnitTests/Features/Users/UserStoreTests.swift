//
//  UserStoreTests.swift
//  UnitTests
//
//  Created by Adam Fallon on 13/12/2022.
//

import XCTest
import ComposableArchitecture
@testable import ComposableArchitectureDemoProject

@MainActor
final class UserStoreTests: XCTestCase {
    let underTest = UserStore()
    
    func testUserStoreWhenLoginSuccessful() async {
        // Given a test store that returns a valid user
        let expectedUser = TestHelpers.Users.validUserWithFileAtRoot
        
        let store = TestStore(
            initialState: UserStore.State(),
            reducer: UserStore()
        )
        
        // When an event is sent to the store with a username and password
        await store.send(.loadUser("file", "password123")) {
            $0.loading = true
        }
        
        // Then an Event is sent updating the user
        await store.receive(.requestResponse(.success(expectedUser))) {
            $0.user = expectedUser
            $0.loading = false
        }
    }
    
    func testUserStoreWhenLoginInvalidUser() async {
        // Given a test store that returns a non existing user
        let store = TestStore(
            initialState: UserStore.State(),
            reducer: UserStore()
        )
        
        // When an event is sent to the store with a username and password that doesn't exist in the 'database'
        await store.send(.loadUser("notARealUser", "password123")) {
            $0.loading = true
        }
        
        // Then an Event is sent with an error
        await store.receive(.requestResponse(.failure(UserClientError.invalidUser))) {
            $0.loading = false
            $0.errorReason = "Login failed."
        }
    }
    
}
