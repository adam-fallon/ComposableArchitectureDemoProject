//
//  LoginView.swift
//  ComposableArchitectureDemoProject
//
//  Created by Adam Fallon on 14/12/2022.
//

import SwiftUI
import ComposableArchitecture

struct LoginView: View {
    let store: StoreOf<UserStore>
    
    @State var userName: String = ""
    @State var password: String = ""
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                if let error = viewStore.errorReason {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                        .accessibilityIdentifier("error")
                }
                Form {
                    TextField("Username", text: $userName)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .accessibilityIdentifier("email")
                    SecureField("Password", text: $password)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .accessibilityIdentifier("password")
                    Button("Log in") {
                        viewStore.send(.loadUser(userName, password))
                    }
                    .disabled(viewStore.state.loading)
                    .accessibilityIdentifier("login")
                }
            }
        }
    }
}
