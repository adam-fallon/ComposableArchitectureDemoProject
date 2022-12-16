//
//  ItemsUITestCase.swift
//  UITests
//
//  Created by Adam Fallon on 14/12/2022.
//

import XCTest

final class ItemsUITestCase: BaseTestCase {
    override func setUp() {
        super.setUp()
    }
    
    func testListWithUserWithSingleFile() throws {
        let login = LoginPage(app: self.app)
        XCTAssertTrue(login.isShowing)
        
        let files = login
                .typeEmail("file")
                .typePassword("password123")
                .tapLogin()
        
        XCTAssertTrue(files.isShowing)
        
        let item = files.tapItem("My File")
        XCTAssertTrue(item.isShowing)
    }
    
    func testListWithUserWithFolder() throws {
        let login = LoginPage(app: self.app)
        XCTAssertTrue(login.isShowing)
        
        let files = login
                .typeEmail("folder")
                .typePassword("password123")
                .tapLogin()
        
        XCTAssertTrue(files.isShowing)
        
        let _ = files.tapItem("My Folder")
        
        XCTAssertTrue(files.isShowing)
    }
    
    func testListWithUserWithDeeplyNestedFolder() throws {
        let login = LoginPage(app: self.app)
        XCTAssertTrue(login.isShowing)
        
        let files = login
                .typeEmail("folder")
                .typePassword("password123")
                .tapLogin()
        
        XCTAssertTrue(files.isShowing)
        
        let _ = files.tapItem("My Folder")
        
        XCTAssertTrue(files.isShowing)
        
        let _ = files.tapItem("My Nested Folder")
        XCTAssertTrue(files.file("My Deeply Nested Folder").exists)
        let _ = files.tapBack()
        
        XCTAssertTrue(files.isShowing)
        XCTAssertTrue(files.file("My Nested Folder").exists)
        
        let _ = files.tapBack()
        XCTAssertTrue(files.isShowing)
        XCTAssertTrue(files.file("My Folder").exists)
    }
}
