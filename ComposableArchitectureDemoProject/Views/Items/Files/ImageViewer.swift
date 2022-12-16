//
//  ImageViewer.swift
//  ComposableArchitectureDemoProject
//
//  Created by Adam Fallon on 14/12/2022.
//

import SwiftUI
import Foundation

struct ImageViewer: View {
    var data: Data?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.ignoresSafeArea()
                Image(data: data)?
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .accessibilityIdentifier("image")
            }
        }
    }
}

extension Image {
    init?(data: Data?) {
        guard let data = data else {
            return nil
        }
        
        if let uiImage = UIImage(data: data) {
            self.init(uiImage: uiImage)
        } else {
            return nil
        }
    }
}
