//
//  ItemStoreTests.swift
//  UnitTests
//
//  Created by Adam Fallon on 14/12/2022.
//
import XCTest
import ComposableArchitecture
@testable import ComposableArchitectureDemoProject

@MainActor
final class ItemsStoreTests: XCTestCase {
    let underTest = ItemsStore()
    
    // MARK: Happy Path
    func testGetItemStoreWithValidUserWithFileAsRootItem() async {
        // Given I have a valid user with a file at the root
        let user = TestHelpers.Users.validUserWithFileAtRoot
        
        guard let rootItem = user.rootItem else {
            return XCTFail(TestHelpers.testSetupFailed)
        }
        
        let store = TestStore(
            initialState: ItemsStore.State(user: user),
            reducer: ItemsStore()
        )
        
        // When sending an action items for an item.
        await store.send(.tapItem(rootItem)) {
            $0.selectedItem = rootItem
        }
        
        // A request for that items data should be sent
        await store.receive(.requestItemData(rootItem))
        
        // And I should get back the files data in response
        await store.receive(.gotResponseForItemData(.success(Data()))) {
            $0.data = Data()
        }        
    }
    
    func testGetNestedItemStoreWithValidUserWithFolderAsRootItemWithChildren() async {
        // Given I have a valid user with a folder at the root
        let user = TestHelpers.Users.validUserWithFolderAtRoot
        let expectedItems = [
            TestHelpers.Items.childFile,
            TestHelpers.Items.childFolder
        ]
        
        guard let rootItem = user.rootItem else {
            return XCTFail(TestHelpers.testSetupFailed)
        }
        
        let store = TestStore(
            initialState: ItemsStore.State(user: user),
            reducer: ItemsStore()
        )
        
        // When sending an action items for an item.
        await store.send(.tapItem(rootItem)) {
            $0.selectedItem = rootItem
        }
        
        // A request for that items data should be sent
        await store.receive(.requestItem(rootItem))
        
        // Then I should receive some files back when I get child items of the folder back
        await store.receive(.gotResponseForItem(.success(expectedItems))) {
            $0.items = expectedItems
            $0.prevItems = [[]]
        }
    }
    
    func testGetNestedItemStoreWithValidUserWithFolderAsRootItemWithGrandChildren() async {
        // Given I have a valid user with a folder at the root
        let user = TestHelpers.Users.validUserWithFolderAtRoot
        let expectedItems = [
            TestHelpers.Items.childFile,
            TestHelpers.Items.childFolder
        ]
        
        guard let rootItem = user.rootItem else {
            return XCTFail(TestHelpers.testSetupFailed)
        }
        
        let store = TestStore(
            initialState: ItemsStore.State(user: user),
            reducer: ItemsStore()
        )
        
        // When sending an action items for an item.
        await store.send(.tapItem(rootItem)) {
            $0.selectedItem = rootItem
        }
        
        await store.receive(.requestItem(rootItem))
        
        // Then I should receive some files back when I get child items of the folder back
        await store.receive(.gotResponseForItem(.success(expectedItems))) {
            $0.items = expectedItems
            $0.prevItems = [[]]
        }
        
        // Then sending another action to a folder with a grandchild
        await store.send(.tapItem(TestHelpers.Items.childFolder)) {
            $0.selectedItem = TestHelpers.Items.childFolder
        }
        await store.receive(.requestItem(TestHelpers.Items.childFolder))
        
        // Now I am deeply nested and should have two prev items on the stack
        await store.receive(.gotResponseForItem(.success([TestHelpers.Items.grandChildFolder]))) {
            $0.items = [TestHelpers.Items.grandChildFolder]
            $0.prevItems = [[], expectedItems]
        }
    }
    
    func testGetItemWithInvalidUserWithFile() async {
        let user = TestHelpers.Users.invalidUserWithNoAuthStringWithFile
        let store = TestStore(
            initialState: ItemsStore.State(user: user),
            reducer: ItemsStore()
        )
        
        guard let rootItem = user.rootItem else {
            return XCTFail(TestHelpers.testSetupFailed)
        }
        
        // When sending an action items for an item.
        await store.send(.tapItem(rootItem)) {
            $0.selectedItem = rootItem
        }
        
        // Should Request Data and not receive any other events
        await store.receive(.requestItemData(rootItem)) {
            $0.error = ItemsClientError.noAuthString.localizedDescription
        }
    }
    
    // MARK: Failed User Requests
    func testGetItemWithInvalidUserWithFolder() async {
        let user = TestHelpers.Users.invalidUserWithNoAuthStringWithFolder
        let store = TestStore(
            initialState: ItemsStore.State(user: user),
            reducer: ItemsStore()
        )
        
        guard let rootItem = user.rootItem else {
            return XCTFail(TestHelpers.testSetupFailed)
        }
        
        // When sending an action items for an item.
        await store.send(.tapItem(rootItem)) {
            $0.selectedItem = rootItem
        }
        
        await store.receive(.requestItem(rootItem)) {
            $0.error = ItemsClientError.noAuthString.localizedDescription
        }
    }
    
