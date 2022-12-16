//
//  LoginUITestCase.swift
//  UITests
//
//  Created by Adam Fallon on 14/12/2022.
//

import XCTest

final class LoginUITestCase: BaseTestCase {
    override func setUp() {        
        super.setUp()
    }
    
    func testLoginHappyPath() {
        let login = LoginPage(app: self.app)
        XCTAssertTrue(login.isShowing)
        
        let files = login
                .typeEmail("file")
                .typePassword("password123")
                .tapLogin()
        
        XCTAssertTrue(files.isShowing)
    }
    
    func testLoginShowsErrorWhenNoUserNamePasswordProvided() {
        let login = LoginPage(app: self.app)
        XCTAssertTrue(login.isShowing)
        
        let _ = login.tapLogin()
        
        XCTAssertTrue(login.error.exists)
        XCTAssertEqual(login.error.label, "Login failed.")
    }
    
    func testLoginShowsErrorForInvalidUser() {
        let login = LoginPage(app: self.app)
        XCTAssertTrue(login.isShowing)
        
        let _ = login
            .typeEmail("Doesn't Exist")
            .typePassword("Fake Password")
            .tapLogin()
        
        XCTAssertTrue(login.error.exists)
        XCTAssertEqual(login.error.label, "Login failed.")
    }
    
}

final class LoginUITestCaseServiceDown: BaseTestCase {
    override func setUp() {
        super.launchArgs.append("UserServiceDown")
        super.setUp()
    }
    
    func testLoginShowsErrorWhenFailedToConnectToService() {
        let login = LoginPage(app: self.app)
        XCTAssertTrue(login.isShowing)
        
        let _ = login
            .typeEmail("Doesn't Exist")
            .typePassword("Fake Password")
            .tapLogin()
        
        XCTAssertTrue(login.error.exists)
        XCTAssertEqual(login.error.label, "Oops, something went wrong. Please try again.")
    }
}
