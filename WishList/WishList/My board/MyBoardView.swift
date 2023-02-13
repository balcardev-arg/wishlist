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
        
        guard let url = URL(string:
            "\(Configuration.baseUrl)/items?userId=\(userId)&authorId=\(userId)") else {
            errorMessage = Configuration.genericErrorMessage
            showingErrorAlert = true
            return
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            isLoading = false
            guard let httpResponse = response as? HTTPURLResponse else {
                errorMessage = Configuration.genericErrorMessage
                showingErrorAlert = true
                return
            }
            if httpResponse.statusCode == 200 {
                guard let data = data,
                      let items = try? JSONDecoder().decode([Item].self, from: data) else {
                    return
                }
                self.items = items
            } else {
                guard let data = data,
                      let errorDictionary = try? JSONDecoder().decode([String:String].self, from: data) else {
                    errorMessage = Configuration.genericErrorMessage
                    showingErrorAlert = true
                    return
                }
                errorMessage = errorDictionary["error"] ?? Configuration.genericErrorMessage
                showingErrorAlert = true
            }
        }.resume()
    }
}

struct MyBoardView_Previews: PreviewProvider {
    static var previews: some View {
        MyBoardView()
    }
}
