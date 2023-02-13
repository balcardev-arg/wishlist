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
    @State private var showingErrorAlert = false
    @State private var errorMessage: String = ""
    
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
            .alert(errorMessage, isPresented: $showingErrorAlert){}
    }
    
    private func presentCreateView() {
        isPresented = true
    }
    
    private func getItems() {
        isLoading = true
        let userId = credentialsManager.userId()
       
        let resource = "/items?userId=\(userId)&authorId=\(userId)"
        
        let request = NetworkManager().createRequest(resource: resource, method: "GET")
        
        NetworkManager().executeRequest(request: request) { (data, error) in
            isLoading = false
            
            guard let data = data,
                  let items = try? JSONDecoder().decode([Item].self, from: data) else {
                errorMessage = error!
                showingErrorAlert = true
                return
            }
            self.items = items
        }
    }
}

struct MyBoardView_Previews: PreviewProvider {
    static var previews: some View {
        MyBoardView()
    }
}
