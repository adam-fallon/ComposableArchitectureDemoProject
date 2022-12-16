//
//  ItemsStore.swift
//  ComposableArchitectureDemoProject
//
//  Created by Adam Fallon on 13/12/2022.
//

import ComposableArchitecture
import Foundation

struct ItemsStore: ReducerProtocol  {
    @Dependency(\.itemsClient) var itemsClient
    
    struct State: Equatable {
        var items: [Item] = []
        var prevItems: [[Item]] = []
        let user: User
        var selectedItem: Item? = nil
        var isSheetPresented: Bool {
            guard let selectedItem = selectedItem else {
                return false
            }
            
            return !selectedItem.isDir
        }
        var data: Data? = nil
        var error: String?
    }

    enum Action: Equatable {
        // ViewActions
        case tapItem(Item)
        case navigateBack
        
        // Requests
        case requestItem(Item)
        case requestItemData(Item)
        
        // Responses
        case gotResponseForItem(TaskResult<[Item]>)
        case gotResponseForItemData(TaskResult<Data>)
        
        // Side Effects
        case setSheet(isPresented: Bool)        
    }
    
    struct ItemsStoreID {}
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            // MARK: Requests
            case .requestItem(let item):
                guard let auth = state.user.authString else {
                    state.error = ItemsClientError.noAuthString.localizedDescription
                    return .none
                }
                return .task {
                    await .gotResponseForItem(TaskResult {
                        try await self.itemsClient.getItemsForItem(item, auth)
                    })
                }
                .cancellable(id: ItemsStoreID.self)
                
            case .requestItemData(let item):
                guard let auth = state.user.authString else {
                    state.error = ItemsClientError.noAuthString.localizedDescription
                    return .none
                }
                
                return .task {
                    await .gotResponseForItemData(TaskResult {
                        try await self.itemsClient.getDataForItem(item, auth)
                    })
                }
                .cancellable(id: ItemsStoreID.self)
                
            // MARK: Responses
            case .gotResponseForItem(.success(let items)):
                if !items.isEmpty {
                    state.prevItems.append(state.items)
                    state.items = items
                } else {
                    state.items = []
                }
                return .none
            
            case .gotResponseForItem(.failure(let error)):                
                state.error = error.localizedDescription
                return .none
            
            case .gotResponseForItemData(.success(let data)):
                state.data = data
                return .none
            
            case .gotResponseForItemData(.failure(let error)):
                state.error = error.localizedDescription
                return .none
                
            // MARK: View Actions
            case .tapItem(let item):
                
                state.selectedItem = item
                
                if item.isDir {
                    return .task {
                        .requestItem(item)
                    }
                } else {
                    return .task {
                        .requestItemData(item)
                    }
                    .cancellable(id: ItemsStoreID.self)
                }

            case .setSheet(isPresented: false):
                state.selectedItem = nil
                state.data = nil
                return .none
                
            case .setSheet(isPresented: true):
                guard let item = state.selectedItem else {
                    return .none
                }
                
                return .task {
                    return .requestItemData(item)
                }
                .cancellable(id: ItemsStoreID.self)
            case .navigateBack:
                guard let prevItems = state.prevItems.popLast() else {
                    return .none
                }
                state.items = prevItems                
                return .none
            }
        }
    }
}
