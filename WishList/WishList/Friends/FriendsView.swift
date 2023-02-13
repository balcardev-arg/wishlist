//
//  FriendsView.swift
//  WishList
//
//  Created by Gian Franco Lopez on 19/01/2023.
//

import SwiftUI

struct FriendsView: View {
    
    @State private var isPresentingModal = false
    @State private var friends: [User] = []
    @State private var isLoading: Bool = false
    @State private var showingErrorAlert = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                List(friends, id: \.id) { friend in
                    FriendCell(friends: $friends, friend: friend)
                }.overlay{
                    if friends.count == 0 {
                        Text("There are no friends yet. Search people and add them as friends to see some friends here.")
                            .fontWeight(.black)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            isPresentingModal = true
                        }) {
                            Image(systemName: "magnifyingglass").foregroundColor(.black)
                        }
                    }
                }
                if isLoading {
                    ModalProgressView()
                }
            }
            
        }.sheet(isPresented: $isPresentingModal) {
            SearchFriendsScreen()
            
        }.onAppear{
            searchFriends()
        }
        .alert(errorMessage, isPresented: $showingErrorAlert){}
    }
    
    private func searchFriends(){
        guard let url = URL(string: "\(Configuration.baseUrl)/friends?userId=\(CredentialsManager().userId())") else{
            errorMessage = Configuration.genericErrorMessage
            showingErrorAlert = true
            return
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        isLoading = true
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            isLoading = false
            guard let httpResponse = response as? HTTPURLResponse else {
                errorMessage = Configuration.genericErrorMessage
                showingErrorAlert = true
                return
            }
            if httpResponse.statusCode == 200 {
                guard let data = data,
                      let friends = try? JSONDecoder().decode([User].self, from: data) else {
                    errorMessage = Configuration.genericErrorMessage
                    showingErrorAlert = true
                    return
                }
                self.friends = friends
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

struct FriendsScreen_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
