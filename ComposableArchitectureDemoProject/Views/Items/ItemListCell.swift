//
//  ItemListCell.swift
//  ComposableArchitectureDemoProject
//
//  Created by Adam Fallon on 14/12/2022.
//

import SwiftUI

struct ItemListCell: View {
    var item: Item
    
    var body: some View {
        VStack {
            HStack {
                iconForFileType(item: item)
                    .font(.system(size: 24))
                    .padding()
                VStack(alignment: .leading) {
                    Text(item.name)
                }
            }
        }
    }
    
    func iconForFileType(item: Item) -> Image {
        guard !item.isDir else {
            return Image(systemName: "folder.fill")
        }
        
        guard let contentType = item.contentType else {
            return Image(systemName: "questionmark.app.fill")
        }
        
        switch FileType(rawValue: contentType) {
        case .image:
            return Image(systemName: "photo.fill")
        case .plainText:
            return Image(systemName: "doc.fill")
        default:
            return Image(systemName: "questionmark.app.fill")
        }
    }
}
