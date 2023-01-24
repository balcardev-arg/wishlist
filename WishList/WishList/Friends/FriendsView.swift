//
//  FriendsView.swift
//  WishList
//
//  Created by Gian Franco Lopez on 19/01/2023.
//

import SwiftUI

struct FriendsView: View {
    
    @State private var isPresentingModal = false
    
    @State private var friends: [FakeFriend] = []
    private let fullFriends: [FakeFriend] = [
        FakeFriend(id: "1", name: "Gian El hombre", urlImage: ""),
        FakeFriend(id: "2", name: "Andres el come hombre", urlImage: ""),
        FakeFriend(id: "3", name: "Layla", urlImage: ""),
        FakeFriend(id: "4", name: "Tu vieja", urlImage: "")
    ]
    
    var body: some View {
        NavigationView {
            List(friends, id: \.id) { friend in
                NavigationLink(destination: {Text("Friend Profile")}){
                    HStack {
                        Image(systemName: "photo")
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
                        Image(systemName: "magnifyingglass").foregroundColor(.black)
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
