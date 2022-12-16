//
//  ItemDetailPage.swift
//  UITests
//
//  Created by Adam Fallon on 14/12/2022.
//

import Foundation
import XCTest

struct ItemDetailPage: PageObject {
    var app: XCUIApplication
    
    private enum Identifiers {
        static let notSupportedText = "notSupportedText"
        static let image = "image"
    }
    
    var notSupportedText: XCUIElement {
        return app.staticTexts[Identifiers.notSupportedText].firstMatch
    }
    
    var image: XCUIElement {
        return app.images[Identifiers.image].firstMatch
    }
    
    var isShowing: Bool {
        return notSupportedText.exists || image.exists
    }
}
