//
//  RootView.swift
//  ComposableArchitectureDemoProject
//
//  Created by Adam Fallon on 13/12/2022.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    let store: StoreOf<AppContext>
    
    public init(store: StoreOf<AppContext>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack {
            SwitchStore(self.store) {
                CaseLet(state: /AppContext.State.user,
                        action: AppContext.Action.user) { store in
                    LoginView(store: store)
                        .navigationBarTitle("Files - Login")
                }
                CaseLet(state: /AppContext.State.items,
                        action: AppContext.Action.items) { store in
                    ItemListView(store: store)
                        .navigationBarTitle("Files")
                }
            }
        }
    }
}
