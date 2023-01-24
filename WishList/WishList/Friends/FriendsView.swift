//
//  FriendsView.swift
//  WishList
//
//  Created by Gian Franco Lopez on 19/01/2023.
//

import SwiftUI

struct FriendsView: View {
    
    @State private var friends: [FakeFriend] = []
    
    private let fullFriends: [FakeFriend] = [
        FakeFriend(id: "1", name: "Gian El hombre", urlImage: "", isFriend: false),
        FakeFriend(id: "2", name: "Andres el come hombre", urlImage: "", isFriend: false),
        FakeFriend(id: "3", name: "Layla", urlImage: "", isFriend: false),
        FakeFriend(id: "4", name: "Tu vieja", urlImage: "", isFriend: false)
    ]
    
    var body: some View {
        NavigationView {
            List(friends, id: \.id) { friend in
                NavigationLink(destination: FriendBoardScreen(friends: $friends,friend: friend)){
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
                        if friends.count == 0 {
                            friends = fullFriends
                        }else {
                            friends = []
                        }
                    }) {
                        Image(systemName: "magnifyingglass").foregroundColor(.white)
                    }
                }
            }
            
        }
    }
}

struct FriendsScreen_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
