//
//  MyBoardView.swift
//  WishList
//
//  Created by Layla Cisneros on 16/01/2023.
//

import SwiftUI

struct MyBoardView: View {
    
    private let credentialsManager = CredentialsManager()
    
    @State private var isPresented = false
    
    @State private var items: [Item] = []
    @State private var isLoading = false
    var body: some View {
        
        NavigationView {
            ZStack {
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
                    CreateItemScreen(items: $items)
                }
                if isLoading {
                    ModalProgressView()
                }
            }
        }.accentColor(.black)
            .onAppear {
                getItems()
            }
    }
    
    private func presentCreateView() {
        isPresented = true
    }
    
    private func getItems() {
        
        isLoading = true
        let userId = credentialsManager.userId()
        
        guard let url = URL(string:
            "\(Configuration.baseUrl)/items?userId=\(userId)&authorId=\(userId)") else {
            return
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            isLoading = false
            guard let data = data,
                  let items = try? JSONDecoder().decode([Item].self, from: data) else {
                return
            }
            
            self.items = items
        }.resume()
    }
}

struct MyBoardView_Previews: PreviewProvider {
    static var previews: some View {
        MyBoardView()
    }
}
