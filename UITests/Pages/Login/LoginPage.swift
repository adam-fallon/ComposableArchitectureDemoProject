//
//  LoginPage.swift
//  UITests
//
//  Created by Adam Fallon on 14/12/2022.
//

import Foundation
import XCTest

struct LoginPage: PageObject {
    let app: XCUIApplication
    
    private enum Identifiers {
        static let email = "email"
        static let password = "password"
        static let error = "error"
        static let login = "login"
    }
    
    var isShowing: Bool {
        return app
            .staticTexts
            .matching(NSPredicate(format: "label CONTAINS 'Files - Login'"))
            .firstMatch
            .exists
    }
    
    func typeEmail(_ emailText: String) -> Self {
        let email = app.textFields[Identifiers.email]
        email.tap()
        email.typeText(emailText)
        return self
    }
    
    func typePassword(_ passwordText: String) -> Self {
        let password = app.secureTextFields[Identifiers.password]
        password.tap()
        password.typeText(passwordText)
        return self
    }
    
    func tapLogin() -> ItemsPage {
        app.buttons[Identifiers.login].tap()
        return ItemsPage(app: app)
    }
    
    var error: XCUIElement {
        return app.staticTexts[Identifiers.error]
    }
}
