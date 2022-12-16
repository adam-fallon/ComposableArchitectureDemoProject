//
//  ItemsPage.swift
//  UITests
//
//  Created by Adam Fallon on 14/12/2022.
//

import Foundation
import XCTest

struct ItemsPage: PageObject {
    var app: XCUIApplication
    
    private enum Identifiers {
        static let itemList = "itemList"
        static let backButton = "backButton"
    }
    
    var isShowing: Bool {
        return app
            .staticTexts
            .matching(NSPredicate(format: "label CONTAINS 'Files'"))
            .firstMatch
            .exists
    }
    
    func tapItem(_ named: String) -> ItemDetailPage {
        app.staticTexts[named].firstMatch.tap()
        return ItemDetailPage(app: app)
    }
    
    func file(_ named: String) -> XCUIElement {
        return app.staticTexts[named].firstMatch
    }
    
    var backButton: XCUIElement {
        return app.buttons[Identifiers.backButton]
    }
    
    func tapBack() -> ItemsPage {
        backButton.tap()
        return ItemsPage(app: app)
    }
}
