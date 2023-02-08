//
//  FriendBoardScreen.swift
//  WishList
//
//  Created by Gian Franco Lopez on 24/01/2023.
//

import SwiftUI

struct FriendBoardScreen: View {
    
    @State private var friendItems: [Item] = [
        Item(id: "1", url: "www...", imageUrl: "perrito", authorId: "Andres", description: ""),
        Item(id: "2", url: "www...", imageUrl: "michi", authorId: "Gian", description: "www..."),
        Item(id: "3", url: "", imageUrl: "mango", authorId: "Lay", description: "")
        
    ]
    @Binding var friends: [User]
    @State var friend: User
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(systemName: "person.fill").resizable()
                        .frame(width: 150,height: 150)
                        .background(.gray)
                        .clipShape(Circle())
                    Spacer()
                    Text(friend.name)
                        .padding(50)
                        .fontWeight(.black)
                        .multilineTextAlignment(.center)
                }
                List(friendItems) { item in
                    ItemCell(items: $friendItems, item: item)
                }.overlay {
                    if (friendItems.count == 0) {
                        Text("This person has no items yet!")
                            .fontWeight(.black)
                            .multilineTextAlignment(.center)
                    }
                }
            }.background(.gray.opacity(0.2))
            
            
        }.accentColor(.black)
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(action: {
                    //friend.isFriend = !friend.isFriend
                }){
                    Image(systemName: "person.crop.circle.badge.minus.fill")
//                    Image(systemName: friend.isFriend ? "person.crop.circle.badge.minus.fill" : "person.crop.circle.badge.plus.fill"  )
                }
            
            }
        }
        .accentColor(.black)
    }
    
}

struct FriendBoardScreen_Previews: PreviewProvider {
    @State static var currentFriend = User(email: "", friends: [], imageUrl: "", name: "", privateProfile: false, isFriend: true)
    @State static var fakeFriends: [User] = [User(email: "", friends: [], imageUrl: "", name: "", privateProfile: false, isFriend: true)]
    static var previews: some View {
        FriendBoardScreen(friends: $fakeFriends, friend: currentFriend)
    }
}
