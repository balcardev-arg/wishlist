//
//  SearchFriendsScreen.swift
//  WishList
//
//  Created by Layla Cisneros on 24/01/2023.
//

import SwiftUI

struct SearchFriendsScreen: View {
    
    @State private var searchText : String = ""
    
    private let fullFakeFriends: [FakeFriend] = [
        FakeFriend(id: "1", name: "Gian El hombre", urlImage: ""),
        FakeFriend(id: "2", name: "Andres el come hombre", urlImage: ""),
        FakeFriend(id: "3", name: "Layla", urlImage: ""),
        FakeFriend(id: "4", name: "Tu vieja", urlImage: "")
    ]
    
    var body: some View {
        NavigationView(){
            List(fullFakeFriends) { friend in
                NavigationLink(destination: { Text(friend.name)}) {
                    Text("\(friend.id)   \(friend.name)")
                }
            }
        }.searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search friends")
        
    }
}

struct FriendBoardScreen_Previews: PreviewProvider {
    static var previews: some View {
        SearchFriendsScreen()
    }
}
