//
//  ItemListView.swift
//  ComposableArchitectureDemoProject
//
//  Created by Adam Fallon on 14/12/2022.
//

import ComposableArchitecture
import SwiftUI

struct ItemListView: View {
    let store: StoreOf<ItemsStore>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { store in
            VStack {
                store.items.isEmpty ?
                Text("No Files in here...")
                    .padding()
                    .foregroundColor(.gray)
                : nil
                                                
                List (store.items) { item in
                    VStack {
                        ItemListCell(item: item)
                            .onTapGesture {
                                store.send(.tapItem(item))
                            }
                    }
                    .accessibilityIdentifier("item-\(item.id)")
                }
                .accessibilityIdentifier("itemList")
            }
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    if store.prevItems.count > 0 {
                        Button("Back") {
                            store.send(.navigateBack)
                        }
                        .accessibilityIdentifier("backButton")
                    }
                }
            })
            .sheet(isPresented: store.binding(
                get: \.isSheetPresented,
                send: ItemsStore.Action.setSheet(isPresented:)
            )) {
                switch FileType(item: store.selectedItem) {
                case .image:
                    ImageViewer(data: store.data)
                default:
                    Text("We don't support that file type yet!")
                        .accessibilityIdentifier("notSupportedText")
                }
            }
        }
    }
}
