//
//  PageObject.swift
//  UITests
//
//  Created by Adam Fallon on 14/12/2022.
//

import Foundation
import XCTest

protocol PageObject {
    var app: XCUIApplication { get }
    var isShowing: Bool { get }
}
