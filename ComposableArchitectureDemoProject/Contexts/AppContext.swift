//
//  AppContext.swift
//  ComposableArchitectureDemoProject
//
//  Created by Adam Fallon on 13/12/2022.
//

import Foundation
import ComposableArchitecture

struct AppContext: ReducerProtocol {
    @Dependency (\.httpClient) var httpClient
    @Dependency (\.jsonDecoders) var jsonDecoders
    @Dependency (\.apiConfiguration) var apiConfiguration
    
    // Scopes
    enum State: Equatable {
        case user(UserStore.State)
        case items(ItemsStore.State)
        
        init() {
            self = .user(UserStore.State())
        }
    }
        
    enum Action: Equatable {
      case user(UserStore.Action)
      case items(ItemsStore.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        Scope(state: /AppContext.State.user, action: /Action.user) {
          UserStore()
        }
        Scope(state: /AppContext.State.items, action: /Action.items) {
            ItemsStore()
        }
        Reduce { state, action in
            switch action {
            case .user(.requestResponse(.success(let user))):
                guard let rootItem = user.rootItem else {
                    state = .items(ItemsStore.State(items: [],
                                                   user: user)
                    )
                    
                    return .none
                }
                
                state = .items(ItemsStore.State(items: [rootItem],
                                               user: user)
                )
                return .none
            default:
                return .none
            }
        }        
    }
}

extension AppContext {
    public static let live = Self()
}

extension AppContext {
    public static let test = Self()
}

extension AppContext: DependencyKey {
    static let liveValue = AppContext.live
}

extension AppContext: TestDependencyKey {
    static let testValue = AppContext.test
}

extension DependencyValues {
    var appContext: AppContext {
        get { self[AppContext.self] }
        set { self[AppContext.self] = newValue }
    }
}

struct WrappedAppContext: ReducerProtocol {
    var isLive: Bool
    
    var body: some ReducerProtocol<AppContext.State, AppContext.Action> {
        Reduce { state, action in
            print(state, action)
            return .none
        }
        
        AppContext()
            .dependency(\.apiConfiguration, isLive ? .live : .unimplemented)
            .dependency(\.userClient, isLive ? .live : .test)
            .dependency(\.itemsClient, isLive ? .live : .test)
            .dependency(\.httpClient, isLive ? .live : .test)
            .dependency(\.appContext, isLive ? .live : .test)
  }
}
