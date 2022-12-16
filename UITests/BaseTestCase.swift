//
//  BaseTestCase.swift
//  UITests
//
//  Created by Adam Fallon on 14/12/2022.
//

import Foundation
import XCTest

class BaseTestCase: XCTestCase {
    let app = XCUIApplication()
    var launchArgs = ["isRunningUITests"]
    
    override func setUp() {
        continueAfterFailure = false
        app.launchArguments = launchArgs
        app.launch()        
    }
}
