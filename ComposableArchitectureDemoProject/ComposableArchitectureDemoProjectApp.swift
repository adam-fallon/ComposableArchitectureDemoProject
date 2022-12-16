//
//  ComposableArchitectureDemoProject.swift
//  ComposableArchitectureDemoProject
//
//  Created by Adam Fallon on 13/12/2022.
//

import SwiftUI
import ComposableArchitecture

@main
struct ComposableArchitectureDemoProject: App {
    var uiTesting: Bool
    
    init() {
        uiTesting = ProcessInfo.processInfo.arguments.contains("isRunningUITests")
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(
                store: Store(
                    initialState:AppContext.State(),
                    reducer: WrappedAppContext(isLive: !uiTesting)
                )
            )
        }
    }
}
