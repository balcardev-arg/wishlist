//
//  MyBoardView.swift
//  WishList
//
//  Created by Layla Cisneros on 16/01/2023.
//

import SwiftUI

struct MyBoardView: View {
    
    @State private var isPresented = false
    
    @State private var items: [FakeItem] = []
    
    var body: some View {
        
        NavigationView {
            List(items) { item in
                NavigationLink(destination: ItemDetailsScreen(items: $items, item: item)) {
                    HStack {
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding(10)
                            .cornerRadius(20)
                        Text(item.description)
                            .lineLimit(3)
                    }
                }
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
                }.sheet(isPresented : $isPresented, onDismiss: {isPresented = false}, content: { CreateItemScreen()})
            
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
