//
//  FileType.swift
//  ComposableArchitectureDemoProject
//
//  Created by Adam Fallon on 14/12/2022.
//

import Foundation

enum FileType: String {
    case image = "image/jpeg"
    case plainText = "text/plain"
    case unknown = "unknown"
}

extension FileType {
    init(item: Item?) {
        if let item = item,
           let contentType = item.contentType,
           let type = FileType(rawValue: contentType) {
            self = type
        } else {
            self = .unknown
        }
    }
}
