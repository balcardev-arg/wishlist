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
            getFriends()
        }
        .alert(errorMessage, isPresented: $showingErrorAlert){}
    }
    
    private func getFriends(){
        
        let request = NetworkManager().createRequest(resource: "/friends?userId=\(CredentialsManager().userId())", method: "GET")
        
        isLoading = true
        
        NetworkManager().executeRequest(request: request) { (data, error) in
            isLoading = false
            guard let data = data,
                  let friends = try? JSONDecoder().decode([User].self, from: data) else {
                errorMessage = error!
                showingErrorAlert = true
                return
            }

            self.friends = friends
        }
    }
}

struct FriendsScreen_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
