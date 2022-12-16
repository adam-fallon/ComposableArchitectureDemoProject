//
//  TestItemsClient.swift
//  ComposableArchitectureDemoProject
//
//  Created by Adam Fallon on 14/12/2022.
//

import Foundation
import Dependencies

extension ItemsClient {
    static let test = ItemsClient(
        getItemsForItem: { item, auth in            
            let files: [String: [Item]] = [
                "singleFile": [],
                "parentFolder": [
                    TestHelpers.Items.childFile,
                    TestHelpers.Items.childFolder
                ],
                "childFile": [],
                "childFolder": [
                    TestHelpers.Items.grandChildFolder
                ]
            ]
            
            if let files = files[item.id], !files.isEmpty {
                return files
            } else {
                throw ItemsClientError.itemsNotFound(item.id)
            }
        }, getDataForItem: { _, _ in            
            return Data()
        })
}

extension ItemsClient: TestDependencyKey {
    static let testValue = ItemsClient.test
}
