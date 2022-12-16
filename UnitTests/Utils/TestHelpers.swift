//
//  TestHelpers.swift
//  ComposableArchitectureDemoProject
//
//  Created by Adam Fallon on 13/12/2022.
//

import Foundation

public struct TestHelpers {
    static let testSetupFailed = "Test setup incorrect, missing rootItem for user"
    
    struct Users {
        static let validUserWithFileAtRoot: User = User(
            firstName: "Adam",
            lastName: "Fallon",
            rootItem: Items.file,
            authString: "dXNlcm5hbWU6cGFzc3dvcmQ="
        )
        
        static let validUserWithFolderAtRoot: User = User(
            firstName: "Adam",
            lastName: "Fallon - Folder",
            rootItem: Items.folder,
            authString: "dXNlcm5hbWU6cGFzc3dvcmQ="
        )

        static let invalidUserWithNoAuthStringWithFile: User = User(
            firstName: "Adam",
            lastName: "File - Invalid - No Auth String",
            rootItem: Items.file,
            authString: nil
        )
        
        static let invalidUserWithNoAuthStringWithFolder: User = User(
            firstName: "Adam",
            lastName: "Fallon - Invalid - No Auth String",
            rootItem: Items.folder,
            authString: nil
        )
        
        static let invalidUserWithNoRootFolder: User = User(
            firstName: "Adam",
            lastName: "Fallon - Invalid - No Root Folder",
            rootItem: nil,
            authString: nil
        )
    }
    
    struct Items {
        static let file: Item = Item(
            contentType: "text/plain",
            id: "singleFile",
            isDir: false,
            modificationDate: "12 Jan 2022",
            name: "My File",
            parentID: nil,
            size: 10.0
        )
        
        static let image: Item = Item(
            contentType: "image/jpeg",
            id: "singleImage",
            isDir: false,
            modificationDate: "12 Jan 2022",
            name: "My File",
            parentID: nil,
            size: 10.0
        )
        
        
        static let childFile: Item = Item(
            contentType: "text/plain",
            id: "childFile",
            isDir: false,
            modificationDate: "13 Feb 2022",
            name: "My Nested File",
            parentID: "parentFolder",
            size: 10.0
        )
        
        static let folder: Item = Item(
            contentType: nil,
            id: "parentFolder",
            isDir: true,
            modificationDate: "12 Jan 2022",
            name: "My Folder",
            parentID: nil,
            size: 10.0
        )
        
        static let childFolder: Item = Item(
            contentType: nil,
            id: "childFolder",
            isDir: true,
            modificationDate: "13 Feb 2022",
            name: "My Nested Folder",
            parentID: "parentFolder",
            size: 10.0
        )
        
        static let grandChildFolder: Item = Item(
            contentType: nil,
            id: "grandChildFolder",
            isDir: true,
            modificationDate: "13 Feb 2022",
            name: "My Deeply Nested Folder",
            parentID: "childFolder",
            size: 10.0
        )
    }
    
    struct Services {
//        static let mockUserClient: UserClient
    }
}