    // MARK: Unhappy API
    func testGetItemsWithValidUserWithFolderReturnsEmptyFolder() async {
        let user = TestHelpers.Users.validUserWithFolderAtRoot
        let store = TestStore(
            initialState: ItemsStore.State(user: user),
            reducer: ItemsStore()
        )
        
        // When the API responds empty request for my request
        store.dependencies.itemsClient.getItemsForItem = { item, auth in
            return []
        }
        
        guard let rootItem = user.rootItem else {
            return XCTFail(TestHelpers.testSetupFailed)
        }
        
        // When sending an action items for an item.
        await store.send(.tapItem(rootItem)) {
            $0.selectedItem = rootItem
        }
        
        await store.receive(.requestItem(rootItem))
        
        await store.receive(.gotResponseForItem(.success([])))
    }
    
    func testGetItemsWithValidUserWithFolderReturnsError() async {
        let user = TestHelpers.Users.validUserWithFolderAtRoot
        let store = TestStore(
            initialState: ItemsStore.State(user: user),
            reducer: ItemsStore()
        )
        
        // When the API responds empty request for my request
        store.dependencies.itemsClient.getItemsForItem = { item, auth in
            throw ItemsClientError.other
        }
        
        guard let rootItem = user.rootItem else {
            return XCTFail(TestHelpers.testSetupFailed)
        }
        
        // When sending an action items for an item.
        await store.send(.tapItem(rootItem)) {
            $0.selectedItem = rootItem
        }
        
        await store.receive(.requestItem(rootItem))
        
        await store.receive(.gotResponseForItem(.failure(ItemsClientError.other))) {
            $0.error = ItemsClientError.other.localizedDescription
        }
    }
    
    func testGetItemDataWithValidUserWithFileReturnsError() async {
        let user = TestHelpers.Users.validUserWithFileAtRoot
        let store = TestStore(
            initialState: ItemsStore.State(user: user),
            reducer: ItemsStore()
        )
        
        // When the API responds empty request for my request
        store.dependencies.itemsClient.getDataForItem = { item, auth in
            throw ItemsClientError.other
        }
        
        guard let rootItem = user.rootItem else {
            return XCTFail(TestHelpers.testSetupFailed)
        }
        
        // When sending an action items for an item.
        await store.send(.tapItem(rootItem)) {
            $0.selectedItem = rootItem
        }
        
        await store.receive(.requestItemData(rootItem))
        
        await store.receive(.gotResponseForItemData(.failure(ItemsClientError.other))) {
            $0.error = ItemsClientError.other.localizedDescription
        }
    }
    
    // MARK: View Stuff
    func testSheetIsPresentedWhenItemSelected() async {
        let user = TestHelpers.Users.validUserWithFileAtRoot
        
        guard let selectedItem = user.rootItem else {
            return XCTFail(TestHelpers.testSetupFailed)
        }
        
        let store = TestStore(
            initialState: ItemsStore.State(user: user,
                                           selectedItem: selectedItem),
            reducer: ItemsStore()
        )
        
        await store.send(.setSheet(isPresented: true))
        
        await store.receive(.requestItemData(selectedItem))
        await store.receive(.gotResponseForItemData(.success(Data()))) {
            $0.data = Data()
        }
    }
    
    func testSheetIsPresentedWhenNoItemSelected() async {
        let user = TestHelpers.Users.validUserWithFileAtRoot

        let store = TestStore(
            initialState: ItemsStore.State(user: user),
            reducer: ItemsStore()
        )
        
        await store.send(.setSheet(isPresented: true))
    }
    
    func testSheetIsPresentedThenDismissed() async {
        let user = TestHelpers.Users.validUserWithFileAtRoot
        
        guard let selectedItem = user.rootItem else {
            return XCTFail(TestHelpers.testSetupFailed)
        }
        
        let store = TestStore(
            initialState: ItemsStore.State(user: user,
                                           selectedItem: selectedItem),
            reducer: ItemsStore()
        )
        
        await store.send(.setSheet(isPresented: true))
        await store.receive(.requestItemData(selectedItem))
        await store.receive(.gotResponseForItemData(.success(Data()))) {
            $0.data = Data()
        }
        await store.send(.setSheet(isPresented: false)) {
            $0.selectedItem = nil
            $0.data = nil
        }
    }
    
    func navigateBack() async {
        let user = TestHelpers.Users.validUserWithFileAtRoot

        let store = TestStore(
            initialState: ItemsStore.State(user: user),
            reducer: ItemsStore()
        )
        
        await store.send(.setSheet(isPresented: false))
    }
}
