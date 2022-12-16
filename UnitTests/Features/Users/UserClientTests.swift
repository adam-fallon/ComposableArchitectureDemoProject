//
//  UserClientTests.swift
//  UnitTests
//
//  Created by Adam Fallon on 15/12/2022.
//

import XCTest
import ComposableArchitecture

@MainActor
final class UserClientTests: XCTestCase {
    // MARK: Happy Path
    func testLogin() async {
        let user = TestHelpers.Users.validUserWithFolderAtRoot
        let store = TestStore(
            initialState: UserStore.State(),
            reducer: UserStore()
        )
        
        // Using the production Items Client
        store.dependencies.userClient = .live
        
        store.dependencies.apiConfiguration = APIConfiguration(getURL: { endpoint in
           URL(string: "http://TESTING")!
        })
        
        store.dependencies.httpClient = HTTPClient(data: { request in
            guard let response =
            """
            {
              "firstName": "Adam",
              "lastName": "Fallon - Folder",
              "rootItem": {
                "id": "parentFolder",
                "name": "My Folder",
                "isDir": true,
                "modificationDate": "12 Jan 2022",
                "size": 10.0
              },
            }
            """.data(using: .utf8) else {
                XCTFail("Failed to create data for JSON string")
                return (Data(), URLResponse())
            }
            return (response, URLResponse())
        })
        
        await store.send(.loadUser("username", "password")) {
            $0.loading = true
        }
        
        await store.receive(.requestResponse(.success(user))) {
            $0.loading = false
            $0.user = user
        }
    }
    
    func testLoginFailsToEncodeUser() async {
        guard let badData = "Some String".data(using: .utf8) else {
            return XCTFail(TestHelpers.testSetupFailed)
        }
        
        let expectedError = UserClientError.other(
            DecodingError.dataCorrupted(
              DecodingError.Context(
                codingPath: [],
                debugDescription: "The given data was not valid JSON.",
                underlyingError: NSError(
                  domain: "NSCocoaErrorDomain",
                  code: 3840,
                  userInfo: [
                    "NSDebugDescription": "Unable to parse empty data."
                  ]
                )
              )
            )
          )
        
        let store = TestStore(
            initialState: UserStore.State(),
            reducer: UserStore()
        )
        
        // Using the production Items Client
        store.dependencies.userClient = .live
        
        store.dependencies.apiConfiguration = APIConfiguration(getURL: { endpoint in
           URL(string: "http://TESTING")!
        })
        
        store.dependencies.httpClient = HTTPClient(data: { request in
            return (badData, URLResponse())
        })
        
        await store.send(.loadUser("username", "password")) {
            $0.loading = true
        }
        
        await store.receive(.requestResponse(.failure(expectedError))) {
            $0.errorReason = "Oops, something went wrong. Please try again."
            $0.loading = false
        }
    }
    
    func testLoginWithEmptyValues() async {
        guard let badData = "Some String".data(using: .utf8) else {
            return XCTFail(TestHelpers.testSetupFailed)
        }

        let store = TestStore(
            initialState: UserStore.State(),
            reducer: UserStore()
        )
        
        // Using the production Items Client
        store.dependencies.userClient = .live
        
        store.dependencies.apiConfiguration = APIConfiguration(getURL: { endpoint in
           URL(string: "http://TESTING")!
        })
        
        store.dependencies.httpClient = HTTPClient(data: { request in
            return (badData, URLResponse())
        })
        
        await store.send(.loadUser("", "")) {
            $0.loading = true
        }
        
        await store.receive(.requestResponse(.failure(UserClientError.invalidUser))) {
            $0.errorReason = "Login failed."
            $0.loading = false
        }
    }
}
