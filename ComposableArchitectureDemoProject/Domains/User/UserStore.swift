//
//  UserStore.swift
//  ComposableArchitectureDemoProject
//
//  Created by Adam Fallon on 13/12/2022.
//

import ComposableArchitecture

struct UserStore: ReducerProtocol  {
    @Dependency(\.userClient) var userClient
    
    private enum UserID {}
    
    struct State: Equatable {
        var user: User?
        var loading: Bool = false
        var errorReason: String? = nil
    }

    enum Action: Equatable {
        case loadUser(String, String)
        // Side Effects
        case requestResponse(TaskResult<User>)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .loadUser(let username, let password):
            state.loading = true
            return .task {
                await .requestResponse(
                    TaskResult {
                        try await self.userClient.getUser(username, password)
                    }
                )
            }
            .cancellable(id: UserID.self)
        case let .requestResponse(.success(user)):
            state.errorReason = nil
            state.user = user
            state.loading = false
            return .none
        case .requestResponse(.failure(let error)):            
            state.errorReason = error.localizedDescription
            state.loading = false
            return .none
        }
    }
}
