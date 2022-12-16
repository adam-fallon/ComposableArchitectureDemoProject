//
//  ItemsClientTests.swift
//  UnitTests
//
//  Created by Adam Fallon on 15/12/2022.
//

import XCTest
import ComposableArchitecture
@testable import ComposableArchitectureDemoProject

@MainActor
final class ItemsClientTests: XCTestCase {
    private let authString = "DummyAuthString"
    
    // Mark: Happy Path - Get Items for Item
    func testGetItemsForItem() async throws {
        let user = TestHelpers.Users.validUserWithFileAtRoot
        
        guard let rootItem = user.rootItem else {
            return XCTFail(TestHelpers.testSetupFailed)
        }
        
        let store = TestStore(
            initialState: ItemsStore.State(user: user),
            reducer: ItemsStore()
        )
        
        // Using the production Items Client
        store.dependencies.itemsClient = .live
        
        store.dependencies.apiConfiguration = APIConfiguration(getURL: { endpoint in
           URL(string: "http://TESTING")!
        })
        
        store.dependencies.httpClient = HTTPClient(data: { request in
            return (Data(), URLResponse())
        })
        
        await store.send(.tapItem(rootItem)) { $0.selectedItem = rootItem }
        await store.receive(.requestItemData(rootItem))
        await store.receive(.gotResponseForItemData(.success(Data()))) { $0.data = Data() }
    }
    
    func testClientReturnsCorrectDataFromHTTPClient() async throws {
        let user = TestHelpers.Users.validUserWithFileAtRoot
        guard let rootItem = user.rootItem,
              let someData = "Some String".data(using: .utf8) else {
            return XCTFail(TestHelpers.testSetupFailed)
        }
        
        let store = TestStore(
            initialState: ItemsStore.State(user: user),
            reducer: ItemsStore()
        )
        
        // Using the production Items Client
        store.dependencies.itemsClient = .live
        
        store.dependencies.apiConfiguration = APIConfiguration(getURL: { endpoint in
           URL(string: "http://TESTING")!
        })
        
        store.dependencies.httpClient = HTTPClient(data: { request in
            return (someData, URLResponse())
        })
        
        await store.send(.tapItem(rootItem)) { $0.selectedItem = rootItem }
        await store.receive(.requestItemData(rootItem))
        await store.receive(.gotResponseForItemData(.success(someData))) {
            $0.data = someData
        }
    }
    
    // MARK - Bad Data
    func testClientThrowsWhenGettingBadResponseFromHTTPClient() async throws {
        let user = TestHelpers.Users.validUserWithFolderAtRoot
        guard let rootItem = user.rootItem,
              let badData = "Some String".data(using: .utf8) else {
            return XCTFail(TestHelpers.testSetupFailed)
        }
        
        let store = TestStore(
            initialState: ItemsStore.State(user: user),
            reducer: ItemsStore()
        )
        
        // Using the production Items Client
        store.dependencies.itemsClient = .live
        
        store.dependencies.apiConfiguration = APIConfiguration(getURL: { endpoint in
           URL(string: "http://TESTING")!
        })
        
        store.dependencies.httpClient = HTTPClient(data: { request in
            return (badData, URLResponse())
        })

        await store.send(.tapItem(rootItem)) { $0.selectedItem = rootItem }
        await store.receive(.requestItem(rootItem))
        await store.receive(.gotResponseForItem(.failure(DecodingError.jsonDecodingError))) {
            $0.error = "The data couldn’t be read because it isn’t in the correct format."
        }
    }
}


private extension DecodingError {
    static let jsonDecodingError = DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: [],
          debugDescription: "The given data was not valid JSON.",
          underlyingError: NSError(
            domain: "NSCocoaErrorDomain",
            code: 3840,
            userInfo: [
              "NSDebugDescription": "Invalid value around line 1, column 0.",
              "NSJSONSerializationErrorIndex": 0
            ]
          )
        )
      )
}

extension DecodingError: Equatable {
    public static func == (lhs: DecodingError, rhs: DecodingError) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }
}
