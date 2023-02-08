//
//  FriendsView.swift
//  WishList
//
//  Created by Gian Franco Lopez on 19/01/2023.
//

import SwiftUI

struct FriendsView: View {
    
    @State private var isPresentingModal = false
    
    private let fullFriends: [User] = []
    
    @State private var friends: [User] = [
        User(email: "123", friends: [], imageUrl: "", name: "Gian", privateProfile: false, isFriend: true),
        User(email: "321", friends: [], imageUrl: "", name: "andres", privateProfile: false, isFriend: true),
        User(email: "333", friends: [], imageUrl: "", name: "Asd", privateProfile: false, isFriend: true),
        User(email: "222", friends: [], imageUrl: "", name: "Dsa", privateProfile: false, isFriend: true)
    ]
    
    var body: some View {
        NavigationView {
            List(friends, id: \.id) { friend in
                NavigationLink(destination: FriendBoardScreen(friends: $friends, friend: friend)){
                    HStack {
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding(10)
                            .cornerRadius(20)
                        Text(friend.name)
                            .lineLimit(3)
                    }
                }
                //overlay se sobre escribe arriba
            } .overlay{
                if friends.count == 0 {
                    Text("There are no friends yet. \n Search people and add them as friends to see some friends here.")
                        .fontWeight(.black)
                        .multilineTextAlignment(.center)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isPresentingModal = true
                    }) {
                        Image(systemName: "magnifyingglass").foregroundColor(.white)
                    }
                }
            }
        }.sheet(isPresented: $isPresentingModal) {
            SearchFriendsScreen()
            
        }
    }
}

struct FriendsScreen_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
