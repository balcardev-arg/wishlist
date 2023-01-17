//
//  MyBoardView.swift
//  WishList
//
//  Created by Layla Cisneros on 16/01/2023.
//

import SwiftUI

struct MyBoardView: View {
    
    private let items = [
        FakeItem(id: 1, name: "Pava electrica", precio: 1000, description: "Description of the product. Should have 3 lines and an elipsis at the end if it is too long like this sample description"),
        FakeItem(id: 2, name: "Sillon", precio: 2000, description: "Description of the product. Should have 3 lines and an elipsis at the end if it is too long like this sample description"),
        FakeItem(id: 3, name: "Smart TV", precio: 3000, description: "Description of the product. Should have 3 lines and an elipsis at the end if it is too long like this sample description"),
        FakeItem(id: 4, name: "Cafetera", precio: 4000, description: "Description of the product. Should have 3 lines and an elipsis at the end if it is too long like this sample description")
    ]
    
    var body: some View {
        NavigationView {
            List(items) { item in
                NavigationLink(destination: Text(item.description)) {
                    HStack {
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding(10)
                            .cornerRadius(20)
                        Text(item.description)
                    }
                }
            }.listStyle(.grouped)
                .navigationTitle("My board")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {}) {
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
