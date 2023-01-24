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
   
    private let fullItems = [
        FakeItem(id: 1, name: "Pava electrica", precio: 1000, description: "11111Description of the product. Should have 3 lines and an elipsis at the end if it is too long like this sample description"),
        FakeItem(id: 2, name: "Sillon", precio: 2000, description: "22222Description of the product. Should have 3 lines and an elipsis at the end if it is too long like this sample description"),
        FakeItem(id: 3, name: "Smart TV", precio: 3000, description: "333333Description of the product. Should have 3 lines and an elipsis at the end if it is too long like this sample description"),
        FakeItem(id: 4, name: "Cafetera", precio: 4000, description: "44444Description of the product. Should have 3 lines and an elipsis at the end if it is too long like this sample description"),
        FakeItem(id: 5, name: "Pava electrica", precio: 1000, description: "111112Description of the product. Should have 3 lines and an elipsis at the end if it is too long like this sample description"),
        FakeItem(id: 6, name: "Sillon", precio: 2000, description: "222223Description of the product. Should have 3 lines and an elipsis at the end if it is too long like this sample description"),
        FakeItem(id: 7, name: "Smart TV", precio: 3000, description: "3333334Description of the product. Should have 3 lines and an elipsis at the end if it is too long like this sample description"),
        FakeItem(id: 8, name: "Cafetera", precio: 4000, description: "444445Description of the product. Should have 3 lines and an elipsis at the end if it is too long like this sample description")
    ]
    
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
