//
//  MyBoardView.swift
//  WishList
//
//  Created by Layla Cisneros on 16/01/2023.
//

import SwiftUI

struct MyBoardView: View {
    
    @State private var items: [FakeItem] = []
   
    @State private var fullItems = [
        FakeItem(id: 1, name: "Pava electrica", precio: 1000, description: "11111Description of the product. Should have 3 lines and an elipsis at the end if it is too long like this sample description"),
        FakeItem(id: 2, name: "Sillon", precio: 2000, description: "22222Description of the product. Should have 3 lines and an elipsis at the end if it is too long like this sample description"),
        FakeItem(id: 3, name: "Smart TV", precio: 3000, description: "333333Description of the product. Should have 3 lines and an elipsis at the end if it is too long like this sample description"),
        FakeItem(id: 4, name: "Cafetera", precio: 4000, description: "44444Description of the product. Should have 3 lines and an elipsis at the end if it is too long like this sample description")
    ]
    
    var body: some View {
        
        NavigationView {
            List(items) { item in
                NavigationLink(destination: ItemDetailsScreenUI(items: $items, item: item)) {
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
                            if items.count == 0 {
                                items = fullItems
                            }else {
                                self.items = []
                            }
                        }) {
                            Image(systemName: "plus").foregroundColor(.black)
                        }
                    }
                }
            
        }.accentColor(.black)
    }
}

struct MyBoardView_Previews: PreviewProvider {
    static var previews: some View {
        MyBoardView()
    }
}
