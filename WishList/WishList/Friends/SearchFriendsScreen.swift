//
//  SearchFriendsScreen.swift
//  WishList
//
//  Created by Layla Cisneros on 24/01/2023.
//

import SwiftUI

struct SearchFriendsScreen: View {
    
    @State private var searchText : String = ""
    @State private var showInitialMessage = true
    
    @State private var fullFakeFriends: [FakeFriend] = []
    
    var body: some View {
        NavigationView(){
            
            if showInitialMessage {
                Text("Type a least 3 characters and \n press enter to perform a \n search of people to add as friends.")
                    .fontWeight(.black)
                    .multilineTextAlignment(.center)
                
            }else {
                List(fullFakeFriends) { friend in
                    NavigationLink(destination: { Text(friend.name)}) {
                        Text("\(friend.id.lowercased())   \(friend.name.lowercased())")
                    }
                }.overlay{
                    if fullFakeFriends.count == 0 {
                        Text("There are not people for this \n criteria. Try again with a \n different name.")
                            .fontWeight(.black)
                            .multilineTextAlignment(.center)
                    }
                }
            }
        }.searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search friends")
            .overlay{
                Button(action: {
                    performSearch("")
                }){Text("LIST") }
            }
        
    }
    
    private func performSearch(_ term: String) {
        fullFakeFriends = [
//        FakeFriend(id: "1", name: "Gian El hombre", urlImage: "", isFriend: false),
//        FakeFriend(id: "2", name: "Andres el come hombre", urlImage: "", isFriend: false),
//        FakeFriend(id: "3", name: "Layla", urlImage: "", isFriend: false),
//        FakeFriend(id: "4", name: "Tu vieja", urlImage: "", isFriend: false)
        ]
        showInitialMessage = false
    }
}

struct SearchFriendsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SearchFriendsScreen()
    }
}
