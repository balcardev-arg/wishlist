//
//  MyBoardView.swift
//  WishList
//
//  Created by Layla Cisneros on 16/01/2023.
//

import SwiftUI

struct MyBoardView: View {
    
    @State private var isPresented = false
    
    @State private var items: [Item] = []
   
    private let fullItems = [
        Item(id: "1", url: "", imageUrl: "", author: "", description: ""),
        Item(id: "2", url: "", imageUrl: "", author: "", description: ""),
        Item(id: "3", url: "", imageUrl: "", author: "", description: "")
    ]
    
    var body: some View {
        
        NavigationView {
            List(items) { item in
                ItemCell(items: $items, item: item)
            }.overlay(alignment: .center){
                if items.count == 0 {
                    Text("There are not items yet. \n Add items to start a wish list")
                        .fontWeight(.black)
                        .multilineTextAlignment(.center)
                }
            }
            .listStyle(.grouped)
            .navigationTitle("My board")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isPresented = true
                    }) {
                        Image(systemName: "plus").foregroundColor(.black)
                    }
                }
            }.sheet(isPresented: $isPresented) {
                CreateItemScreen()
            }
            
        }.accentColor(.black)
    }
    
    private func presentCreateView() {
        isPresented = true
    }
}

struct MyBoardView_Previews: PreviewProvider {
    static var previews: some View {
        MyBoardView()
    }
}
